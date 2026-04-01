import Foundation
import SwiftData
import Combine
import os

// MARK: - 피드 뷰모델
/// 뉴스 피드 화면의 상태 관리 및 비즈니스 로직 담당
@MainActor
final class FeedViewModel: ObservableObject {

    // MARK: - 게시 프로퍼티

    /// 전체 뉴스 기사 목록
    @Published var articles: [NewsArticle] = []

    /// 트렌딩 뉴스 기사 목록
    @Published var trendingArticles: [NewsArticle] = []

    /// 선택된 카테고리 (nil이면 전체 표시)
    @Published var selectedCategory: NewsCategory? = nil

    /// 로딩 상태
    @Published var isLoading: Bool = false

    /// 검색 텍스트
    @Published var searchText: String = ""

    /// 에러 메시지 (사용자 노출용)
    @Published var errorMessage: String?

    // MARK: - 의존성

    /// 뉴스 데이터 서비스
    private let newsService: NewsServiceProtocol

    /// SwiftData 모델 컨텍스트
    private var modelContext: ModelContext?

    // MARK: - 초기화

    /// FeedViewModel 초기화
    /// - Parameter newsService: 뉴스 서비스 (기본값: MockNewsService)
    init(newsService: NewsServiceProtocol = MockNewsService()) {
        self.newsService = newsService
    }

    // MARK: - 컨텍스트 설정

    /// SwiftData ModelContext 설정
    /// - Parameter context: 설정할 ModelContext
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }

    // MARK: - 데이터 로드

    /// 뉴스 기사 목록을 서비스에서 가져와 컨텍스트에 저장
    func loadArticles() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let fetchedArticles = try await newsService.fetchArticles(category: selectedCategory)

            // 모델 컨텍스트에 기사 삽입
            if let context = modelContext {
                for article in fetchedArticles {
                    context.insert(article)
                }
                try context.save()
            }

            articles = fetchedArticles
        } catch {
            // 에러 발생 시 빈 목록 유지, 로그 출력
            Logger(subsystem: "com.entangle.newscommunity", category: "Feed").error("기사 로드 실패: \(error.localizedDescription)")
        }
    }

    /// 트렌딩 뉴스 기사 목록 로드
    func loadTrending() async {
        do {
            let trending = try await newsService.fetchTrending()
            trendingArticles = trending
        } catch {
            Logger(subsystem: "com.entangle.newscommunity", category: "Feed").error("트렌딩 로드 실패: \(error.localizedDescription)")
        }
    }

    // MARK: - 기사 상호작용

    /// 북마크 토글 (모든 기능 해제 — 제한 없음)
    /// - Parameter article: 토글할 기사
    func toggleBookmark(_ article: NewsArticle) {
        article.isBookmarked.toggle()
        saveContext()
    }

    /// 기사 좋아요
    /// - Parameter article: 좋아요할 기사
    func likeArticle(_ article: NewsArticle) {
        article.likeCount += 1
        saveContext()
    }

    // MARK: - 필터링

    /// 선택된 카테고리와 검색어로 필터링된 기사 목록
    var filteredArticles: [NewsArticle] {
        var result = articles

        // 카테고리 필터링
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }

        // 검색어 필터링
        if !searchText.isEmpty {
            let query = searchText.lowercased()
            result = result.filter { article in
                article.title.lowercased().contains(query) ||
                article.summary.lowercased().contains(query)
            }
        }

        return result
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
