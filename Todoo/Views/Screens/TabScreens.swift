import SwiftUI

// MARK: - Tab 1: Active List (修改版)
struct TodoListView: View {
    @ObservedObject var manager: TodoManager
    @State private var itemToEdit: TodoItem?
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
            // 🌟 使用 LazyVStack 并开启 Section Header 吸顶
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                
                // 🌟 新增 Section
                Section(header: TodoListHeader()) {
                    
                    if activeItems.isEmpty {
                        // 空状态
                        VStack {
                            EmptyStateView(message: "No active quests!")
                        }
                        .padding(.top, 40)
                    } else {
                        // 任务列表容器
                        VStack(spacing: 0) { // 间距设为 0，因为我们用分割线了
                            ForEach(activeItems) { item in
                                TodoCard(
                                    item: item,
                                    isCardStyle: false, // 👈 关键：设为 false，开启列表模式
                                    onToggle: { manager.toggleStatus(for: item) }
                                )
                                .background(GameTheme.cream) // 给每一行一个背景色
                                .onTapGesture { itemToEdit = item }
                            }
                        }
                        // 给整个列表加一个大的外边框和圆角，像一张长纸条
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(GameTheme.brown, lineWidth: 4)
                        )
                        .padding(.horizontal, 20) // 列表距离屏幕左右的距离
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .background(GameTheme.background)
        .sheet(item: $itemToEdit) { item in
            AddEditView(manager: manager, itemToEdit: item)
        }
    }
}

// MARK: - 新增组件：Todo List 吸顶标题
struct TodoListHeader: View {
    var body: some View {
        HStack {
            Image(systemName: "list.star") // 加个小图标装饰
                .foregroundColor(.white)
            Text("所有待办事项") // 👈 这里是你要的标题
                .font(.system(size: 20, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 25)
        .background(GameTheme.brown) // 使用深棕色背景
        .overlay(
            Rectangle()
                .frame(height: 3)
                .foregroundColor(Color.black.opacity(0.2)),
            alignment: .bottom
        )
        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 3)
    }
}

// MARK: - Tab 2: Matrix (保持吸顶样式)
struct EisenhowerMatrixView: View {
    @ObservedObject var manager: TodoManager
    @State private var itemToEdit: TodoItem?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                ForEach(EisenhowerQuadrant.allCases, id: \.self) { quadrant in
                    let items = manager.items.filter { !$0.isCompleted && $0.quadrant == quadrant }
                    Section(header: MatrixSectionHeader(quadrant: quadrant)) {
                        VStack(spacing: 12) {
                            if items.isEmpty {
                                Text("Empty")
                                    .font(.system(.body, design: .rounded).weight(.bold))
                                    .foregroundColor(GameTheme.brown.opacity(0.4))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 30)
                                    .background(GameTheme.cream.opacity(0.5))
                                    .cornerRadius(12)
                            } else {
                                ForEach(items) { item in
                                    // Matrix 这里继续使用卡片样式 (默认 isCardStyle: true)
                                    TodoCard(item: item) {
                                        manager.toggleStatus(for: item)
                                    }
                                    .onTapGesture { itemToEdit = item }
                                }
                            }
                        }
                        .padding(.horizontal, 25)
                        .padding(.vertical, 15)
                        .padding(.bottom, 10)
                    }
                }
            }
            .padding(.bottom, 20)
        }
        .background(GameTheme.background)
        .sheet(item: $itemToEdit) { item in
            AddEditView(manager: manager, itemToEdit: item)
        }
    }
}

// Matrix Section Header (保持不变)
struct MatrixSectionHeader: View {
    let quadrant: EisenhowerQuadrant
    var body: some View {
        HStack {
            Spacer()
            Text(quadrant.rawValue)
                .font(.custom("Luckiest Guy", size: 24))
                .foregroundColor(.white)
                .shadow(color: quadrant.color.opacity(0.6), radius: 0, x: 2, y: 2)
                .padding(.vertical, 12)
            Spacer()
        }
        .background(quadrant.color)
        .overlay(Rectangle().frame(height: 3).foregroundColor(GameTheme.brown.opacity(0.3)), alignment: .bottom)
        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 3)
    }
}

// MARK: - Tab 3: Completed (保持不变)
struct CompletedListView: View {
    @ObservedObject var manager: TodoManager
    var completedItems: [TodoItem] {
        manager.items.filter { $0.isCompleted }
            .sorted { ($0.completedAt ?? Date()) > ($1.completedAt ?? Date()) }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                if completedItems.isEmpty {
                    EmptyStateView(message: "No completed quests yet!")
                }
                ForEach(completedItems) { item in
                    // 已完成列表也可以保持卡片样式
                    TodoCard(item: item) {
                        manager.toggleStatus(for: item)
                    }
                    .opacity(0.8)
                    .saturation(0.8)
                }
            }
            .padding(.horizontal, 25)
            .padding(.top, 15)
            .padding(.bottom, 20)
        }
        .background(GameTheme.background)
    }
}

// Helper (保持不变)
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
