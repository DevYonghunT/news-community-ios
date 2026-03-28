import Foundation
import os

// MARK: - 글꼴 크기 설정
enum FontSize: String, Codable, CaseIterable {
    case small = "small"
    case medium = "medium"
    case large = "large"

    /// 본문 글꼴 크기 (포인트)
    var bodySize: CGFloat {
        switch self {
        case .small: return 14
        case .medium: return 16
        case .large: return 20
        }
    }

    /// 한국어 표시 이름
    var displayName: String {
        switch self {
        case .small: return "작게"
        case .medium: return "보통"
        case .large: return "크게"
        }
    }
}

// MARK: - 사용자 환경설정
struct UserPreferences: Codable {
    /// 선택된 카테고리 목록
    var selectedCategories: [NewsCategory]
    /// 글꼴 크기
    var fontSize: FontSize

    /// UserDefaults 저장 키
    private static let storageKey = "userPreferences"

    /// 기본값
    init(
        selectedCategories: [NewsCategory] = NewsCategory.allCases.map { $0 },
        fontSize: FontSize = .medium
    ) {
        self.selectedCategories = selectedCategories
        self.fontSize = fontSize
    }

    /// UserDefaults에서 환경설정 로드
    static func load() -> UserPreferences {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return UserPreferences()
        }
        do {
            let preferences = try JSONDecoder().decode(UserPreferences.self, from: data)
            return preferences
        } catch {
            return UserPreferences()
        }
    }

    /// UserDefaults에 환경설정 저장
    func save() {
        do {
            let data = try JSONEncoder().encode(self)
            UserDefaults.standard.set(data, forKey: UserPreferences.storageKey)
        } catch {
            Logger(subsystem: "com.entangle.newscommunity", category: "Preferences").error("환경설정 저장 실패: \(error.localizedDescription)")
        }
    }
}
