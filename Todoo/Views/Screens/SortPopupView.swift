import SwiftUI

struct SortPopupView: View {
    @Binding var isPresented: Bool
    @Binding var currentSort: SortOption
    
    var body: some View {
        VStack(spacing: 20) {
            // 标题
            Text("SORT BY")
                .font(.custom("Luckiest Guy", size: 32))
                .foregroundColor(GameTheme.orange)
                // 黑色描边
                .shadow(color: .black, radius: 0, x: 1, y: 1)
                .padding(.top, 10)
            
            VStack(spacing: 12) {
                // 生成三个排序按钮
                ForEach(SortOption.allCases, id: \.self) { option in
                    SortButton(
                        title: option.rawValue,
                        icon: iconFor(option),
                        isSelected: currentSort == option
                    ) {
                        currentSort = option
                        // 关闭弹窗
                        withAnimation {
                            isPresented = false
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            
            // 关闭按钮
            Button(action: { withAnimation { isPresented = false } }) {
                Text("Cancel")
                    .font(.custom("Luckiest Guy", size: 18))
                    .foregroundColor(GameTheme.brown)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(GameTheme.stone.opacity(0.3)) // 使用之前的灰色
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(GameTheme.brown.opacity(0.3), lineWidth: 2))
            }
            .padding(.top, 10)
        }
        .padding(25)
        .frame(width: 280) // 弹窗宽度
        .background(GameTheme.cream)
        .cornerRadius(25)
        // 粗边框风格
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(GameTheme.brown, lineWidth: 5)
        )
        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 10)
    }
    
    // 辅助：获取图标
    func iconFor(_ option: SortOption) -> String {
        switch option {
        case .creationDate: return "calendar.badge.plus"
        case .deadline: return "hourglass"
        case .title: return "textformat.abc"
        }
    }
}

// 辅助组件：排序按钮
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
            // 选中时有橙色边框
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? GameTheme.orange : GameTheme.brown.opacity(0.2), lineWidth: isSelected ? 3 : 2)
            )
            .shadow(color: isSelected ? GameTheme.orange.opacity(0.3) : .clear, radius: 4, x: 0, y: 2)
            .scaleEffect(isSelected ? 1.02 : 1.0)
        }
    }
}
