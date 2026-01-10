import SwiftUI

// 全局唯一的 3D 卡通按钮样式
struct CartoonButtonStyle: ButtonStyle {
    let color: Color
    var cornerRadius: CGFloat = 12
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // 扩大点击热区，防止点不到
            .contentShape(Rectangle())
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color)
                    // 按下时的变暗层 (0.3 透明度)
                    .overlay(
                        Color.black
                            .opacity(configuration.isPressed ? 0.3 : 0)
                            .cornerRadius(cornerRadius)
                    )
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
            // 0.4秒 慢速回弹动画
            .animation(.easeOut(duration: 0.4), value: configuration.isPressed)
    }
}
