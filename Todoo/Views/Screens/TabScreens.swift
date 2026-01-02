import SwiftUI

// MARK: - Tab 1: Active List
struct TodoListView: View {
    @ObservedObject var manager: TodoManager
    @Binding var itemToEdit: TodoItem?
    let sortOption: SortOption
    
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
                            EmptyStateView(message: "No active quests!")
                        }
                        .padding(.top, 40)
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
                // 👇 优化：加上显式动画
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    manager.toggleStatus(for: item)
                }
            }
        )
        .background(GameTheme.cream)
        .onTapGesture {
            withAnimation { itemToEdit = item }
        }
        // 动画：进出都从底部滑动
        .transition(.asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .bottom).combined(with: .opacity)
        ))
    }
}

// 头部：Active List Header
struct TodoListHeader: View {
    var body: some View {
        ZStack {
            Color(red: 0.5, green: 0.35, blue: 0.2)
            Text("QUEST LOG")
                .font(.custom("Luckiest Guy", size: 28))
                .foregroundColor(GameTheme.cream)
                .shadow(color: Color.black.opacity(0.3), radius: 0, x: 2, y: 2)
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
    
    // 🆕 新增：动态计算象限顺序
    // 逻辑：有任务的象限在上面，没任务的象限沉到底部，内部保持原有顺序
    var sortedQuadrants: [EisenhowerQuadrant] {
        // 1. 找出所有包含“未完成任务”的象限集合
        let activeQuadrants = Set(
            manager.items
                .filter { !$0.isCompleted } // 只看未完成的
                .map { $0.quadrant }
        )
        
        // 2. 按原始顺序筛选出“非空象限”
        let nonEmpty = EisenhowerQuadrant.allCases.filter { activeQuadrants.contains($0) }
        
        // 3. 按原始顺序筛选出“空象限”
        let empty = EisenhowerQuadrant.allCases.filter { !activeQuadrants.contains($0) }
        
        // 4. 拼接：非空在前，空在后
        return nonEmpty + empty
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                // 👇 修改：这里不再遍历 allCases，而是遍历 sortedQuadrants
                ForEach(sortedQuadrants, id: \.self) { quadrant in
                    // 获取该象限的任务（逻辑不变）
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
                                // 空状态显示
                                Text("Empty")
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
                        // 加上动画，这样象限移动时会有平滑效果
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: items)
                    }
                }
            }
            .background(GameTheme.cream)
            // 👇 🆕 给整个列表加动画，确保象限上下移动时也是平滑的
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: sortedQuadrants)
        }
        .background(GameTheme.cream)
    }
}

// 子视图：Matrix 列表行
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
                // 👇 修复：使用显式动画包裹状态变更，强制触发过渡效果
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

// 头部：Matrix Header
struct MatrixSectionHeader: View {
    let quadrant: EisenhowerQuadrant
    var body: some View {
        ZStack {
            quadrant.color
            Text(quadrant.rawValue)
                .font(.custom("Luckiest Guy", size: 28))
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.3), radius: 0, x: 2, y: 2)
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
    
    var completedItems: [TodoItem] {
        manager.items.filter { $0.isCompleted }
            .sorted { ($0.completedAt ?? Date()) > ($1.completedAt ?? Date()) }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section(header: CompletedListHeader()) {
                    if completedItems.isEmpty {
                        VStack {
                            EmptyStateView(message: "No completed quests yet!")
                        }
                        .padding(.top, 40)
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

// 子视图：Completed 列表行
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
                // 👇 优化：加上显式动画
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

// 头部：Completed List Header
struct CompletedListHeader: View {
    var body: some View {
        ZStack {
            Color(red: 0.2, green: 0.6, blue: 0.3)
            Text("COMPLETED LOG")
                .font(.custom("Luckiest Guy", size: 28))
                .foregroundColor(GameTheme.cream)
                .shadow(color: Color.black.opacity(0.3), radius: 0, x: 2, y: 2)
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

// 辅助组件：Empty State
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
