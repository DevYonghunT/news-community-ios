import SwiftUI

// MARK: - 프리미엄 구매 뷰
/// 프리미엄 혜택 안내 및 구독 구매 화면
struct PremiumView: View {
    @EnvironmentObject var premiumService: PremiumService
    @Environment(\.dismiss) private var dismiss

    /// 구매 진행 중 상태
    @State private var isPurchasing: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // MARK: - 헤더
                    headerSection

                    // MARK: - 혜택 목록
                    benefitsSection

                    // MARK: - 가격 및 구매 버튼
                    purchaseSection

                    // MARK: - 이미 프리미엄인 경우
                    if premiumService.premiumStatus.isActive {
                        activeLabel
                    }
                }
                .padding(24)
            }
            .background(AppColor.background)
            .navigationTitle("프리미엄")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("닫기") {
                        dismiss()
                    }
                    .foregroundColor(AppColor.textSecondary)
                }
            }
        }
    }

    // MARK: - 헤더 섹션
    private var headerSection: some View {
        VStack(spacing: 16) {
            // 왕관 아이콘
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                AppColor.accent.opacity(0.3),
                                AppColor.accent.opacity(0.05)
                            ]),
                            center: .center,
                            startRadius: 20,
                            endRadius: 60
                        )
                    )
                    .frame(width: 120, height: 120)

                Image(systemName: "crown.fill")
                    .font(.system(size: 48))
                    .foregroundColor(AppColor.accent)
            }

            Text("News Community Premium")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppColor.textPrimary)

            Text("더 나은 뉴스 경험을 위한 프리미엄 구독")
                .font(.subheadline)
                .foregroundColor(AppColor.textSecondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - 혜택 목록
    private var benefitsSection: some View {
        VStack(spacing: 16) {
            benefitRow(
                icon: "xmark.circle",
                title: "광고 완전 제거",
                description: "방해 없는 깨끗한 뉴스 읽기"
            )

            benefitRow(
                icon: "bookmark.fill",
                title: "무제한 북마크",
                description: "원하는 만큼 기사를 저장하세요"
            )

            benefitRow(
                icon: "star.fill",
                title: "독점 콘텐츠",
                description: "프리미엄 전용 심층 분석 기사"
            )

            benefitRow(
                icon: "bell.fill",
                title: "우선 알림",
                description: "속보를 가장 먼저 받아보세요"
            )
        }
        .padding(20)
        .background(AppColor.cardBackground)
        .cornerRadius(16)
    }

    /// 개별 혜택 행
    private func benefitRow(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(AppColor.accent)
                .frame(width: 32, height: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColor.textPrimary)

                Text(description)
                    .font(.caption)
                    .foregroundColor(AppColor.textSecondary)
            }

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(AppColor.accent.opacity(0.7))
        }
    }

    // MARK: - 가격 및 구매 버튼
    private var purchaseSection: some View {
        VStack(spacing: 12) {
            // 가격 표시
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(AppConstants.premiumMonthlyPrice)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(AppColor.textPrimary)
                Text("/ 월")
                    .font(.subheadline)
                    .foregroundColor(AppColor.textSecondary)
            }

            // 구매 버튼
            Button {
                purchasePremium()
            } label: {
                HStack {
                    if isPurchasing {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text(premiumService.premiumStatus.isActive ? "구독 중" : "프리미엄 시작하기")
                            .fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            }
            .buttonStyle(GlowButtonStyle())
            .disabled(premiumService.premiumStatus.isActive || isPurchasing)

            // 안내 문구
            Text("언제든지 구독을 취소할 수 있습니다")
                .font(.caption2)
                .foregroundColor(AppColor.textSecondary)
        }
    }

    // MARK: - 이미 프리미엄 활성 라벨
    private var activeLabel: some View {
        HStack {
            Image(systemName: "checkmark.seal.fill")
                .foregroundColor(AppColor.accent)
            Text("프리미엄이 활성화되어 있습니다")
                .font(.subheadline)
                .foregroundColor(AppColor.accent)
        }
        .padding(12)
        .background(AppColor.accent.opacity(0.1))
        .cornerRadius(10)
    }

    /// 프리미엄 구매 처리
    private func purchasePremium() {
        guard let product = premiumService.products.first else { return }
        isPurchasing = true
        Task {
            await premiumService.purchase(product)
            isPurchasing = false
        }
    }
}
