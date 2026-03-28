import Foundation

// MARK: - Date 포맷 확장
extension Date {
    /// 상대적 시간 문자열 반환 (예: "3분 전", "2시간 전", "어제")
    var timeAgoString: String {
        let now = Date()
        let interval = now.timeIntervalSince(self)

        // 미래 날짜 처리
        guard interval >= 0 else { return "방금" }

        let seconds = Int(interval)
        let minutes = seconds / 60
        let hours = minutes / 60
        let days = hours / 24
        let weeks = days / 7
        let months = days / 30

        if seconds < 60 {
            return "방금"
        } else if minutes < 60 {
            return "\(minutes)분 전"
        } else if hours < 24 {
            return "\(hours)시간 전"
        } else if days == 1 {
            return "어제"
        } else if days < 7 {
            return "\(days)일 전"
        } else if weeks < 5 {
            return "\(weeks)주 전"
        } else {
            return "\(months)개월 전"
        }
    }

    /// 간단한 날짜 문자열 (예: "3월 25일")
    var dateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        return formatter.string(from: self)
    }

    /// 전체 날짜 문자열 (예: "2026년 3월 25일 오후 3:42")
    var fullDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
