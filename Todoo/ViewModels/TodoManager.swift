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
        
        // 🆕 新增：如果加载后发现列表是空的，就自动添加测试数据
        // 这样你每次重置数据(Delete All)并重启 App 后，都会有一批新数据方便测试
        if items.isEmpty {
            addSampleData()
        }
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
    
    // MARK: - User Persona Logic
    // 计算用户人设 (TitleKey, VibeKey)
    var userPersonality: (title: String, vibe: String) {
        let completedItems = items.filter { $0.isCompleted }
        
        // 初始状态 (没有完成任务时) -> Elite Vanguard
        if completedItems.isEmpty {
            return ("TITLE_ELITE_VANGUARD", "VIBE_ELITE_VANGUARD")
        }
        
        // 1. 统计各象限数量
        var counts: [EisenhowerQuadrant: Int] = [
            .doNow: 0, .plan: 0, .delegate: 0, .eliminate: 0
        ]
        
        for item in completedItems {
            counts[item.quadrant, default: 0] += 1
        }
        
        // 2. 排序：数量多的在前。如果数量相同，按固定优先级排序(DoNow > Plan > Delegate > Eliminate)以保持稳定性
        let sortedQuadrants = counts.sorted { (pair1, pair2) -> Bool in
            if pair1.value == pair2.value {
                // 处理平局情况的优先级
                let priority: [EisenhowerQuadrant: Int] = [.doNow: 4, .plan: 3, .delegate: 2, .eliminate: 1]
                return priority[pair1.key, default: 0] > priority[pair2.key, default: 0]
            }
            return pair1.value > pair2.value
        }
        
        // 3. 获取 Top 1 和 Top 2
        // 因为我们初始化了字典所有 Key，所以 sortedQuadrants 永远有4个元素
        let first = sortedQuadrants[0].key
        let second = sortedQuadrants[1].key
        
        // 4. 匹配人设
        switch (first, second) {
        // Group 1: DO NOW 霸榜
        case (.doNow, .plan): return ("TITLE_ELITE_VANGUARD", "VIBE_ELITE_VANGUARD")
        case (.doNow, .delegate): return ("TITLE_CHAOS_SURFER", "VIBE_CHAOS_SURFER")
        case (.doNow, .eliminate): return ("TITLE_DEADLINE_DAREDEVIL", "VIBE_DEADLINE_DAREDEVIL")
            
        // Group 2: PLAN 霸榜
        case (.plan, .doNow): return ("TITLE_GRANDMASTER", "VIBE_GRANDMASTER")
        case (.plan, .delegate): return ("TITLE_BENEVOLENT_RULER", "VIBE_BENEVOLENT_RULER")
        case (.plan, .eliminate): return ("TITLE_PHILOSOPHER_KING", "VIBE_PHILOSOPHER_KING")
            
        // Group 3: DELEGATE 霸榜
        case (.delegate, .doNow): return ("TITLE_SPINNING_TOP", "VIBE_SPINNING_TOP")
        case (.delegate, .plan): return ("TITLE_SIDE_QUEST_HERO", "VIBE_SIDE_QUEST_HERO")
        case (.delegate, .eliminate): return ("TITLE_NPC_ENERGY", "VIBE_NPC_ENERGY")
            
        // Group 4: LATER 霸榜
        case (.eliminate, .doNow): return ("TITLE_CLUTCH_GAMER", "VIBE_CLUTCH_GAMER")
        case (.eliminate, .plan): return ("TITLE_DAYDREAM_BELIEVER", "VIBE_DAYDREAM_BELIEVER")
        case (.eliminate, .delegate): return ("TITLE_POTATO_MODE", "VIBE_POTATO_MODE")
            
        // 理论上不会走到这里，因为上面的 case 覆盖了所有排列，但为了保险：
        default: return ("TITLE_ELITE_VANGUARD", "VIBE_ELITE_VANGUARD")
        }
    }
    
    // MARK: - Debug / Test Data
    // 🆕 新增：生成测试数据
    func addSampleData() {
        let now = Date()
        let day = 86400.0 // 一天的秒数
        
        let samples = [
            // 🔴 Quadrant 1: Do Now (Urgent + Important)
            TodoItem(title: "🔥 Fix Crash Bug", deadline: now.addingTimeInterval(3600), isUrgent: true, isImportant: true),
            TodoItem(title: "Submit App Review", deadline: now.addingTimeInterval(day), isUrgent: true, isImportant: true),
            TodoItem(title: "Pay Server Bill", deadline: now.addingTimeInterval(day * 0.5), isUrgent: true, isImportant: true),
            
            // 🔵 Quadrant 2: Plan (Not Urgent + Important)
            TodoItem(title: "📚 Learn SwiftUI Animation", deadline: now.addingTimeInterval(day * 7), isUrgent: false, isImportant: true),
            TodoItem(title: "Design New Icon", deadline: now.addingTimeInterval(day * 3), isUrgent: false, isImportant: true),
            TodoItem(title: "Plan Marketing Strategy", deadline: now.addingTimeInterval(day * 10), isUrgent: false, isImportant: true),
            
            // 🟡 Quadrant 3: Delegate (Urgent + Not Important)
            TodoItem(title: "📞 Return Mom's Call", deadline: now.addingTimeInterval(1800), isUrgent: true, isImportant: false),
            TodoItem(title: "Reply to Comments", deadline: now.addingTimeInterval(7200), isUrgent: true, isImportant: false),
            TodoItem(title: "Buy Coffee Beans", deadline: now.addingTimeInterval(day * 0.2), isUrgent: true, isImportant: false),
            
            // ⚪️ Quadrant 4: Later (Not Urgent + Not Important)
            TodoItem(title: "🎮 Watch Cat Videos", deadline: now.addingTimeInterval(day * 2), isUrgent: false, isImportant: false),
            TodoItem(title: "Organize Desktop Icons", deadline: now.addingTimeInterval(day * 5), isUrgent: false, isImportant: false),
            TodoItem(title: "Browse Reddit", deadline: now.addingTimeInterval(day * 1), isUrgent: false, isImportant: false)
        ]
        
        // 直接添加到数组
        items.append(contentsOf: samples)
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
        if let data = UserDefaults.standard.data(forKey: "TodoItems") {
            if let decoded = try? JSONDecoder().decode([TodoItem].self, from: data) {
                self.items = decoded
                return
            }
        }
        // 如果读取失败，数组保持为空，init 里会触发 addSampleData
    }
}
