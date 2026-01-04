import SwiftUI

// 全局唯一的 3D 卡通按钮样式
struct CartoonButtonStyle: ButtonStyle {
    let color: Color
    var cornerRadius: CGFloat = 12
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(GameTheme.brown.opacity(0.5), lineWidth: 3)
                    )
            )
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(GameTheme.brown.opacity(0.4))
                    .offset(y: configuration.isPressed ? 0 : 4)
            )
            .offset(y: configuration.isPressed ? 4 : 0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
