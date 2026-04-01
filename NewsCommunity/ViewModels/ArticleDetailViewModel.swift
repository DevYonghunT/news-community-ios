import Foundation
import SwiftData

// MARK: - 기사 상세 뷰모델
/// 뉴스 기사 상세 화면의 상태 관리 및 비즈니스 로직 담당
@MainActor
final class ArticleDetailViewModel: ObservableObject {

    // MARK: - 게시 프로퍼티

    /// 현재 표시 중인 기사
    @Published var article: NewsArticle

    /// 기사에 달린 댓글 목록
    @Published var comments: [Comment] = []

    /// 새 댓글 입력 텍스트
    @Published var newCommentText: String = ""

    /// 신고 알림 표시 여부
    @Published var showReportAlert: Bool = false

    /// 에러 메시지 (사용자 노출용)
    @Published var errorMessage: String?

    // MARK: - 의존성

    /// SwiftData 모델 컨텍스트
    private var modelContext: ModelContext?

    /// 댓글 서비스
    private let commentService: CommentService

    // MARK: - 초기화

    /// ArticleDetailViewModel 초기화
    /// - Parameters:
    ///   - article: 표시할 기사
    ///   - commentService: 댓글 서비스 (기본값: CommentService)
    init(
        article: NewsArticle,
        commentService: CommentService = CommentService()
    ) {
        self.article = article
        self.commentService = commentService
    }

    // MARK: - 컨텍스트 설정

    /// SwiftData ModelContext 설정
    /// - Parameter context: 설정할 ModelContext
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }

    // MARK: - 댓글 신고/차단 (UGC 가이드라인 1.4.3)

    /// 댓글 신고 처리 — 해당 댓글을 목록에서 제거한다
    /// - Parameter comment: 신고할 댓글
    func reportComment(_ comment: Comment) {
        guard let context = modelContext else { return }

        context.delete(comment)

        do {
            try context.save()
        } catch {
            errorMessage = "댓글 신고 처리 실패: \(error.localizedDescription)"
        }

        // 댓글 목록 갱신
        comments.removeAll { $0.id == comment.id }
        article.commentCount = max(0, article.commentCount - 1)
        showReportAlert = false
    }

    // MARK: - 댓글 관리

    /// 기사에 달린 댓글 목록 로드
    func loadComments() {
        guard let context = modelContext else { return }
        let fetchedComments = commentService.fetchComments(for: article.id, context: context)
        comments = fetchedComments
    }

    /// 댓글 최대 길이 제한
    private static let maxCommentLength = 500

    /// HTML 태그 제거
    private func stripHTMLTags(_ text: String) -> String {
        text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }

    /// 새 댓글 추가
    /// 기본 사용자명 "사용자"로 댓글 작성
    func addComment() {
        var trimmedText = newCommentText.trimmingCharacters(in: .whitespacesAndNewlines)
        trimmedText = stripHTMLTags(trimmedText)
        guard !trimmedText.isEmpty else { return }

        // 길이 제한 (500자)
        if trimmedText.count > Self.maxCommentLength {
            trimmedText = String(trimmedText.prefix(Self.maxCommentLength))
        }

        guard let context = modelContext else { return }

        commentService.addComment(
            articleId: article.id,
            username: "사용자",
            content: trimmedText,
            context: context
        )

        article.commentCount += 1
        newCommentText = ""
        loadComments()
    }

    // MARK: - 기사 상호작용

    /// 북마크 토글 (모든 기능 해제 — 제한 없음)
    func toggleBookmark() {
        article.isBookmarked.toggle()
        saveContext()
    }

    /// 기사 좋아요
    func likeArticle() {
        article.likeCount += 1
        saveContext()
    }

    // MARK: - 비공개 헬퍼

    /// 모델 컨텍스트 저장
    private func saveContext() {
        guard let context = modelContext else { return }
        do {
            try context.save()
        } catch {
            errorMessage = "저장에 실패했습니다. 다시 시도해주세요."
        }
    }
}
