import SwiftUI

// MARK: - Color Hex 초기화 확장
extension Color {
    /// 16진수 문자열로 Color 생성
    /// - Parameter hex: "#RRGGBB" 또는 "RRGGBB" 형식 문자열
    init(hex: String) {
        let sanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let hexString = sanitized.hasPrefix("#") ? String(sanitized.dropFirst()) : sanitized

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
