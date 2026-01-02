import SwiftUI

struct AddEditView: View {
    @ObservedObject var manager: TodoManager
    let itemToEdit: TodoItem?
    
    // 绑定，用于关闭弹窗
    var isPresented: Binding<Bool>? = nil
    
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var deadline = Date()
    @State private var isUrgent = false
    @State private var isImportant = false
    
    // 🆕 新增：控制删除确认弹窗的状态
    @State private var showingDeleteAlert = false
    
    @ObservedObject var lang = LanguageManager.shared
    
    var isEditing: Bool { itemToEdit != nil }
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text(isEditing ? "EDIT QUEST" : "NEW QUEST")
                .font(.custom("Luckiest Guy", size: 40))
                .foregroundColor(isEditing ? Color.blue : GameTheme.background)
                .shadow(color: .black, radius: 0, x: 1, y: 1)
                .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 15) {
                
                // Name
                VStack(alignment: .leading, spacing: 5) {
                    Text(lang.localized("Quest Name"))
                        .font(.custom("Luckiest Guy", size: 18))
                        .foregroundColor(GameTheme.brown)
                    
                    TextField("Enter quest name...", text: $title)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(GameTheme.brown.opacity(0.3), lineWidth: 2))
                        .font(.system(.body, design: .rounded).weight(.bold))
                        .foregroundColor(GameTheme.brown)
                }
                
                // Deadline
                VStack(alignment: .leading, spacing: 5) {
                    Text(lang.localized("Deadline"))
                        .font(.custom("Luckiest Guy", size: 18))
                        .foregroundColor(GameTheme.brown)
                    
                    DatePicker("", selection: $deadline, displayedComponents: .date)
                        .labelsHidden()
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(GameTheme.brown.opacity(0.3), lineWidth: 2))
                        .accentColor(GameTheme.brown)
                }
                
                // Toggles
                HStack(spacing: 12) {
                    ToggleView(title: "Urgent", isOn: $isUrgent, icon: "flame.fill", color: GameTheme.red)
                    ToggleView(title: "Important", isOn: $isImportant, icon: "star.fill", color: GameTheme.yellow)
                }
            }
            .padding(.horizontal, 10)
            
            // Buttons
            HStack(spacing: 20) {
                Button(action: closeView) {
                    Text(lang.localized("Cancel"))
                        .font(.custom("Luckiest Guy", size: 20))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(GameTheme.brown, lineWidth: 3))
                }
                
                Button(action: saveItem) {
                    Text(lang.localized("Save"))
                        .font(.custom("Luckiest Guy", size: 20))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(GameTheme.brown, lineWidth: 3))
                }
                .disabled(title.isEmpty)
            }
            .padding(.top, 10)
            
            if isEditing {
                // 👇 修改：点击按钮不再直接删除，而是弹出确认框
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
        .onAppear {
            if let item = itemToEdit {
                title = item.title
                deadline = item.deadline
                isUrgent = item.isUrgent
                isImportant = item.isImportant
            }
        }
        // 🆕 新增：删除确认弹窗
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Abandon Quest?"), // 标题
                message: Text("Are you sure you want to abandon this quest? This cannot be undone."), // 内容
                primaryButton: .destructive(Text("Abandon")) { // 确认按钮 (红色)
                    deleteItem()
                },
                secondaryButton: .cancel() // 取消按钮
            )
        }
    }
    
    // MARK: - Actions
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
            binding.wrappedValue = false
        } else {
            dismiss()
        }
    }
}

// 辅助组件
struct ToggleView: View {
    let title: String
    @Binding var isOn: Bool
    let icon: String
    let color: Color
    
    var body: some View {
        Button(action: { isOn.toggle() }) {
            HStack {
                Image(systemName: isOn ? icon : "circle")
                    .foregroundColor(isOn ? color : GameTheme.brown.opacity(0.5))
                Text(title)
                    .font(.custom("Luckiest Guy", size: 16))
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
