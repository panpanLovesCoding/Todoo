import SwiftUI

struct SortPopupView: View {
    @Binding var isPresented: Bool
    @Binding var currentSort: SortOption
    
    @ObservedObject var lang = LanguageManager.shared
    
    @State private var tempSelectedOption: SortOption = .creationDate
    
    var body: some View {
        VStack(spacing: 20) {
            // 标题
            Text(lang.localized("SORT BY"))
                .font(.custom(getFontName(), size: 35))
                .foregroundColor(GameTheme.pumpkin)
                .offset(y: getTextOffset(size: 35))
                .shadow(color: .black, radius: 0, x: 1, y: 1)
                .padding(.top, 10)
            
            VStack(spacing: 12) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    SortButton(
                        title: lang.localized(option.rawValue),
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
                // Cancel
                Button(action: { withAnimation { isPresented = false } }) {
                    Text(lang.localized("Cancel"))
                        .font(.custom(getFontName(), size: 20))
                        .offset(y: getTextOffset(size: 20))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(GameTheme.brown, lineWidth: 3))
                }
                
                // Select
                Button(action: {
                    currentSort = tempSelectedOption
                    withAnimation {
                        isPresented = false
                    }
                }) {
                    Text(lang.localized("Select"))
                        .font(.custom(getFontName(), size: 20))
                        .offset(y: getTextOffset(size: 20))
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
    
    func getFontName() -> String {
        return lang.language == "zh" ? "HappyZcool-2016" : "LuckiestGuy-Regular"
    }
    
    func getTextOffset(size: CGFloat) -> CGFloat {
        if lang.language == "zh" { return 0 }
        return size > 30 ? 5 : 4
    }
    
    func iconFor(_ option: SortOption) -> String {
        switch option {
        case .creationDate: return "calendar.badge.plus"
        case .deadline: return "hourglass"
        case .title: return "textformat.abc"
        }
    }
}

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
