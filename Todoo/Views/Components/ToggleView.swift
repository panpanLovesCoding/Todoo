import SwiftUI

struct ToggleView: View {
    let title: String
    @Binding var isOn: Bool
    let icon: String
    let color: Color
    
    @ObservedObject var lang = LanguageManager.shared
    
    // 字体与偏移
    var fontName: String { lang.language == "zh" ? "HappyZcool-2016" : "LuckiestGuy-Regular" }
    var yOffset: CGFloat { lang.language == "zh" ? 0 : 3 }
    
    var body: some View {
        Button(action: { isOn.toggle() }) {
            HStack {
                Image(systemName: isOn ? icon : "circle")
                    .foregroundColor(isOn ? color : GameTheme.brown.opacity(0.5))
                Text(title)
                    .font(.custom(fontName, size: 16)) // 动态字体
                    .offset(y: yOffset) // 动态偏移
                    .foregroundColor(GameTheme.brown)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isOn ? color : GameTheme.brown.opacity(0.2), lineWidth: 2)
            )
        }
    }
}
