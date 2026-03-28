import Foundation
import SwiftData

// MARK: - 뉴스 기사 모델
@Model
final class NewsArticle {
    /// 고유 식별자
    @Attribute(.unique) var id: UUID
    /// 기사 제목
    var title: String
    /// AI 요약
    var summary: String
    /// 기사 본문
    var content: String
    /// 출처 매체명
    var source: String
    /// 작성자
    var author: String
    /// 이미지 URL (선택)
    var imageURL: String?
    /// 카테고리 원시값 (SwiftData 저장용)
    var categoryRawValue: String
    /// 발행일
    var publishedAt: Date
    /// 북마크 여부
    var isBookmarked: Bool
    /// 좋아요 수
    var likeCount: Int
    /// 댓글 수
    var commentCount: Int

    /// 카테고리 (계산 프로퍼티)
    var category: NewsCategory {
        get { NewsCategory(rawValue: categoryRawValue) ?? .world }
        set { categoryRawValue = newValue.rawValue }
    }

    /// 상대적 시간 문자열
    var timeAgo: String {
        publishedAt.timeAgoString
    }

    init(
        id: UUID = UUID(),
        title: String,
        summary: String,
        content: String,
        source: String,
        author: String,
        imageURL: String? = nil,
        category: NewsCategory,
        publishedAt: Date = Date(),
        isBookmarked: Bool = false,
        likeCount: Int = 0,
        commentCount: Int = 0
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.content = content
        self.source = source
        self.author = author
        self.imageURL = imageURL
        self.categoryRawValue = category.rawValue
        self.publishedAt = publishedAt
        self.isBookmarked = isBookmarked
        self.likeCount = likeCount
        self.commentCount = commentCount
    }
}
