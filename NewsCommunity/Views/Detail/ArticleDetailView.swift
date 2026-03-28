import SwiftUI

// MARK: - 기사 상세 뷰
/// 기사 전문 보기, 좋아요/북마크/공유 기능, 댓글 섹션 포함
struct ArticleDetailView: View {
    @StateObject private var viewModel: ArticleDetailViewModel
    @Environment(\.dismiss) private var dismiss

    /// 기사 데이터로 초기화
    init(article: NewsArticle) {
        _viewModel = StateObject(wrappedValue: ArticleDetailViewModel(article: article))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // MARK: - 히어로 이미지
                heroImage

                VStack(alignment: .leading, spacing: 16) {
                    // MARK: - 메타 정보 (카테고리, 출처, 날짜)
                    metaInfo

                    // MARK: - 제목
                    Text(viewModel.article.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppColor.textPrimary)

                    // MARK: - 본문
                    Text(viewModel.article.content)
                        .font(.body)
                        .foregroundColor(AppColor.textPrimary.opacity(0.9))
                        .lineSpacing(6)

                    Divider()
                        .background(AppColor.textSecondary.opacity(0.3))

                    // MARK: - 액션 툴바
                    actionToolbar

                    Divider()
                        .background(AppColor.textSecondary.opacity(0.3))

                    // MARK: - 댓글 섹션
                    commentsSection
                }
                .padding(16)
            }
        }
        .background(AppColor.background)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadComments()
        }
    }

    // MARK: - 히어로 이미지
    private var heroImage: some View {
        Group {
            if let imageURL = viewModel.article.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(16 / 9, contentMode: .fill)
                            .frame(height: 240)
                            .clipped()
                    case .failure:
                        heroPlaceholder
                    case .empty:
                        ProgressView()
                            .tint(AppColor.primary)
                            .frame(height: 240)
                            .frame(maxWidth: .infinity)
                            .background(AppColor.secondaryBackground)
                    @unknown default:
                        heroPlaceholder
                    }
                }
            } else {
                heroPlaceholder
            }
        }
    }

    /// 히어로 이미지 대체 플레이스홀더
    private var heroPlaceholder: some View {
        ZStack {
            AppColor.secondaryBackground
            Image(systemName: viewModel.article.category.iconName)
                .font(.system(size: 48))
                .foregroundColor(AppColor.textSecondary.opacity(0.4))
        }
        .frame(height: 240)
    }

    // MARK: - 메타 정보 (카테고리 배지 + 출처 + 날짜)
    private var metaInfo: some View {
        HStack(spacing: 8) {
            CategoryBadgeView(category: viewModel.article.category)

            Text(viewModel.article.source)
                .font(.caption)
                .foregroundColor(AppColor.textSecondary)

            Text("·")
                .foregroundColor(AppColor.textSecondary)

            Text(viewModel.article.publishedAt.dateString)
                .font(.caption)
                .foregroundColor(AppColor.textSecondary)

            Spacer()

            if !viewModel.article.author.isEmpty {
                Text(viewModel.article.author)
                    .font(.caption)
                    .foregroundColor(AppColor.secondary)
            }
        }
    }

    // MARK: - 액션 툴바 (좋아요, 북마크, 공유)
    private var actionToolbar: some View {
        HStack(spacing: 24) {
            // 좋아요
            Button {
                viewModel.likeArticle()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "heart.fill")
                    Text("\(viewModel.article.likeCount)")
                }
                .foregroundColor(AppColor.primary)
            }

            // 북마크
            Button {
                viewModel.toggleBookmark()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: viewModel.article.isBookmarked ? "bookmark.fill" : "bookmark")
                    Text(viewModel.article.isBookmarked ? "저장됨" : "저장")
                }
                .foregroundColor(viewModel.article.isBookmarked ? AppColor.accent : AppColor.textSecondary)
            }

            // 공유
            ShareLink(item: viewModel.article.title) {
                HStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                    Text("공유")
                }
                .foregroundColor(AppColor.textSecondary)
            }

            Spacer()
        }
        .font(.subheadline)
    }

    // MARK: - 댓글 섹션
    private var commentsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 댓글 헤더
            Text("댓글 \(viewModel.comments.count)개")
                .font(.headline)
                .foregroundColor(AppColor.textPrimary)

            // 댓글 입력
            commentInput

            // 댓글 목록
            ForEach(viewModel.comments) { comment in
                CommentView(comment: comment, onReport: {
                    viewModel.reportComment(comment)
                })
            }

            if viewModel.comments.isEmpty {
                Text("첫 번째 댓글을 남겨보세요!")
                    .font(.subheadline)
                    .foregroundColor(AppColor.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            }
        }
    }

    // MARK: - 댓글 입력 필드
    private var commentInput: some View {
        HStack(spacing: 10) {
            TextField("댓글을 입력하세요...", text: $viewModel.newCommentText)
                .foregroundColor(AppColor.textPrimary)
                .padding(10)
                .background(AppColor.cardBackground)
                .cornerRadius(10)

            Button {
                viewModel.addComment()
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(viewModel.newCommentText.isEmpty ? AppColor.textSecondary : AppColor.primary)
            }
            .disabled(viewModel.newCommentText.isEmpty)
        }
    }
}
