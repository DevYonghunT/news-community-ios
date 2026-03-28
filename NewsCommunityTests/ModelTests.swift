// ModelTests.swift
// NewsCategory, PremiumStatus, UserPreferences, Date+Extensions 테스트

import XCTest
@testable import NewsCommunity

final class ModelTests: XCTestCase {

    // MARK: - νₑ 정상 경로 — NewsCategory

    func test_newsCategory_allCases_hasEight() {
        XCTAssertEqual(NewsCategory.allCases.count, 8)
    }

    func test_newsCategory_displayNames_korean() {
        XCTAssertEqual(NewsCategory.technology.displayName, "기술")
        XCTAssertEqual(NewsCategory.business.displayName, "경제")
        XCTAssertEqual(NewsCategory.sports.displayName, "스포츠")
        XCTAssertEqual(NewsCategory.world.displayName, "세계")
    }

    func test_newsCategory_iconNames_notEmpty() {
        for category in NewsCategory.allCases {
            XCTAssertFalse(category.iconName.isEmpty, "\(category) 아이콘 비어있음")
        }
    }

    func test_newsCategory_identifiable_idEqualsRawValue() {
        for category in NewsCategory.allCases {
            XCTAssertEqual(category.id, category.rawValue)
        }
    }

    func test_newsCategory_rawValues_english() {
        XCTAssertEqual(NewsCategory.technology.rawValue, "technology")
        XCTAssertEqual(NewsCategory.entertainment.rawValue, "entertainment")
    }

    // MARK: - νₑ 정상 경로 — PremiumStatus

    func test_premiumStatus_canBookmark_freeUnderLimit() {
        let status = PremiumStatus(isActive: false)
        XCTAssertTrue(status.canBookmark(currentCount: 0))
        XCTAssertTrue(status.canBookmark(currentCount: 9))
    }

    func test_premiumStatus_canBookmark_freeAtLimit() {
        let status = PremiumStatus(isActive: false)
        XCTAssertFalse(status.canBookmark(currentCount: 10))
    }

    func test_premiumStatus_canBookmark_premiumAlways() {
        let status = PremiumStatus(isActive: true)
        XCTAssertTrue(status.canBookmark(currentCount: 0))
        XCTAssertTrue(status.canBookmark(currentCount: 100))
    }

    func test_premiumStatus_canRemoveAds_premiumTrue() {
        XCTAssertTrue(PremiumStatus(isActive: true).canRemoveAds)
        XCTAssertFalse(PremiumStatus(isActive: false).canRemoveAds)
    }

    func test_premiumStatus_canAccessExclusive_premiumTrue() {
        XCTAssertTrue(PremiumStatus(isActive: true).canAccessExclusive)
        XCTAssertFalse(PremiumStatus(isActive: false).canAccessExclusive)
    }

    // MARK: - νₑ 정상 경로 — Date+Extensions

    func test_timeAgoString_justNow_returns방금() {
        let now = Date()
        XCTAssertEqual(now.timeAgoString, "방금")
    }

    func test_timeAgoString_minutesAgo() {
        let fiveMinAgo = Date().addingTimeInterval(-300) // 5분
        XCTAssertEqual(fiveMinAgo.timeAgoString, "5분 전")
    }

    func test_timeAgoString_hoursAgo() {
        let twoHoursAgo = Date().addingTimeInterval(-7200) // 2시간
        XCTAssertEqual(twoHoursAgo.timeAgoString, "2시간 전")
    }

    func test_timeAgoString_yesterday() {
        let yesterday = Date().addingTimeInterval(-86400) // 24시간
        XCTAssertEqual(yesterday.timeAgoString, "어제")
    }

    func test_timeAgoString_daysAgo() {
        let threeDaysAgo = Date().addingTimeInterval(-259200) // 3일
        XCTAssertEqual(threeDaysAgo.timeAgoString, "3일 전")
    }

    func test_timeAgoString_weeksAgo() {
        let twoWeeksAgo = Date().addingTimeInterval(-1209600) // 14일
        XCTAssertEqual(twoWeeksAgo.timeAgoString, "2주 전")
    }

    func test_timeAgoString_monthsAgo() {
        let twoMonthsAgo = Date().addingTimeInterval(-5184000) // 60일
        XCTAssertEqual(twoMonthsAgo.timeAgoString, "2개월 전")
    }

    func test_dateString_koreanFormat() {
        let formatted = Date().dateString
        XCTAssertTrue(formatted.contains("월"))
        XCTAssertTrue(formatted.contains("일"))
    }

    func test_fullDateString_notEmpty() {
        XCTAssertFalse(Date().fullDateString.isEmpty)
    }

    // MARK: - νₑ 정상 경로 — AppConstants

    func test_appConstants_freeBookmarkLimit_isTen() {
        XCTAssertEqual(AppConstants.freeBookmarkLimit, 10)
    }

    func test_appConstants_premiumPrice_notEmpty() {
        XCTAssertFalse(AppConstants.premiumMonthlyPrice.isEmpty)
    }

    // MARK: - νμ 예외 경로

    func test_premiumStatus_canBookmark_overLimit_returnsFalse() {
        let status = PremiumStatus(isActive: false)
        XCTAssertFalse(status.canBookmark(currentCount: 50))
    }

    func test_timeAgoString_futureDate_returns방금() {
        let future = Date().addingTimeInterval(3600) // 1시간 뒤
        XCTAssertEqual(future.timeAgoString, "방금")
    }

    // MARK: - ντ 경계 경로

    func test_premiumStatus_canBookmark_exactBoundary() {
        let status = PremiumStatus(isActive: false)
        let limit = AppConstants.freeBookmarkLimit

        XCTAssertTrue(status.canBookmark(currentCount: limit - 1))
        XCTAssertFalse(status.canBookmark(currentCount: limit))
        XCTAssertFalse(status.canBookmark(currentCount: limit + 1))
    }

    func test_timeAgoString_exactly59Seconds_returns방금() {
        let date = Date().addingTimeInterval(-59)
        XCTAssertEqual(date.timeAgoString, "방금")
    }

    func test_timeAgoString_exactly60Seconds_returns1분전() {
        let date = Date().addingTimeInterval(-60)
        XCTAssertEqual(date.timeAgoString, "1분 전")
    }

    func test_timeAgoString_exactly23Hours_returns23시간전() {
        let date = Date().addingTimeInterval(-82800) // 23시간
        XCTAssertEqual(date.timeAgoString, "23시간 전")
    }

    func test_newsCategory_codable_roundTrip() throws {
        for category in NewsCategory.allCases {
            let data = try JSONEncoder().encode(category)
            let decoded = try JSONDecoder().decode(NewsCategory.self, from: data)
            XCTAssertEqual(decoded, category)
        }
    }
}
