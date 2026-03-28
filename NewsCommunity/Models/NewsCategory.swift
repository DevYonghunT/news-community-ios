import SwiftUI

// MARK: - 뉴스 카테고리 정의
enum NewsCategory: String, CaseIterable, Identifiable, Codable {
    case technology = "technology"
    case business = "business"
    case entertainment = "entertainment"
    case sports = "sports"
    case health = "health"
    case science = "science"
    case politics = "politics"
    case world = "world"

    var id: String { rawValue }

    /// 한국어 표시 이름
    var displayName: String {
        switch self {
        case .technology: return "기술"
        case .business: return "경제"
        case .entertainment: return "연예"
        case .sports: return "스포츠"
        case .health: return "건강"
        case .science: return "과학"
        case .politics: return "정치"
        case .world: return "세계"
        }
    }

    /// SF Symbol 아이콘 이름
    var iconName: String {
        switch self {
        case .technology: return "cpu"
        case .business: return "chart.line.uptrend.xyaxis"
        case .entertainment: return "film"
        case .sports: return "sportscourt"
        case .health: return "heart.fill"
        case .science: return "atom"
        case .politics: return "building.columns"
        case .world: return "globe"
        }
    }

    /// 카테고리 색상
    var color: Color {
        AppColor.categoryColor(for: self)
    }
}
