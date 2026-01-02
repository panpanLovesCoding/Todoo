import SwiftUI

// 👇 1. 将 SortOption 移到这里，修复 "Cannot find type" 错误
enum SortOption: String, CaseIterable {
    case creationDate = "Created Time"
    case deadline = "Due Date"
    case title = "Task Name"
}

class TodoManager: ObservableObject {
    @Published var items: [TodoItem] = [] {
        didSet {
            save()
        }
    }
    
    init() {
        load()
    }
    
    // 1. 添加任务
    func addItem(title: String, deadline: Date, isUrgent: Bool, isImportant: Bool) {
        let newItem = TodoItem(
            title: title,
            deadline: deadline,
            isUrgent: isUrgent,
            isImportant: isImportant
        )
        items.append(newItem)
    }
    
    // 2. 更新任务
    func updateItem(item: TodoItem, title: String, deadline: Date, isUrgent: Bool, isImportant: Bool) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            var updatedItem = items[index]
            updatedItem.title = title
            updatedItem.deadline = deadline
            updatedItem.isUrgent = isUrgent
            updatedItem.isImportant = isImportant
            items[index] = updatedItem
        }
    }
    
    // 3. 删除任务
    func deleteItem(item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items.remove(at: index)
        }
    }
    
    // 4. 切换状态
    func toggleStatus(for item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompleted.toggle()
            if items[index].isCompleted {
                items[index].completedAt = Date()
            } else {
                items[index].completedAt = nil
            }
        }
    }
    
    // MARK: - Data Persistence
    private func save() {
        // 1. 捕获当前数据副本 (在主线程获取，防止多线程竞争)
        let itemsToSave = self.items
        
        // 2. 将耗时的“打包数据”操作移到后台线程
        DispatchQueue.global(qos: .background).async {
            // 3. 编码数据 (这是最耗时的步骤，放在后台就不卡界面了)
            if let encoded = try? JSONEncoder().encode(itemsToSave) {
                // 4. 保存到 UserDefaults
                UserDefaults.standard.set(encoded, forKey: "TodoItems")
            }
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: "TodoItems"),
           let decoded = try? JSONDecoder().decode([TodoItem].self, from: data) {
            items = decoded
        }
    }
}
