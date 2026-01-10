import SwiftUI

struct ToggleView: View {
    let title: String
    @Binding var isOn: Bool
    let icon: String
    let color: Color
    
    @ObservedObject var lang = LanguageManager.shared
    
    // 字体与偏移配置
    var fontName: String { lang.language == "zh" ? "HappyZcool-2016" : "LuckiestGuy-Regular" }
    var yOffset: CGFloat { lang.language == "zh" ? 0 : 3 }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isOn.toggle()
            }
        }) {
            HStack {
                // 1. 给图标固定大小，防止 circle 和 图标 宽度不一样导致微小抖动
                Image(systemName: isOn ? icon : "circle")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(isOn ? color : GameTheme.brown.opacity(0.5))
                    .frame(width: 20, height: 20)
                
                Text(title)
                    .font(.custom(fontName, size: 16))
                    .offset(y: yOffset)
                    .foregroundColor(GameTheme.brown)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .padding(10)
            // 2. 强制占满可用空间，确保两个按钮宽度始终相等
            .frame(maxWidth: .infinity)
            .background(Color.white) // 保持你原来的白色背景
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isOn ? color : GameTheme.brown.opacity(0.2), lineWidth: 2)
            )
            // 3. 【核心修复】使用 scaleEffect 实现放大
            // 这种放大是“视觉欺骗”，不会改变按钮实际占用的空间大小，所以绝对不会挤到旁边的按钮
            .scaleEffect(isOn ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle()) // 去除系统默认点击效果
    }
}
