import SwiftUI

// MARK: - 뉴스 기사 카드 뷰
/// 피드에서 각 기사를 카드 형태로 표시하는 뷰
struct NewsArticleCardView: View {
    /// 표시할 기사 데이터
    let article: NewsArticle

    /// 북마크 토글 액션
    var onBookmark: (() -> Void)?

    /// 좋아요 액션
    var onLike: (() -> Void)?

    /// 컴팩트 모드 (트렌딩 목록용)
    var isCompact: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // MARK: - 이미지 영역
            if !isCompact {
                articleImage
            }

            // MARK: - 텍스트 콘텐츠
            VStack(alignment: .leading, spacing: 8) {
                // 카테고리 배지
                CategoryBadgeView(category: article.category)

                // 제목
                Text(article.title)
                    .font(isCompact ? .subheadline : .headline)
                    .fontWeight(.bold)
                    .foregroundColor(AppColor.textPrimary)
                    .lineLimit(isCompact ? 2 : 3)

                // 요약
                if !isCompact {
                    Text(article.summary)
                        .font(.subheadline)
                        .foregroundColor(AppColor.textSecondary)
                        .lineLimit(2)
                }

                // 출처 + 시간
                HStack {
                    Text(article.source)
                        .font(.caption)
                        .foregroundColor(AppColor.primary)
                    Text("·")
                        .foregroundColor(AppColor.textSecondary)
                    Text(article.timeAgo)
                        .font(.caption)
                        .foregroundColor(AppColor.textSecondary)
                    Spacer()
                }

                // MARK: - 하단 액션 바
                actionBar
            }
            .padding(isCompact ? 10 : 14)
        }
        .background(AppColor.cardBackground)
        .cornerRadius(16)
    }

    // MARK: - 기사 이미지
    private var articleImage: some View {
        Group {
            if let imageURL = article.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(16 / 9, contentMode: .fill)
                            .clipped()
                    case .failure:
                        imagePlaceholder
                    case .empty:
                        ProgressView()
                            .tint(AppColor.primary)
                            .frame(height: 180)
                            .frame(maxWidth: .infinity)
                            .background(AppColor.secondaryBackground)
                    @unknown default:
                        imagePlaceholder
                    }
                }
                .frame(height: 180)
                .clipped()
            } else {
                imagePlaceholder
            }
        }
    }

    /// 이미지 대체 플레이스홀더
    private var imagePlaceholder: some View {
        ZStack {
            AppColor.secondaryBackground
            Image(systemName: article.category.iconName)
                .font(.system(size: 36))
                .foregroundColor(AppColor.textSecondary.opacity(0.5))
        }
        .frame(height: 180)
    }

    // MARK: - 액션 바 (좋아요, 댓글, 북마크)
    private var actionBar: some View {
        HStack(spacing: 16) {
            // 좋아요 버튼
            Button {
                onLike?()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .font(.caption)
                    Text("\(article.likeCount)")
                        .font(.caption)
                }
                .foregroundColor(AppColor.primary.opacity(0.8))
            }

            // 댓글 수
            HStack(spacing: 4) {
                Image(systemName: "bubble.right.fill")
                    .font(.caption)
                Text("\(article.commentCount)")
                    .font(.caption)
            }
            .foregroundColor(AppColor.textSecondary)

            Spacer()

            // 북마크 버튼
            Button {
                onBookmark?()
            } label: {
                Image(systemName: article.isBookmarked ? "bookmark.fill" : "bookmark")
                    .font(.subheadline)
                    .foregroundColor(article.isBookmarked ? AppColor.accent : AppColor.textSecondary)
            }
        }
    }
}
