import Foundation
import SwiftData
import os

// MARK: - 북마크 뷰모델
/// 북마크된 기사 목록 관리 담당
@MainActor
final class BookmarkViewModel: ObservableObject {

    // MARK: - 게시 프로퍼티

    /// 북마크된 기사 목록
    @Published var bookmarkedArticles: [NewsArticle] = []

    /// 에러 메시지 (사용자 노출용)
    @Published var errorMessage: String?

    // MARK: - 의존성

    /// SwiftData 모델 컨텍스트
    private var modelContext: ModelContext?

    // MARK: - 컨텍스트 설정

    /// SwiftData ModelContext 설정
    /// - Parameter context: 설정할 ModelContext
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }

    // MARK: - 북마크 관리

    /// 북마크된 기사 목록 조회 및 게시 프로퍼티 업데이트
    func loadBookmarks() {
        guard let context = modelContext else {
            Logger(subsystem: "com.entangle.newscommunity", category: "Bookmark").warning("ModelContext가 설정되지 않음")
            bookmarkedArticles = []
            return
        }

        let descriptor = FetchDescriptor<NewsArticle>(
            predicate: #Predicate { $0.isBookmarked == true },
            sortBy: [SortDescriptor(\.publishedAt, order: .reverse)]
        )

        do {
            bookmarkedArticles = try context.fetch(descriptor)
        } catch {
            Logger(subsystem: "com.entangle.newscommunity", category: "Bookmark").error("북마크 로드 실패: \(error.localizedDescription)")
            bookmarkedArticles = []
        }
    }

    /// 기사의 북마크 해제
    /// - Parameter article: 북마크를 해제할 기사
    func removeBookmark(_ article: NewsArticle) {
        article.isBookmarked = false
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
