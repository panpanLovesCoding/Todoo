import SwiftUI

struct AddEditView: View {
    @ObservedObject var manager: TodoManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    // 默认截止日期为明天
    @State private var deadline: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @State private var isImportant: Bool = false
    @State private var isUrgent: Bool = false
    @State private var id: UUID?
    // 新增：记录该任务是否已经完成 (用于 UI 判断)
    @State private var isCompleted: Bool = false
    
    init(manager: TodoManager, itemToEdit: TodoItem?) {
        self.manager = manager
        if let item = itemToEdit {
            _title = State(initialValue: item.title)
            _deadline = State(initialValue: item.deadline)
            _isImportant = State(initialValue: item.isImportant)
            _isUrgent = State(initialValue: item.isUrgent)
            _id = State(initialValue: item.id)
            _isCompleted = State(initialValue: item.isCompleted)
        }
    }
    
    var body: some View {
        ZStack {
            GameTheme.cream.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // 1. 标题 (修改：使用 Luckiest Guy 字体，与按钮风格一致)
                Text(id == nil ? "NEW QUEST" : "EDIT QUEST")
                    .font(.custom("Luckiest Guy", size: 35)) // 👈 改了这里
                    .foregroundColor(GameTheme.brown)
                    .padding(.top)
                    .shadow(color: GameTheme.brown.opacity(0.3), radius: 0, x: 2, y: 2)
                
                // 表单区域
                VStack(spacing: 15) {
                    TextField("Quest Name", text: $title)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(GameTheme.brown, lineWidth: 3))
                        .foregroundColor(GameTheme.brown)
                        .font(.system(.body, design: .rounded).weight(.bold))
                    
                    DatePicker("Deadline Date", selection: $deadline, displayedComponents: .date)
                        .accentColor(GameTheme.brown)
                        .foregroundColor(GameTheme.brown)
                        .font(.system(.headline, design: .rounded).weight(.bold))
                    
                    Toggle("Important ⭐", isOn: $isImportant)
                        .toggleStyle(SwitchToggleStyle(tint: GameTheme.yellow))
                        .foregroundColor(GameTheme.brown)
                        .font(.system(.headline, design: .rounded).weight(.bold))

                    Toggle("Urgent 🔥", isOn: $isUrgent)
                        .toggleStyle(SwitchToggleStyle(tint: GameTheme.red))
                        .foregroundColor(GameTheme.brown)
                        .font(.system(.headline, design: .rounded).weight(.bold))
                }
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(15)
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(GameTheme.brown, lineWidth: 2))
                .padding()
                
                Spacer()
                
                // MARK: - 按钮区域 (布局重构)
                VStack(spacing: 15) {
                    
                    // 第一行：SAVE 和 DELETE
                    HStack(spacing: 15) {
                        // SAVE 按钮
                        Button(action: saveTask) {
                            Text("SAVE")
                                .frame(maxWidth: .infinity) // 撑满分配的空间
                        }
                        .buttonStyle(GameButtonStyle(color: GameTheme.green))
                        .disabled(title.isEmpty)
                        .opacity(title.isEmpty ? 0.6 : 1.0)
                        
                        // DELETE 按钮 (仅在编辑模式且有 ID 时显示)
                        if let safeId = id {
                            Button(action: {
                                manager.delete(id: safeId)
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("DELETE")
                                    .frame(maxWidth: .infinity) // 撑满分配的空间
                            }
                            .buttonStyle(GameButtonStyle(color: GameTheme.red))
                        }
                    }
                    
                    // 第二行：COMPLETE 按钮 (仅在编辑模式且未完成时显示)
                    // 要求：最下面，单独一行，比上面两个加起来还长
                    if id != nil && !isCompleted {
                        Button(action: completeTask) {
                            HStack {
                                Image(systemName: "checkmark.seal.fill")
                                Text("COMPLETE QUEST")
                            }
                            .frame(maxWidth: .infinity) // 👈 撑满整行宽度
                        }
                        .buttonStyle(GameButtonStyle(color: GameTheme.blue)) // 使用蓝色区分
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
            .padding()
        }
        .overlay(Rectangle().stroke(GameTheme.brown, lineWidth: 6))
    }
    
    // MARK: - 逻辑函数
    
    func saveTask() {
        let newItem = TodoItem(
            id: id ?? UUID(),
            title: title,
            deadline: deadline,
            isImportant: isImportant,
            isUrgent: isUrgent,
            isCompleted: isCompleted
            // createdAt 保持默认或由 manager 处理
        )
        manager.addOrUpdate(newItem)
        presentationMode.wrappedValue.dismiss()
    }
    
    func completeTask() {
        // 创建一个已完成的任务版本
        var completedItem = TodoItem(
            id: id ?? UUID(),
            title: title,
            deadline: deadline,
            isImportant: isImportant,
            isUrgent: isUrgent,
            isCompleted: true, // 标记为完成
            createdAt: Date() // 注意：这里如果想保留原创建时间，可以在 manager 里处理，或者忽略，因为 addOrUpdate 会处理
        )
        // 确保 manager 处理完成时间戳逻辑
        manager.toggleStatus(for: completedItem)
        // 实际上 manager.toggleStatus 是根据 ID 切换，所以我们只需要确保 ID 存在
        // 但这里我们直接用 addOrUpdate 更新属性更稳妥，或者直接调用 manager 的特定方法
        // 为了简单，我们手动设置状态并更新：
        completedItem.completedAt = Date()
        manager.addOrUpdate(completedItem)
        
        presentationMode.wrappedValue.dismiss()
    }
}
