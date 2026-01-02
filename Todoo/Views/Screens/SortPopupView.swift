import SwiftUI

struct SortPopupView: View {
    @Binding var isPresented: Bool
    @Binding var currentSort: SortOption
    
    // 临时状态：用于记录用户在弹窗里选了什么，但还未确认
    @State private var tempSelectedOption: SortOption = .creationDate
    
    var body: some View {
        VStack(spacing: 20) {
            // 标题
            Text("SORT BY")
                .font(.custom("Luckiest Guy", size: 35))
                .foregroundColor(GameTheme.pumpkin)
                .shadow(color: .black, radius: 0, x: 1, y: 1)
                .padding(.top, 10)
            
            VStack(spacing: 12) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    SortButton(
                        title: option.rawValue,
                        icon: iconFor(option),
                        isSelected: tempSelectedOption == option
                    ) {
                        // 点击动作：只更新临时状态
                        withAnimation(.spring()) {
                            tempSelectedOption = option
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            
            // Buttons - 修改为与 New Quest 界面一致的布局 (HStack)
            HStack(spacing: 20) {
                // Cancel 按钮 (左侧，红色)
                Button(action: { withAnimation { isPresented = false } }) {
                    Text("Cancel")
                        .font(.custom("Luckiest Guy", size: 20)) // [修改] 字体大小改为 20
                        .foregroundColor(.white)
                        .padding(.vertical, 12) // [修改] 垂直内边距改为 12
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(GameTheme.brown, lineWidth: 3))
                }
                
                // Select 按钮 (右侧，绿色)
                Button(action: {
                    currentSort = tempSelectedOption
                    withAnimation {
                        isPresented = false
                    }
                }) {
                    Text("Select")
                        .font(.custom("Luckiest Guy", size: 20)) // [修改] 字体大小改为 20
                        .foregroundColor(.white)
                        .padding(.vertical, 12) // [修改] 垂直内边距改为 12
                        .frame(maxWidth: .infinity)
                        .background(Color.green) // [修改] 使用与 New Quest 一致的绿色 (Color.green)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(GameTheme.brown, lineWidth: 3))
                }
            }
            .padding(.top, 10)
        }
        .padding(25)
        .frame(width: 320) // [可选调整] 稍微加宽一点以适应横排按钮，或者保持 280 也可以
        .background(GameTheme.cream)
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(GameTheme.brown, lineWidth: 5)
        )
        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 10)
        // 初始化
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

// 辅助组件：SortButton
struct SortButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
                    .frame(width: 24)
                
                Text(title)
                    .font(.custom("Luckiest Guy", size: 18))
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(GameTheme.green)
                        .font(.title3)
                }
            }
            .foregroundColor(isSelected ? GameTheme.brown : GameTheme.brown.opacity(0.6))
            .padding(12)
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
