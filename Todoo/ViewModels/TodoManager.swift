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
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "TodoItems")
        }
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: "TodoItems"),
           let decoded = try? JSONDecoder().decode([TodoItem].self, from: data) {
            items = decoded
        }
    }
}
