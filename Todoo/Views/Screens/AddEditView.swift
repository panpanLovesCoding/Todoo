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
    
    // 阴影逻辑
    func boldShadowColor(_ color: Color) -> Color {
        return lang.language == "zh" ? color : .clear
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            // 标题
            Text(lang.localized(isEditing ? "EDIT QUEST" : "NEW QUEST"))
                .font(.custom(fontName, size: 45))
                .foregroundColor(isEditing ? Color.blue : GameTheme.background)
                .offset(y: yOffset)
                .shadow(color: .black, radius: 0, x: 2, y: 4)
                .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 15) {
                
                // Name
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
                
                // Deadline
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
                
                // Toggles (现在会引用独立的 ToggleView.swift)
                HStack(spacing: 12) {
                    ToggleView(title: lang.localized("Urgent"), isOn: $isUrgent, icon: "flame.fill", color: GameTheme.red)
                    ToggleView(title: lang.localized("Important"), isOn: $isImportant, icon: "star.fill", color: GameTheme.yellow)
                }
            }
            .padding(.horizontal, 10)
            
            // Buttons
            HStack(spacing: 15) {
                // Cancel 按钮
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
                    .shadow(color: boldShadowColor(.white), radius: 0, x: 1, y: 1)
                }
                .buttonStyle(CartoonButtonStyle(color: Color(red: 0.85, green: 0.3, blue: 0.3), cornerRadius: 12))
                
                // Save 按钮
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
                    .shadow(color: boldShadowColor(.white), radius: 0, x: 1, y: 1)
                }
                .buttonStyle(CartoonButtonStyle(color: GameTheme.emerald, cornerRadius: 12))
                .disabled(title.isEmpty)
                .opacity(title.isEmpty ? 0.6 : 1.0)
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
        // ✨ 修改这里：拆分 padding，把底部(bottom)从 25 改成 35
        .padding(.horizontal, 25) // 左右保持 25
        .padding(.top, 25)        // 顶部保持 25 (加上内部的 padding 视觉上是 35)
        .padding(.bottom, 35)     // 底部增加到 43，这样看起来就和上面一样宽敞了！
        
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
            // ✨ 新增：加了 0.15 秒延迟，让按钮动画和声音飞一会儿
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let binding = isPresented {
                    withAnimation(.spring()) {
                        binding.wrappedValue = false
                    }
                } else {
                    dismiss()
                }
            }
        }
}
