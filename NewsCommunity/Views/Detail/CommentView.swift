import SwiftUI

// MARK: - 댓글 뷰
/// 개별 댓글을 표시하는 뷰. 아바타, 유저명, 시간, 내용, 좋아요 버튼
struct CommentView: View {
    /// 표시할 댓글 데이터
    let comment: Comment

    /// 신고 콜백
    var onReport: () -> Void = {}

    /// 좋아요 상태
    @State private var isLiked: Bool = false

    /// 로컬 좋아요 카운트
    @State private var localLikeCount: Int = 0

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // MARK: - 아바타
            avatar

            // MARK: - 댓글 내용
            VStack(alignment: .leading, spacing: 6) {
                // 유저명 + 시간
                HStack {
                    Text(comment.username)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColor.textPrimary)

                    Text(comment.createdAt.timeAgoString)
                        .font(.caption)
                        .foregroundColor(AppColor.textSecondary)

                    Spacer()
                }

                // 댓글 텍스트
                Text(comment.content)
                    .font(.subheadline)
                    .foregroundColor(AppColor.textPrimary.opacity(0.9))

                // 좋아요 버튼
                Button {
                    toggleLike()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .font(.caption2)
                        Text("\(localLikeCount)")
                            .font(.caption2)
                    }
                    .foregroundColor(isLiked ? AppColor.primary : AppColor.textSecondary)
                }
            }
        }
        .padding(12)
        .background(AppColor.cardBackground.opacity(0.6))
        .cornerRadius(12)
        .contextMenu {
            // 신고 버튼
            Button(role: .destructive) {
                onReport()
            } label: {
                Label("신고", systemImage: "exclamationmark.triangle")
            }
        }
        .onAppear {
            localLikeCount = comment.likeCount
        }
    }

    // MARK: - 아바타 (유저명 첫 글자)
    private var avatar: some View {
        ZStack {
            Circle()
                .fill(AppColor.secondaryBackground)
                .frame(width: 36, height: 36)

            Text(String(comment.username.prefix(1)).uppercased())
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(AppColor.primary)
        }
    }

    /// 좋아요 토글
    private func toggleLike() {
        isLiked.toggle()
        localLikeCount += isLiked ? 1 : -1
    }
}
