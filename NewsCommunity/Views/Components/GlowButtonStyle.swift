import SwiftUI

// MARK: - 네온 글로우 버튼 스타일
/// 기본 색상 배경에 네온 발광 효과를 적용하는 버튼 스타일
struct GlowButtonStyle: ButtonStyle {
    /// 버튼 색상 (기본: primary 레드)
    var color: Color = AppColor.primary

    /// 둥근 모서리 반경
    var cornerRadius: CGFloat = 14

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .fontWeight(.semibold)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color)
                    .shadow(
                        color: color.opacity(configuration.isPressed ? 0.3 : 0.6),
                        radius: configuration.isPressed ? 4 : 12,
                        x: 0,
                        y: configuration.isPressed ? 2 : 4
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color.opacity(0.4), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
