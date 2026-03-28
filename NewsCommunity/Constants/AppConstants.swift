import SwiftUI

// MARK: - 앱 상수 정의
enum AppConstants {
    /// 무료 사용자 북마크 제한 수
    static let freeBookmarkLimit: Int = 10

    /// 프리미엄 월간 구독 가격
    static let premiumMonthlyPrice: String = "$2.99"

    /// 프리미엄 월간 구독 상품 ID
    static let premiumProductID: String = "com.entangle.newscommunity.premium.monthly"

    /// 앱 이름
    static let appName: String = "News Community"
}

// MARK: - 앱 색상 정의
enum AppColor {
    /// 기본 색상 (레드/코럴)
    static let primary = Color(hex: "#E74C3C")

    /// 보조 색상 (블루)
    static let secondary = Color(hex: "#3498DB")

    /// 강조 색상 (오렌지/골드)
    static let accent = Color(hex: "#F39C12")

    /// 배경 색상
    static let background = Color(hex: "#0F0F0F")

    /// 보조 배경 색상
    static let secondaryBackground = Color(hex: "#1A1A2E")

    /// 카드 배경 색상
    static let cardBackground = Color(hex: "#252540")

    /// 기본 텍스트 색상
    static let textPrimary = Color.white

    /// 보조 텍스트 색상
    static let textSecondary = Color(hex: "#B0B0B0")

    /// 카테고리별 색상 반환
    static func categoryColor(for category: NewsCategory) -> Color {
        switch category {
        case .technology:
            return Color(hex: "#3498DB")
        case .business:
            return Color(hex: "#2ECC71")
        case .entertainment:
            return Color(hex: "#E74C3C")
        case .sports:
            return Color(hex: "#F39C12")
        case .health:
            return Color(hex: "#1ABC9C")
        case .science:
            return Color(hex: "#9B59B6")
        case .politics:
            return Color(hex: "#E67E22")
        case .world:
            return Color(hex: "#34495E")
        }
    }
}
