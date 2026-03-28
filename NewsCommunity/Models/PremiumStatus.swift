import Foundation

// MARK: - 프리미엄 상태 모델
struct PremiumStatus {
    /// 프리미엄 활성화 여부
    var isActive: Bool

    /// 북마크 가능 여부 판단
    /// - Parameter currentCount: 현재 북마크 수
    /// - Returns: 북마크 추가 가능 여부
    func canBookmark(currentCount: Int) -> Bool {
        if isActive { return true }
        return currentCount < AppConstants.freeBookmarkLimit
    }

    /// 광고 제거 가능 여부
    var canRemoveAds: Bool {
        isActive
    }

    /// 독점 콘텐츠 접근 가능 여부
    var canAccessExclusive: Bool {
        isActive
    }
}
