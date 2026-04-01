import SwiftUI

// MARK: - 메인 탭 뷰
/// 앱의 최상위 탭 네비게이션 구조
struct MainTabView: View {
    /// 현재 선택된 탭
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // MARK: 피드 탭
            NavigationStack {
                NewsFeedView()
            }
            .tabItem {
                Image(systemName: "newspaper.fill")
                Text("피드")
            }
            .tag(0)

            // MARK: 트렌딩 탭
            NavigationStack {
                TrendingView()
            }
            .tabItem {
                Image(systemName: "flame.fill")
                Text("트렌딩")
            }
            .tag(1)

            // MARK: 북마크 탭
            NavigationStack {
                BookmarkListView()
            }
            .tabItem {
                Image(systemName: "bookmark.fill")
                Text("북마크")
            }
            .tag(2)

            // MARK: 설정 탭
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gearshape.fill")
                Text("설정")
            }
            .tag(3)
        }
        .tint(AppColor.primary)
    }
}
