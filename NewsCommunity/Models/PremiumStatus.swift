import Foundation

// MARK: - 프리미엄 상태 모델 — 모든 기능 무료 해제
struct PremiumStatus {
    /// 프리미엄 활성화 여부 (항상 true)
    var isActive: Bool = true

    /// 북마크 가능 여부 — 항상 허용
    func canBookmark(currentCount: Int) -> Bool {
        return true
    }

    /// 광고 제거 가능 여부 — 항상 허용
    var canRemoveAds: Bool {
        true
    }

    /// 독점 콘텐츠 접근 가능 여부 — 항상 허용
    var canAccessExclusive: Bool {
        true
    }
}
