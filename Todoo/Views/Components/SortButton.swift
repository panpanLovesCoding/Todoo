import SwiftUI

struct SortButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    @ObservedObject var lang = LanguageManager.shared
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
                    .frame(width: 24)
                
                Text(title)
                    .font(.custom(lang.language == "zh" ? "HappyZcool-2016" : "LuckiestGuy-Regular", size: 18))
                    .offset(y: lang.language == "zh" ? 0 : 3)
                
                Spacer()
                
                // ✨ 核心修改：使用 opacity 而不是 if 判断
                // 这样对勾永远占位，宽度永远保持一致，界面就不会跳动了！
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(GameTheme.green)
                    .font(.title3)
                    .opacity(isSelected ? 1 : 0) // 选中显示，不选中透明
            }
            .foregroundColor(isSelected ? GameTheme.brown : GameTheme.brown.opacity(0.6))
            // 增加一点高度限制，防止不同语言字体行高导致的微小垂直抖动
            .frame(height: 50)
            .padding(.horizontal, 12)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? GameTheme.orange : GameTheme.brown.opacity(0.2), lineWidth: isSelected ? 3 : 2)
            )
            .shadow(color: isSelected ? GameTheme.orange.opacity(0.3) : .clear, radius: 4, x: 0, y: 2)
            .scaleEffect(isSelected ? 1.02 : 1.0)
        }
    }
}
