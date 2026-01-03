import SwiftUI

struct SortPopupView: View {
    @Binding var isPresented: Bool
    @Binding var currentSort: SortOption
    
    @State private var tempSelectedOption: SortOption = .creationDate
    
    var body: some View {
        VStack(spacing: 20) {
            // 标题
            Text("SORT BY")
                .font(.custom("Luckiest Guy", size: 35))
                .foregroundColor(GameTheme.pumpkin)
                // 🆕 修正位置：大标题下移 5
                .offset(y: 5)
                .shadow(color: .black, radius: 0, x: 1, y: 1)
                .padding(.top, 10)
            
            VStack(spacing: 12) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    SortButton(
                        title: option.rawValue,
                        icon: iconFor(option),
                        isSelected: tempSelectedOption == option
                    ) {
                        withAnimation(.spring()) {
                            tempSelectedOption = option
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            
            // Buttons
            HStack(spacing: 20) {
                // Cancel 按钮
                Button(action: { withAnimation { isPresented = false } }) {
                    Text("Cancel")
                        .font(.custom("Luckiest Guy", size: 20))
                        // 🆕 修正位置：中号按钮下移 4
                        .offset(y: 4)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(GameTheme.brown, lineWidth: 3))
                }
                
                // Select 按钮
                Button(action: {
                    currentSort = tempSelectedOption
                    withAnimation {
                        isPresented = false
                    }
                }) {
                    Text("Select")
                        .font(.custom("Luckiest Guy", size: 20))
                        // 🆕 修正位置：中号按钮下移 4
                        .offset(y: 4)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(GameTheme.brown, lineWidth: 3))
                }
            }
            .padding(.top, 10)
        }
        .padding(25)
        .frame(width: 320)
        .background(GameTheme.cream)
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(GameTheme.brown, lineWidth: 5)
        )
        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 10)
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
                    // 🆕 修正位置：小号文字下移 3
                    .offset(y: 3)
                
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
