import SwiftUI
import SwiftData

// MARK: - 앱 진입점
@main
struct NewsCommunityApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: [NewsArticle.self, Comment.self])
    }
}
