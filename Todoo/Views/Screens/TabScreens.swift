import SwiftUI

// MARK: - Tab 1: Active List
struct TodoListView: View {
    @ObservedObject var manager: TodoManager
    @Binding var itemToEdit: TodoItem?
    let sortOption: SortOption
    
    // 🆕 引入语言管理器
    @ObservedObject var lang = LanguageManager.shared
    
    var activeItems: [TodoItem] {
        let filtered = manager.items.filter { !$0.isCompleted }
        switch sortOption {
        case .creationDate: return filtered.sorted { $0.createdAt > $1.createdAt }
        case .deadline: return filtered.sorted { $0.deadline < $1.deadline }
        case .title: return filtered.sorted { $0.title.localizedStandardCompare($1.title) == .orderedAscending }
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section(header: TodoListHeader()) {
                    if activeItems.isEmpty {
                        VStack {
                            Text(lang.localized("No active quests!")) // 🌐 本地化
                                .font(.custom(lang.language == "zh" ? "HappyZcool-2016" : "LuckiestGuy-Regular", size: 20))
                                .foregroundColor(GameTheme.brown.opacity(0.5))
                                .padding(.top, 40)
                        }
                    } else {
                        VStack(spacing: 0) {
                            ForEach(activeItems, id: \.id) { item in
                                ActiveTodoRow(item: item, manager: manager, itemToEdit: $itemToEdit)
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.bottom, 20)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: activeItems)
                    }
                }
            }
        }
        .background(GameTheme.cream)
    }
}

// 子视图：Active 列表行
struct ActiveTodoRow: View {
    let item: TodoItem
    @ObservedObject var manager: TodoManager
    @Binding var itemToEdit: TodoItem?
    
    var body: some View {
        TodoCard(
            item: item,
            isCardStyle: false,
            onToggle: {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    manager.toggleStatus(for: item)
                }
            }
        )
        .background(GameTheme.cream)
        .onTapGesture {
            withAnimation { itemToEdit = item }
        }
        .transition(.asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .bottom).combined(with: .opacity)
        ))
    }
}

// 头部：Active List Header
struct TodoListHeader: View {
    @ObservedObject var lang = LanguageManager.shared
    
    // 🛠️ 字体与偏移
    var fontName: String { lang.language == "zh" ? "HappyZcool-2016" : "LuckiestGuy-Regular" }
    var yOffset: CGFloat { lang.language == "zh" ? 0 : 5 }
    
    var body: some View {
        ZStack {
            Color(red: 0.5, green: 0.35, blue: 0.2)
            Text(lang.localized("QUEST LOG")) // 🌐 本地化
                .font(.custom(fontName, size: 28))
                .foregroundColor(GameTheme.cream)
                .shadow(color: Color.black.opacity(0.3), radius: 0, x: 2, y: 2)
                .offset(y: yOffset)
                .padding(.vertical, 15)
        }
        .frame(height: 60)
        .overlay(
            Rectangle()
                .frame(height: 3)
                .foregroundColor(Color.black.opacity(0.3)),
            alignment: .bottom
        )
        .shadow(radius: 3)
    }
}

// MARK: - Tab 2: Matrix
struct EisenhowerMatrixView: View {
    @ObservedObject var manager: TodoManager
    let sortOption: SortOption
    @Binding var itemToEdit: TodoItem?
    
    @ObservedObject var lang = LanguageManager.shared
    
    var sortedQuadrants: [EisenhowerQuadrant] {
        let activeQuadrants = Set(
            manager.items
                .filter { !$0.isCompleted }
                .map { $0.quadrant }
        )
        let nonEmpty = EisenhowerQuadrant.allCases.filter { activeQuadrants.contains($0) }
        let empty = EisenhowerQuadrant.allCases.filter { !activeQuadrants.contains($0) }
        return nonEmpty + empty
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                ForEach(sortedQuadrants, id: \.self) { quadrant in
                    let baseItems = manager.items.filter { !$0.isCompleted && $0.quadrant == quadrant }
                    let items: [TodoItem] = {
                        switch sortOption {
                        case .creationDate: return baseItems.sorted { $0.createdAt > $1.createdAt }
                        case .deadline: return baseItems.sorted { $0.deadline < $1.deadline }
                        case .title: return baseItems.sorted { $0.title.localizedStandardCompare($1.title) == .orderedAscending }
                        }
                    }()
                    
                    Section(header: MatrixSectionHeader(quadrant: quadrant)) {
                        VStack(spacing: 0) {
                            if items.isEmpty {
                                Text(lang.localized("Empty")) // 🌐 本地化
                                    .font(.system(.body, design: .rounded).weight(.bold))
                                    .foregroundColor(GameTheme.brown.opacity(0.4))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(GameTheme.cream.opacity(0.5))
                                    .cornerRadius(8)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 4)
                            } else {
                                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                                    MatrixTodoRow(
                                        item: item,
                                        showSeparator: index < items.count - 1,
                                        manager: manager,
                                        itemToEdit: $itemToEdit
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 0)
                        .padding(.bottom, 6)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: items)
                    }
                }
            }
            .background(GameTheme.cream)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: sortedQuadrants)
        }
        .background(GameTheme.cream)
    }
}

