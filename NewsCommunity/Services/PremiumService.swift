import Foundation

// MARK: - 프리미엄 서비스 — 모든 기능 무료 해제
@MainActor
final class PremiumService: ObservableObject {
    /// 싱글톤 인스턴스
    static let shared = PremiumService()

    /// 프리미엄 상태 (항상 활성)
    @Published var premiumStatus = PremiumStatus(isActive: true)

    /// 에러 메시지
    @Published var errorMessage: String?

    init() {}
}
