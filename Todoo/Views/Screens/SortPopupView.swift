import SwiftUI

struct SortPopupView: View {
    @Binding var isPresented: Bool
    @Binding var currentSort: SortOption
    
    @ObservedObject var lang = LanguageManager.shared
    
    @State private var tempSelectedOption: SortOption = .creationDate
    
    // 字体逻辑
    func getFontName() -> String {
        return lang.language == "zh" ? "HappyZcool-2016" : "LuckiestGuy-Regular"
    }
    
    // 偏移逻辑
    func getTextOffset(size: CGFloat) -> CGFloat {
        if lang.language == "zh" { return 0 }
        return size > 30 ? 5 : 4
    }
    
    // 阴影逻辑
    func boldShadowColor(_ color: Color) -> Color {
        return lang.language == "zh" ? color : .clear
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // 标题
            Text(lang.localized("SORT BY"))
                .font(.custom(getFontName(), size: 40))
                .foregroundColor(GameTheme.pumpkin)
                .offset(y: getTextOffset(size: 35))
                .shadow(color: .black, radius: 0, x: 2, y: 3)
                .padding(.top, 10)
            
            VStack(spacing: 12) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    // 这里现在会引用独立的 SortButton.swift 文件
                    SortButton(
                        title: lang.localized(option.rawValue),
                        icon: iconFor(option),
                        isSelected: tempSelectedOption == option
                    ) {
                        // ✨ 1. 播放机械点击音效
                        // 注意：因为你的文件后缀是大写的 .MP3，这里保险起见指定 type 为 "MP3"
                        SoundManager.shared.playSound(sound: "mechanical_click_sound_1", type: "MP3")
                        
                        // 2.原本的选中逻辑
                        withAnimation(.spring()) {
                            tempSelectedOption = option
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            
            // Buttons
            HStack(spacing: 15) {
                // Cancel 按钮 (红色卡通风格)
                Button(action: {
                    // ✨ 修改前：withAnimation { isPresented = false }
                    // ✨ 修改后：
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation { isPresented = false }
                    }
                }) {
                    HStack {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .bold))
                        Text(lang.localized("Cancel"))
                            .font(.custom(getFontName(), size: 20))
                            .offset(y: getTextOffset(size: 20))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .foregroundColor(.white)
                    .shadow(color: boldShadowColor(.white), radius: 0, x: 1, y: 1)
                }
                .buttonStyle(CartoonButtonStyle(color: Color(red: 0.85, green: 0.3, blue: 0.3), cornerRadius: 12))
                
                // Select 按钮 (绿色卡通风格)
                Button(action: {
                    currentSort = tempSelectedOption // 这一步还是立即执行（更新数据）
                    
                    // ✨ 关闭页面的动作加延迟
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            isPresented = false
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "checkmark")
                            .font(.system(size: 20, weight: .bold))
                        Text(lang.localized("Select"))
                            .font(.custom(getFontName(), size: 20))
                            .offset(y: getTextOffset(size: 20))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .foregroundColor(.white)
                    .shadow(color: boldShadowColor(.white), radius: 0, x: 1, y: 1)
                }
                .buttonStyle(CartoonButtonStyle(color: GameTheme.emerald, cornerRadius: 12))
            }
            .padding(.top, 10)
        }
        .padding(.horizontal, 25) // 左右保持 25
        .padding(.top, 25)        // 顶部保持 25
        .padding(.bottom, 30)
        .frame(width: 320)
        .background(GameTheme.cream)
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(GameTheme.brown, lineWidth: 5)
        )
        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 10)
        .environment(\.colorScheme, .light)
        .onAppear {
            tempSelectedOption = currentSort
        }
    }
    
    func iconFor(_ option: SortOption) -> String {
        switch option {
        case .creationDate: return "calendar.badge.plus"
        case .deadline: return "hourglass"
        case .title: return "textformat.abc"
        }
    }
}

