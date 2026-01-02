import SwiftUI

// MARK: - Tab 1: Active List
struct TodoListView: View {
    @ObservedObject var manager: TodoManager
    // 👇 修改：改为 Binding，接收 ContentView 的状态
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
                            ForEach(activeItems) { item in
                                TodoCard(
                                    item: item,
                                    isCardStyle: false,
                                    onToggle: { manager.toggleStatus(for: item) }
                                )
                                .background(GameTheme.cream)
                                .onTapGesture {
                                    // 👇 触发：设置 Binding，通知 ContentView 弹窗
                                    withAnimation {
                                        itemToEdit = item
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .background(GameTheme.cream)
        // ❌ 删除：.sheet(item: $itemToEdit) ...
    }
}

// List Header (Quest Log - 保持木纹色)
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
    // 👇 修改：改为 Binding
    @Binding var itemToEdit: TodoItem?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                ForEach(EisenhowerQuadrant.allCases, id: \.self) { quadrant in
                    // 1. 筛选
                    let baseItems = manager.items.filter { !$0.isCompleted && $0.quadrant == quadrant }
                    
                    // 2. 排序
                    let items: [TodoItem] = {
                        switch sortOption {
                        case .creationDate:
                            return baseItems.sorted { $0.createdAt > $1.createdAt }
                        case .deadline:
                            return baseItems.sorted { $0.deadline < $1.deadline }
                        case .title:
                            return baseItems.sorted { $0.title.localizedStandardCompare($1.title) == .orderedAscending }
                        }
                    }()
                    
                    Section(header: MatrixSectionHeader(quadrant: quadrant)) {
                        VStack(spacing: 0) {
                            if items.isEmpty {
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
                                    TodoCard(
                                        item: item,
                                        isCardStyle: false,
                                        showSeparator: index < items.count - 1,
                                        onToggle: { manager.toggleStatus(for: item) }
                                    )
                                    .background(GameTheme.cream)
                                    .onTapGesture {
                                        // 👇 触发
                                        withAnimation {
                                            itemToEdit = item
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 0)
                        .padding(.bottom, 6)
                    }
                }
            }
            .background(GameTheme.cream)
        }
        .background(GameTheme.cream)
        // ❌ 删除：.sheet
    }
}

// Matrix Section Header
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
    // 👇 修改：改为 Binding
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
                                TodoCard(
                                    item: item,
                                    isCardStyle: false,
                                    showSeparator: true,
                                    onToggle: { manager.toggleStatus(for: item) }
                                )
                                .background(GameTheme.cream)
                                .opacity(0.8)
                                .saturation(0.8)
                                .onTapGesture {
                                    // 👇 触发
                                    withAnimation {
                                        itemToEdit = item
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .background(GameTheme.cream)
        // ❌ 删除：.sheet
    }
}

// Completed List Header
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


