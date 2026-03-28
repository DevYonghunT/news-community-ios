import Foundation
import os
import SwiftData

// MARK: - 댓글 서비스
final class CommentService {
    /// 싱글톤 인스턴스
    static let shared = CommentService()

    init() {}

    // MARK: - 댓글 추가

    /// 새 댓글 작성
    /// - Parameters:
    ///   - articleId: 대상 기사 ID
    ///   - username: 작성자 이름
    ///   - content: 댓글 내용
    ///   - context: SwiftData 모델 컨텍스트
    func addComment(
        articleId: UUID,
        username: String,
        content: String,
        context: ModelContext
    ) {
        let comment = Comment(
            articleId: articleId,
            username: username,
            content: content,
            createdAt: Date(),
            likeCount: 0
        )
        context.insert(comment)

        do {
            try context.save()
        } catch {
            Logger(subsystem: "com.entangle.newscommunity", category: "Comment").error("댓글 저장 실패: \(error.localizedDescription)")
        }
    }

    // MARK: - 댓글 조회

    /// 특정 기사의 댓글 목록 조회
    /// - Parameters:
    ///   - articleId: 대상 기사 ID
    ///   - context: SwiftData 모델 컨텍스트
    /// - Returns: 최신순 정렬된 댓글 배열
    func fetchComments(for articleId: UUID, context: ModelContext) -> [Comment] {
        let descriptor = FetchDescriptor<Comment>(
            predicate: #Predicate { comment in
                comment.articleId == articleId
            },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        do {
            let comments = try context.fetch(descriptor)
            return comments
        } catch {
            Logger(subsystem: "com.entangle.newscommunity", category: "Comment").error("댓글 조회 실패: \(error.localizedDescription)")
            return []
        }
    }

    // MARK: - Mock 댓글 생성

    /// 사전 구축된 Mock 댓글 데이터를 삽입
    /// - Parameters:
    ///   - articleId: 대상 기사 ID
    ///   - context: SwiftData 모델 컨텍스트
    func populateMockComments(for articleId: UUID, context: ModelContext) {
        let now = Date()

        let mockComments: [(String, String, TimeInterval, Int)] = [
            ("뉴스마니아", "정말 흥미로운 기사네요. 앞으로의 전개가 기대됩니다!", -300, 12),
            ("테크덕후", "이런 기술이 실용화되면 세상이 많이 바뀔 것 같아요.", -900, 8),
            ("시사평론가", "좀 더 깊이 있는 분석이 필요한 주제라고 생각합니다.", -1800, 23),
            ("일반시민", "쉽게 풀어서 설명해주시니 이해가 잘 되네요 👍", -3600, 5),
            ("전문가Kim", "업계 종사자로서 한마디 하자면, 현실적으로 아직 갈 길이 멀어요.", -7200, 34),
            ("댓글왕", "매번 좋은 기사 감사합니다. 구독하고 갑니다!", -10800, 2),
            ("분석가Lee", "데이터를 보면 이 추세는 당분간 계속될 것 같습니다.", -14400, 15),
            ("학생Park", "과제에 참고하기 좋은 내용이에요. 출처 남기고 갑니다.", -21600, 7),
            ("직장인Choi", "점심시간에 읽기 딱 좋은 분량이네요.", -28800, 3),
            ("은퇴자Jung", "젊은 세대들은 정말 대단해요. 응원합니다.", -43200, 19),
        ]

        for (username, content, timeOffset, likeCount) in mockComments {
            let comment = Comment(
                articleId: articleId,
                username: username,
                content: content,
                createdAt: now.addingTimeInterval(timeOffset),
                likeCount: likeCount
            )
            context.insert(comment)
        }

        do {
            try context.save()
        } catch {
            Logger(subsystem: "com.entangle.newscommunity", category: "Comment").error("Mock 댓글 저장 실패: \(error.localizedDescription)")
        }
    }
}
