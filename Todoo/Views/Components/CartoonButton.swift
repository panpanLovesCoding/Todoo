import SwiftUI

// 全局唯一的 3D 卡通按钮样式
struct CartoonButtonStyle: ButtonStyle {
    let color: Color
    var cornerRadius: CGFloat = 12
    // ✨ 新增：控制是否自动播放默认音效的开关，默认为 true
    var enableSound: Bool = true
    
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
            // MARK: - 音效逻辑 (iOS 17+ 新语法)
            .onChange(of: configuration.isPressed) { oldValue, newValue in
                // ✨ 修改：只有当 enableSound 为 true 时才自动播放
                if newValue && enableSound {
                    SoundManager.shared.playSound() // 默认播放 click_sound_1
                }
            }
    }
}
