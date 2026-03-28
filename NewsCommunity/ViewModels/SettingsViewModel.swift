import Foundation
import os

// MARK: - 설정 뷰모델
/// 사용자 설정 화면의 상태 관리 및 비즈니스 로직 담당
@MainActor
final class SettingsViewModel: ObservableObject {

    // MARK: - 게시 프로퍼티

    /// 사용자 환경설정
    @Published var preferences: UserPreferences

    // MARK: - 의존성

    /// 프리미엄 서비스
    var premiumService: PremiumService

    // MARK: - 읽기 전용 프로퍼티

    /// 앱 버전 문자열
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    // MARK: - 초기화

    /// SettingsViewModel 초기화
    /// - Parameters:
    ///   - preferences: 사용자 환경설정 (기본값: UserPreferences 기본 인스턴스)
    ///   - premiumService: 프리미엄 서비스
    init(
        preferences: UserPreferences = UserPreferences(),
        premiumService: PremiumService
    ) {
        self.preferences = preferences
        self.premiumService = premiumService
    }

    // MARK: - 카테고리 관리

    /// 카테고리 선택/해제 토글
    /// - Parameter category: 토글할 카테고리
    func toggleCategory(_ category: NewsCategory) {
        if let index = preferences.selectedCategories.firstIndex(of: category) {
            preferences.selectedCategories.remove(at: index)
        } else {
            preferences.selectedCategories.append(category)
        }
        savePreferences()
    }

    // MARK: - 폰트 크기 관리

    /// 폰트 크기 업데이트
    /// - Parameter size: 설정할 폰트 크기
    func updateFontSize(_ size: FontSize) {
        preferences.fontSize = size
        savePreferences()
    }

    // MARK: - 설정 저장

    /// 환경설정을 영구 저장소에 저장
    func savePreferences() {
        do {
            let data = try JSONEncoder().encode(preferences)
            UserDefaults.standard.set(data, forKey: "userPreferences")
        } catch {
            Logger(subsystem: "com.entangle.newscommunity", category: "Settings").error("환경설정 저장 실패: \(error.localizedDescription)")
        }
    }
}