struct MatrixTodoRow: View {
    let item: TodoItem
    let showSeparator: Bool
    @ObservedObject var manager: TodoManager
    @Binding var itemToEdit: TodoItem?
    
    var body: some View {
        TodoCard(
            item: item,
            isCardStyle: false,
            showSeparator: showSeparator,
            onToggle: {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    manager.toggleStatus(for: item)
                }
            }
        )
        .background(GameTheme.cream)
        .onTapGesture {
            withAnimation { itemToEdit = item }
        }
        .transition(.asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .bottom).combined(with: .opacity)
        ))
    }
}

// 🆕 头部：Matrix Header
struct MatrixSectionHeader: View {
    let quadrant: EisenhowerQuadrant
    @ObservedObject var lang = LanguageManager.shared
    
    var fontName: String { lang.language == "zh" ? "HappyZcool-2016" : "LuckiestGuy-Regular" }
    var yOffset: CGFloat { lang.language == "zh" ? 0 : 5 }
    
    // 🛠️ 强制键值映射 (Safe Mapping)
    // 无论 rawValue 是什么，都强制转换成我们在 LanguageManager 里定义的 Key
    var quadrantKey: String {
        switch quadrant {
        case .doNow: return "Do Now"
        case .plan: return "Plan"
        case .delegate: return "Delegate"
        case .later: return "Later"
        }
    }
    
    var body: some View {
        ZStack {
            quadrant.color
            Text(lang.localized(quadrantKey)) // 使用强制映射的 Key
                .font(.custom(fontName, size: 28))
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.3), radius: 0, x: 2, y: 2)
                .offset(y: yOffset)
                .padding(.vertical, 15)
        }
        .frame(height: 60)
        .overlay(
            Rectangle()
                .frame(height: 3)
                .foregroundColor(Color.black.opacity(0.3)),
            alignment: .bottom
        )
        .shadow(radius: 3)
    }
}

// MARK: - Tab 3: Completed
struct CompletedListView: View {
    @ObservedObject var manager: TodoManager
    @Binding var itemToEdit: TodoItem?
    let sortOption: SortOption
    
    @ObservedObject var lang = LanguageManager.shared
    
    var completedItems: [TodoItem] {
        let items = manager.items.filter { $0.isCompleted }
        switch sortOption {
        case .creationDate: return items.sorted { $0.createdAt > $1.createdAt }
        case .deadline: return items.sorted { $0.deadline < $1.deadline }
        case .title: return items.sorted { $0.title.localizedStandardCompare($1.title) == .orderedAscending }
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section(header: CompletedListHeader()) {
                    if completedItems.isEmpty {
                        VStack {
                            Text(lang.localized("No completed quests yet!")) // 🌐 本地化
                                .font(.custom(lang.language == "zh" ? "HappyZcool-2016" : "LuckiestGuy-Regular", size: 20))
                                .foregroundColor(GameTheme.brown.opacity(0.5))
                                .padding(.top, 40)
                        }
                    } else {
                        VStack(spacing: 0) {
                            ForEach(Array(completedItems.enumerated()), id: \.element.id) { index, item in
                                CompletedTodoRow(item: item, manager: manager, itemToEdit: $itemToEdit)
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.bottom, 20)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: completedItems)
                    }
                }
            }
        }
        .background(GameTheme.cream)
    }
}

struct CompletedTodoRow: View {
    let item: TodoItem
    @ObservedObject var manager: TodoManager
    @Binding var itemToEdit: TodoItem?
    
    var body: some View {
        TodoCard(
            item: item,
            isCardStyle: false,
            showSeparator: true,
            onToggle: {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    manager.toggleStatus(for: item)
                }
            }
        )
        .background(GameTheme.cream)
        .opacity(0.8)
        .saturation(0.8)
        .onTapGesture {
            withAnimation { itemToEdit = item }
        }
        .transition(.asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .bottom).combined(with: .opacity)
        ))
    }
}

// 🆕 头部：Completed List Header
struct CompletedListHeader: View {
    @ObservedObject var lang = LanguageManager.shared
    
    var fontName: String { lang.language == "zh" ? "HappyZcool-2016" : "LuckiestGuy-Regular" }
    var yOffset: CGFloat { lang.language == "zh" ? 0 : 5 }
    
    var body: some View {
        ZStack {
            Color(red: 0.2, green: 0.6, blue: 0.3)
            Text(lang.localized("COMPLETED LOG")) // 🌐 本地化
                .font(.custom(fontName, size: 28))
                .foregroundColor(GameTheme.cream)
                .shadow(color: Color.black.opacity(0.3), radius: 0, x: 2, y: 2)
                .offset(y: yOffset)
                .padding(.vertical, 15)
        }
        .frame(height: 60)
        .overlay(
            Rectangle()
                .frame(height: 3)
                .foregroundColor(Color.black.opacity(0.3)),
            alignment: .bottom
        )
        .shadow(radius: 3)
    }
}

struct EmptyStateView: View {
    let message: String
    var body: some View {
        VStack {
            Image(systemName: "scroll")
                .font(.system(size: 50))
                .foregroundColor(GameTheme.brown.opacity(0.5))
                .padding(.bottom)
            Text(message)
                .font(.system(.headline, design: .rounded).weight(.bold))
                .foregroundColor(GameTheme.brown)
        }
        .padding(.top, 50)
        .frame(maxWidth: .infinity)
    }
}
