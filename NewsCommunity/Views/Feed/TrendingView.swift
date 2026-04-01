import SwiftUI

// MARK: - 트렌딩 뷰
/// 실시간 인기 기사 순위 목록
struct TrendingView: View {
    @StateObject private var viewModel = FeedViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // MARK: - 헤더
                trendingHeader

                // MARK: - 트렌딩 기사 목록
                if viewModel.isLoading {
                    ProgressView()
                        .tint(AppColor.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                } else if viewModel.trendingArticles.isEmpty {
                    emptyState
                } else {
                    trendingList
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(AppColor.background)
        .navigationTitle("트렌딩")
        .task {
            await viewModel.loadTrending()
        }
        .refreshable {
            await viewModel.loadTrending()
        }
    }

    // MARK: - 트렌딩 헤더
    private var trendingHeader: some View {
        HStack(spacing: 8) {
            Text("\u{1F525}")
                .font(.title2)
            Text("실시간 트렌딩")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppColor.textPrimary)
        }
        .padding(.top, 8)
    }

    // MARK: - 트렌딩 기사 리스트
    private var trendingList: some View {
        LazyVStack(spacing: 12) {
            ForEach(Array(viewModel.trendingArticles.prefix(10).enumerated()), id: \.element.id) { index, article in
                NavigationLink(destination: ArticleDetailView(article: article)) {
                    trendingItem(rank: index + 1, article: article)
                }
                .buttonStyle(.plain)
            }
        }
    }

    /// 순위가 매겨진 개별 트렌딩 항목
    private func trendingItem(rank: Int, article: NewsArticle) -> some View {
        HStack(alignment: .top, spacing: 12) {
            // 순위 번호
            Text("\(rank)")
                .font(.system(size: 32, weight: .heavy, design: .rounded))
                .foregroundColor(rankColor(for: rank))
                .frame(width: 44, alignment: .center)

            // 기사 카드 (컴팩트)
            NewsArticleCardView(
                article: article,
                onBookmark: { viewModel.toggleBookmark(article) },
                onLike: { viewModel.likeArticle(article) },
                isCompact: true
            )
        }
    }

    /// 순위에 따른 색상 반환 (1~3위: 특별 색상)
    private func rankColor(for rank: Int) -> Color {
        switch rank {
        case 1:
            return AppColor.primary
        case 2:
            return AppColor.accent
        case 3:
            return AppColor.secondary
        default:
            return AppColor.textSecondary
        }
    }

    // MARK: - 빈 상태
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "flame")
                .font(.system(size: 48))
                .foregroundColor(AppColor.textSecondary)
            Text("트렌딩 기사가 없습니다")
                .font(.headline)
                .foregroundColor(AppColor.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}
