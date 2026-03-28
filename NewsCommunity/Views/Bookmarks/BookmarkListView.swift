import SwiftUI
import SwiftData

// MARK: - 북마크 목록 뷰
/// 사용자가 저장한 북마크 기사 목록
struct BookmarkListView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = BookmarkViewModel()

    var body: some View {
        Group {
            if viewModel.bookmarkedArticles.isEmpty {
                emptyState
            } else {
                bookmarkList
            }
        }
        .background(AppColor.background)
        .navigationTitle("북마크")
        .onAppear {
            viewModel.setModelContext(modelContext)
        }
        .task {
            viewModel.loadBookmarks()
        }
    }

    // MARK: - 북마크 기사 목록
    private var bookmarkList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.bookmarkedArticles) { article in
                    NavigationLink(destination: ArticleDetailView(article: article)) {
                        NewsArticleCardView(
                            article: article,
                            onBookmark: { viewModel.removeBookmark(article) }
                        )
                    }
                    .buttonStyle(.plain)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            viewModel.removeBookmark(article)
                        } label: {
                            Label("삭제", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }

    // MARK: - 빈 상태 뷰
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "bookmark.slash")
                .font(.system(size: 56))
                .foregroundColor(AppColor.textSecondary.opacity(0.5))

            Text("북마크한 기사가 없습니다")
                .font(.headline)
                .foregroundColor(AppColor.textSecondary)

            Text("관심 있는 기사를 북마크해보세요")
                .font(.subheadline)
                .foregroundColor(AppColor.textSecondary.opacity(0.7))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
