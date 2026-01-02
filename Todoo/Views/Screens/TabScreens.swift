import SwiftUI

// MARK: - Tab 1: Active List (修改版：边距 + 头部颜色)
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
            // 吸顶标题容器
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                
                Section(header: TodoListHeader()) {
                    
                    if activeItems.isEmpty {
                        VStack {
                            EmptyStateView(message: "No active quests!")
                        }
                        .padding(.top, 40)
                    } else {
                        // 任务列表
                        VStack(spacing: 0) {
                            ForEach(activeItems) { item in
                                TodoCard(
                                    item: item,
                                    isCardStyle: false, // 列表模式
                                    onToggle: { manager.toggleStatus(for: item) }
                                )
                                .background(GameTheme.cream)
                                .onTapGesture { itemToEdit = item }
                            }
                        }
                        // 👇 关键修改：加回左右边距，让任务条往中间靠，不贴边
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .background(GameTheme.cream)
        .sheet(item: $itemToEdit) { item in
            AddEditView(manager: manager, itemToEdit: item)
        }
    }
}

// MARK: - List Header (修改：颜色区分)
struct TodoListHeader: View {
    var body: some View {
        ZStack {
            // 👇 修改：背景色改浅一点，不再跟 Top Bar 一样深
            // 这里用稍微浅一点的木头色/红棕色
            Color(red: 0.5, green: 0.35, blue: 0.2)
            
            Text("QUEST LOG")
                .font(.custom("Luckiest Guy", size: 28))
                .foregroundColor(GameTheme.cream)
                .shadow(color: Color.black.opacity(0.3), radius: 0, x: 2, y: 2) // 加点文字阴影更清楚
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

// MARK: - Tab 2: Matrix (保持不变)
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

// Helper
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
