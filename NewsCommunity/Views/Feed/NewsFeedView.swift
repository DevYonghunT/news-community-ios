import SwiftUI

// MARK: - 뉴스 피드 뷰
/// 메인 뉴스 피드 화면. 카테고리 필터링, 검색, 기사 목록 표시
struct NewsFeedView: View {
    @EnvironmentObject var premiumService: PremiumService
    @StateObject private var viewModel: FeedViewModel

    init() {
        _viewModel = StateObject(wrappedValue: FeedViewModel(premiumService: PremiumService()))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // MARK: - 검색 바
                searchBar

                // MARK: - 카테고리 칩 스크롤
                categoryChips

                // MARK: - 기사 목록
                articleList
            }
        }
        .background(AppColor.background)
        .navigationTitle("뉴스")
        .refreshable {
            await viewModel.loadArticles()
        }
        .task {
            viewModel.premiumService = premiumService
            await viewModel.loadArticles()
        }
    }

    // MARK: - 검색 바
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColor.textSecondary)

            TextField("기사 검색...", text: $viewModel.searchText)
                .foregroundColor(AppColor.textPrimary)
                .autocorrectionDisabled()

            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColor.textSecondary)
                }
            }
        }
        .padding(12)
        .background(AppColor.cardBackground)
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    // MARK: - 카테고리 칩 가로 스크롤
    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                // 전체 카테고리 칩
                categoryChip(title: "전체", icon: "square.grid.2x2", isSelected: viewModel.selectedCategory == nil) {
                    viewModel.selectedCategory = nil
                }

                // 각 카테고리 칩
                ForEach(NewsCategory.allCases) { category in
                    categoryChip(
                        title: category.displayName,
                        icon: category.iconName,
                        color: AppColor.categoryColor(for: category),
                        isSelected: viewModel.selectedCategory == category
                    ) {
                        viewModel.selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }

    /// 개별 카테고리 칩 뷰
    private func categoryChip(
        title: String,
        icon: String,
        color: Color = AppColor.primary,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? color : AppColor.cardBackground)
            .foregroundColor(isSelected ? .white : AppColor.textSecondary)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? color : Color.clear, lineWidth: 1)
            )
        }
    }

    // MARK: - 기사 목록
    private var articleList: some View {
        LazyVStack(spacing: 16) {
            if viewModel.isLoading {
                ProgressView()
                    .tint(AppColor.primary)
                    .padding(.top, 40)
            } else if viewModel.filteredArticles.isEmpty {
                emptyState
            } else {
                ForEach(viewModel.filteredArticles) { article in
                    NavigationLink(destination: ArticleDetailView(article: article)) {
                        NewsArticleCardView(
                            article: article,
                            onBookmark: { viewModel.toggleBookmark(article) },
                            onLike: { viewModel.likeArticle(article) }
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }

    // MARK: - 빈 상태 뷰
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "newspaper")
                .font(.system(size: 48))
                .foregroundColor(AppColor.textSecondary)
            Text("기사가 없습니다")
                .font(.headline)
                .foregroundColor(AppColor.textSecondary)
        }
        .padding(.top, 60)
    }
}
