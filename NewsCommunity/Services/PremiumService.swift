import Foundation
import StoreKit
import os

// MARK: - 프리미엄 구독 서비스 (StoreKit 2)
@MainActor
final class PremiumService: ObservableObject {
    private nonisolated static let logger = Logger(
        subsystem: "com.entangle.newscommunity",
        category: "PremiumService"
    )

    /// 싱글톤 인스턴스
    static let shared = PremiumService()

    /// 프리미엄 상태
    @Published var premiumStatus = PremiumStatus(isActive: false)

    /// 사용 가능한 상품 목록
    @Published var products: [Product] = []

    /// 구매 진행 중 여부
    @Published var isPurchasing: Bool = false

    /// 에러 메시지
    @Published var errorMessage: String?

    /// 트랜잭션 리스너 태스크
    private var transactionListener: Task<Void, Never>?

    init() {
        transactionListener = listenForTransactions()
        Task {
            await loadProducts()
            await updatePurchaseStatus()
        }
    }

    deinit {
        transactionListener?.cancel()
    }

    // MARK: - 상품 로드

    /// App Store에서 상품 정보 로드
    func loadProducts() async {
        do {
            let productIDs = [AppConstants.premiumProductID]
            products = try await Product.products(for: productIDs)
        } catch {
            errorMessage = "상품 로드 실패: \(error.localizedDescription)"
        }
    }

    // MARK: - 구매

    /// 프리미엄 구독 구매
    /// - Parameter product: 구매할 상품
    func purchase(_ product: Product) async {
        isPurchasing = true
        errorMessage = nil

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    await transaction.finish()
                    await updatePurchaseStatus()
                case .unverified(let transaction, let error):
                    await transaction.finish()
                    errorMessage = "구매 검증 실패. 잠시 후 다시 시도해주세요."
                    Self.logger.error("구매 거래 검증 실패: \(error.localizedDescription)")
                }

            case .userCancelled:
                break

            case .pending:
                errorMessage = "구매 승인 대기 중입니다."

            @unknown default:
                errorMessage = "알 수 없는 구매 결과입니다."
            }
        } catch {
            errorMessage = "구매 실패: \(error.localizedDescription)"
        }

        isPurchasing = false
    }

    // MARK: - 구매 복원

    /// 이전 구매 복원
    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchaseStatus()
        } catch {
            errorMessage = "구매 복원 실패: \(error.localizedDescription)"
        }
    }

    // MARK: - 구매 상태 업데이트

    /// 현재 구독 상태 확인 및 업데이트
    func updatePurchaseStatus() async {
        var isActive = false

        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction):
                if transaction.productID == AppConstants.premiumProductID {
                    isActive = true
                }
            case .unverified(let transaction, let error):
                await transaction.finish()
                Self.logger.error("구독 상태 확인 중 거래 검증 실패: \(error.localizedDescription)")
            }
        }

        premiumStatus = PremiumStatus(isActive: isActive)
    }

    // MARK: - 트랜잭션 리스너

    /// 백그라운드 트랜잭션 변경 감지
    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                guard let self else { return }
                switch result {
                case .verified(let transaction):
                    await transaction.finish()
                    await self.updatePurchaseStatus()
                case .unverified(let transaction, let error):
                    await transaction.finish()
                    Self.logger.error("거래 검증 실패: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - 검증

    /// 트랜잭션 검증
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error):
            throw error
        case .verified(let safe):
            return safe
        }
    }
}
