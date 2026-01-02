import SwiftUI

// MARK: - Tab 1: Active List (Minor layout tweak)
struct TodoListView: View {
    @ObservedObject var manager: TodoManager
    @State private var itemToEdit: TodoItem?
    
    var activeItems: [TodoItem] {
        manager.items.filter { !$0.isCompleted }
            .sorted { $0.createdAt > $1.createdAt } // Sort by newest first
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
            .padding()
            .padding(.bottom, 20)
        }
        .background(GameTheme.background)
        .sheet(item: $itemToEdit) { item in
            AddEditView(manager: manager, itemToEdit: item)
        }
    }
}

// MARK: - Tab 2: Matrix (MAJOR UI OVERHAUL)
struct EisenhowerMatrixView: View {
    @ObservedObject var manager: TodoManager
    let columns = [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(EisenhowerQuadrant.allCases, id: \.self) { quadrant in
                    QuadrantView(quadrant: quadrant, items: manager.items.filter { !$0.isCompleted && $0.quadrant == quadrant })
                }
            }
            .padding(15)
            .padding(.bottom, 20)
        }
        .background(GameTheme.background)
    }
}

// Redesigned to look like the game panels in references
struct QuadrantView: View {
    let quadrant: EisenhowerQuadrant
    let items: [TodoItem]
    
    var body: some View {
        VStack(spacing: 0) {
            // Banner Header
            Text(quadrant.rawValue)
                .font(.system(.headline, design: .rounded).weight(.heavy))
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(quadrant.color)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(GameTheme.brown, lineWidth: 3))
                )
                .foregroundColor(GameTheme.brown)
                .padding(.bottom, -15) // Overlap effect
                .zIndex(1)
            
            // List Container Panel
            ScrollView {
                VStack(spacing: 8) {
                    if items.isEmpty {
                        Text("Empty")
                            .font(.system(.caption, design: .rounded).weight(.bold))
                            .foregroundColor(GameTheme.brown.opacity(0.5))
                            .padding(.top, 20)
                    }
                    ForEach(items) { item in
                        HStack {
                            Text(item.title)
                                .font(.system(.caption, design: .rounded).weight(.bold))
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Label(item.deadline.formatted(date: .numeric, time: .omitted), systemImage: "calendar")
                                .font(.system(size: 9, design: .rounded))
                                .opacity(0.7)
                        }
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(GameTheme.brown, lineWidth: 2))
                        .foregroundColor(GameTheme.brown)
                    }
                }
                .padding(12)
                .padding(.top, 15) // Adjust for banner overlap
            }
            .frame(height: 180)
            .modifier(GamePanelStyle(cornerRadius: 15, border: 3))
        }
    }
}

// MARK: - Tab 3: Completed (Minor layout tweak)
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
            .padding()
            .padding(.bottom, 20)
        }
        .background(GameTheme.background)
    }
}

// Helper for empty states
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
