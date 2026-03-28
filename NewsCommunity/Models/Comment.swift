import Foundation
import SwiftData

// MARK: - 댓글 모델
@Model
final class Comment {
    /// 고유 식별자
    @Attribute(.unique) var id: UUID
    /// 연결된 기사 ID
    var articleId: UUID
    /// 작성자 이름
    var username: String
    /// 댓글 내용
    var content: String
    /// 작성 시각
    var createdAt: Date
    /// 좋아요 수
    var likeCount: Int

    /// 연결된 뉴스 기사 (역참조)
    @Relationship var article: NewsArticle?

    init(
        id: UUID = UUID(),
        articleId: UUID,
        username: String,
        content: String,
        createdAt: Date = Date(),
        likeCount: Int = 0,
        article: NewsArticle? = nil
    ) {
        self.id = id
        self.articleId = articleId
        self.username = username
        self.content = content
        self.createdAt = createdAt
        self.likeCount = likeCount
        self.article = article
    }
}
