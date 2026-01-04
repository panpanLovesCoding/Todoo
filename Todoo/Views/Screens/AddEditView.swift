import SwiftUI

struct AddEditView: View {
    @ObservedObject var manager: TodoManager
    let itemToEdit: TodoItem?
    
    var isPresented: Binding<Bool>? = nil
    
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var deadline = Date()
    @State private var isUrgent = false
    @State private var isImportant = false
    
    @State private var showingDeleteAlert = false
    
    @ObservedObject var lang = LanguageManager.shared
    
    var isEditing: Bool { itemToEdit != nil }
    
    // 字体与偏移
    var fontName: String { lang.language == "zh" ? "HappyZcool-2016" : "LuckiestGuy-Regular" }
    var yOffset: CGFloat { lang.language == "zh" ? 0 : 5 }
    
    // 🛠️ 阴影逻辑 (统一风格)
    func boldShadowColor(_ color: Color) -> Color {
        return lang.language == "zh" ? color : .clear
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            // 标题
            Text(lang.localized(isEditing ? "EDIT QUEST" : "NEW QUEST"))
                .font(.custom(fontName, size: 40))
                .foregroundColor(isEditing ? Color.blue : GameTheme.background)
                .offset(y: yOffset)
                .shadow(color: .black, radius: 0, x: 1, y: 1)
                .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 15) {
                
                // Name (普通字体)
                VStack(alignment: .leading, spacing: 5) {
                    Text(lang.localized("Quest Name"))
                        .font(.system(.headline, design: .rounded).weight(.bold))
                        .foregroundColor(GameTheme.brown)
                    
                    TextField(lang.localized("Enter quest name..."), text: $title)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(GameTheme.brown.opacity(0.3), lineWidth: 2))
                        .font(.system(.body, design: .rounded).weight(.bold))
                        .foregroundColor(.black)
                        .accentColor(GameTheme.brown)
                }
                
                // Deadline (普通字体)
                VStack(alignment: .leading, spacing: 5) {
                    Text(lang.localized("Deadline"))
                        .font(.system(.headline, design: .rounded).weight(.bold))
                        .foregroundColor(GameTheme.brown)
                    
                    DatePicker("", selection: $deadline, displayedComponents: .date)
                        .labelsHidden()
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(GameTheme.brown.opacity(0.3), lineWidth: 2))
                        .accentColor(GameTheme.brown)
                        .colorScheme(.light)
                }
                
                // Toggles (特殊字体 + 中文)
                HStack(spacing: 12) {
                    ToggleView(title: lang.localized("Urgent"), isOn: $isUrgent, icon: "flame.fill", color: GameTheme.red)
                    ToggleView(title: lang.localized("Important"), isOn: $isImportant, icon: "star.fill", color: GameTheme.yellow)
                }
            }
            .padding(.horizontal, 10)
            
            // Buttons
            HStack(spacing: 15) {
                // Cancel 按钮 (红色卡通风格)
                Button(action: closeView) {
                    HStack {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .bold))
                        Text(lang.localized("Cancel"))
                            .font(.custom(fontName, size: 20))
                            .offset(y: lang.language == "zh" ? 0 : 4)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .foregroundColor(.white)
                    // 文字白色阴影
                    .shadow(color: boldShadowColor(.white), radius: 0, x: 1, y: 1)
                }
                .buttonStyle(CartoonButtonStyle(color: Color(red: 0.85, green: 0.3, blue: 0.3), cornerRadius: 12))
                
                // Save 按钮 (绿色卡通风格)
                Button(action: saveItem) {
                    HStack {
                        Image(systemName: "checkmark")
                            .font(.system(size: 20, weight: .bold))
                        Text(lang.localized("Save"))
                            .font(.custom(fontName, size: 20))
                            .offset(y: lang.language == "zh" ? 0 : 4)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .foregroundColor(.white)
                    // 文字白色阴影
                    .shadow(color: boldShadowColor(.white), radius: 0, x: 1, y: 1)
                }
                .buttonStyle(CartoonButtonStyle(color: GameTheme.green, cornerRadius: 12))
                .disabled(title.isEmpty)
                .opacity(title.isEmpty ? 0.6 : 1.0) // 禁用时变淡
            }
            .padding(.top, 10)
            
            if isEditing {
                Button(action: { showingDeleteAlert = true }) {
                    Label(lang.localized("Abandon Quest"), systemImage: "trash")
                        .font(.system(.subheadline, design: .rounded).weight(.bold))
                        .foregroundColor(GameTheme.red)
                }
                .padding(.top, 5)
            }
        }
        .padding(25)
        .frame(maxWidth: 340)
        .background(GameTheme.cream)
        .cornerRadius(25)
        .overlay(RoundedRectangle(cornerRadius: 25).stroke(GameTheme.brown, lineWidth: 5))
        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 10)
        .environment(\.colorScheme, .light)
        .onAppear {
            if let item = itemToEdit {
                title = item.title
                deadline = item.deadline
                isUrgent = item.isUrgent
                isImportant = item.isImportant
            }
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text(lang.localized("Abandon Quest?")),
                message: Text(lang.localized("ABANDON_WARNING")),
                primaryButton: .destructive(Text(lang.localized("Abandon"))) {
                    deleteItem()
                },
                secondaryButton: .cancel(Text(lang.localized("Cancel")))
            )
        }
    }
    
    func saveItem() {
        if let item = itemToEdit {
            manager.updateItem(item: item, title: title, deadline: deadline, isUrgent: isUrgent, isImportant: isImportant)
        } else {
            manager.addItem(title: title, deadline: deadline, isUrgent: isUrgent, isImportant: isImportant)
        }
        closeView()
    }
    
    func deleteItem() {
        if let item = itemToEdit {
            manager.deleteItem(item: item)
        }
        closeView()
    }
    
    func closeView() {
        if let binding = isPresented {
            withAnimation(.spring()) {
                binding.wrappedValue = false
            }
        } else {
            dismiss()
        }
    }
}

// 辅助组件：ToggleView
struct ToggleView: View {
    let title: String
    @Binding var isOn: Bool
    let icon: String
    let color: Color
    
    @ObservedObject var lang = LanguageManager.shared
    
    var fontName: String { lang.language == "zh" ? "HappyZcool-2016" : "LuckiestGuy-Regular" }
    var yOffset: CGFloat { lang.language == "zh" ? 0 : 3 }
    
    var body: some View {
        Button(action: { isOn.toggle() }) {
            HStack {
                Image(systemName: isOn ? icon : "circle")
                    .foregroundColor(isOn ? color : GameTheme.brown.opacity(0.5))
                Text(title)
                    .font(.custom(fontName, size: 16))
                    .offset(y: yOffset)
                    .foregroundColor(GameTheme.brown)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(isOn ? color : GameTheme.brown.opacity(0.2), lineWidth: 2))
        }
    }
}
