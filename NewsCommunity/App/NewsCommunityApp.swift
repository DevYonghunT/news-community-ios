import SwiftUI
import SwiftData

// MARK: - 앱 진입점
@main
struct NewsCommunityApp: App {
    /// 프리미엄 서비스 공유 인스턴스
    @StateObject private var premiumService = PremiumService()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(premiumService)
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: [NewsArticle.self, Comment.self])
    }
}
