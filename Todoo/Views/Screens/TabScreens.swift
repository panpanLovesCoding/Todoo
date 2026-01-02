import SwiftUI

// MARK: - Tab 1: Active List
struct TodoListView: View {
    @ObservedObject var manager: TodoManager
    @State private var itemToEdit: TodoItem?
    
    // 接收排序参数
    let sortOption: SortOption
    
    var activeItems: [TodoItem] {
        let filtered = manager.items.filter { !$0.isCompleted }
        
        switch sortOption {
        case .creationDate:
            return filtered.sorted { $0.createdAt > $1.createdAt }
        case .deadline:
            return filtered.sorted { $0.deadline < $1.deadline }
        case .title:
            return filtered.sorted { $0.title.localizedStandardCompare($1.title) == .orderedAscending }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                if activeItems.isEmpty {
                    EmptyStateView(message: "No active quests!")
                }
                
                ForEach(activeItems) { item in
                    TodoCard(item: item) {
                        manager.toggleStatus(for: item)
                    }
                    .onTapGesture { itemToEdit = item }
                }
            }
            // 👇 修改：明确设置左右间距为 25，确保不贴边
            .padding(.horizontal, 25)
            .padding(.top, 15)
            .padding(.bottom, 20)
        }
        .background(GameTheme.background)
        .sheet(item: $itemToEdit) { item in
            AddEditView(manager: manager, itemToEdit: item)
        }
    }
}

// MARK: - Tab 2: Matrix
struct EisenhowerMatrixView: View {
    @ObservedObject var manager: TodoManager
    @State private var itemToEdit: TodoItem?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                ForEach(EisenhowerQuadrant.allCases, id: \.self) { quadrant in
                    QuadrantView(
                        quadrant: quadrant,
                        items: manager.items.filter { !$0.isCompleted && $0.quadrant == quadrant },
                        onTap: { item in
                            itemToEdit = item
                        }
                    )
                }
            }
            // 👇 修改：这里也设置为 25，保持统一
            .padding(.horizontal, 25)
            .padding(.vertical, 20)
        }
        .background(GameTheme.background)
        .sheet(item: $itemToEdit) { item in
            AddEditView(manager: manager, itemToEdit: item)
        }
    }
}

// MARK: - Quadrant View (保持不变)
struct QuadrantView: View {
    let quadrant: EisenhowerQuadrant
    let items: [TodoItem]
    let onTap: (TodoItem) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 1. 标题区域
            ZStack {
                quadrant.color
                
                Text(quadrant.rawValue)
                    .font(.custom("Luckiest Guy", size: 26))
                    .foregroundColor(.white)
                    .shadow(color: quadrant.color.opacity(0.5), radius: 0, x: 2, y: 2)
                    .padding(.vertical, 12)
            }
            .frame(height: 55)
            
            // 2. 内容区域
            VStack(spacing: 8) {
                if items.isEmpty {
                    VStack {
                        Spacer()
                        Text("Empty")
                            .font(.system(.headline, design: .rounded).weight(.bold))
                            .foregroundColor(GameTheme.brown.opacity(0.4))
                        Spacer()
                    }
                    .frame(height: 120)
                } else {
                    ForEach(items) { item in
                        HStack(alignment: .top) {
                            Text(item.title)
                                .font(.system(.callout, design: .rounded).weight(.bold))
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                            Text(item.deadline.formatted(date: .numeric, time: .omitted))
                                .font(.system(size: 10, design: .rounded).weight(.medium))
                                .padding(.vertical, 2)
                                .padding(.horizontal, 6)
                                .background(GameTheme.brown.opacity(0.1))
                                .cornerRadius(4)
                        }
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(GameTheme.brown, lineWidth: 2))
                        .foregroundColor(GameTheme.brown)
                        .onTapGesture {
                            onTap(item)
                        }
                    }
                    .padding(.bottom, 4)
                }
            }
            .padding(12)
            .background(GameTheme.cream)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(GameTheme.brown, lineWidth: 4)
        )
        .shadow(color: GameTheme.brown.opacity(0.4), radius: 0, x: 0, y: 6)
    }
}

// MARK: - Tab 3: Completed
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
            // 👇 修改：同样设置左右间距 25
            .padding(.horizontal, 25)
            .padding(.top, 15)
            .padding(.bottom, 20)
        }
        .background(GameTheme.background)
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
