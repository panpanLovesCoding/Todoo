import SwiftUI

class TodoManager: ObservableObject {
    @Published var items: [TodoItem] = [] {
        didSet {
            saveData()
        }
    }
    
    private let fileName = "todos.json"
    
    init() {
        loadData()
    }
    
    // MARK: - User Actions
    
    func toggleStatus(for item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            withAnimation(.spring()) {
                items[index].isCompleted.toggle()
                if items[index].isCompleted {
                    items[index].completedAt = Date()
                } else {
                    items[index].completedAt = nil
                }
            }
        }
    }
    
    func delete(item: TodoItem) {
        withAnimation {
            items.removeAll(where: { $0.id == item.id })
        }
    }
    
    func delete(id: UUID) {
        withAnimation {
            items.removeAll(where: { $0.id == id })
        }
    }
    
    func addOrUpdate(_ item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            var updatedItem = item
            updatedItem.createdAt = items[index].createdAt // Keep original creation date
            items[index] = updatedItem
        } else {
            items.append(item)
        }
    }
    
    // MARK: - Persistence Logic (更为健壮的保存/读取)
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func saveData() {
        do {
            let data = try JSONEncoder().encode(items)
            let url = getDocumentsDirectory().appendingPathComponent(fileName)
            try data.write(to: url)
            print("💾 Data saved successfully to: \(url.path)")
        } catch {
            print("❌ Failed to save data: \(error.localizedDescription)")
        }
    }
    
    private func loadData() {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            let data = try Data(contentsOf: url)
            let decodedItems = try JSONDecoder().decode([TodoItem].self, from: data)
            self.items = decodedItems
            print("📂 Data loaded successfully. Count: \(decodedItems.count)")
        } catch {
            // 如果读取失败（比如因为数据结构变了），这里会打印具体原因
            print("⚠️ Failed to load data (Starting fresh): \(error)")
        }
    }
}
