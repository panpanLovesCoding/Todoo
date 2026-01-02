import SwiftUI

struct ContentView: View {
    @StateObject var manager = TodoManager()
    @State private var showingAddSheet = false
    @State private var showingSettings = false
    // 🆕 新增：排序弹窗状态
    @State private var showingSortPopup = false
    
    @State private var selectedTab = 0
    @State private var editingItem: TodoItem? = nil
    
    // 排序状态
    @State private var sortOption: SortOption = .creationDate
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.clear
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
    }

    var body: some View {
        ZStack {
            // 背景
            GameTheme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. 顶部栏
                TopBarView(
                    manager: manager,
                    showSettings: $showingSettings,
                    showAddSheet: $showingAddSheet,
                    // 👇 传入排序弹窗状态
                    showSortPopup: $showingSortPopup,
                    sortOption: $sortOption
                )
                
                // 2. 内容区
                TabView(selection: $selectedTab) {
                    TodoListView(manager: manager, itemToEdit: $editingItem, sortOption: sortOption)
                        .tag(0)
                    
                    EisenhowerMatrixView(manager: manager, sortOption: sortOption, itemToEdit: $editingItem)
                        .tag(1)
                    
                    CompletedListView(manager: manager, itemToEdit: $editingItem)
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // 3. 底部 TabBar
                VStack(spacing: 0) {
                    Rectangle()
                        .frame(height: 4)
                        .foregroundColor(Color.black.opacity(0.3))
                    
                    HStack(spacing: 95) {
                        TabButton(icon: "list.bullet.clipboard", text: LanguageManager.shared.localized("Tasks"), isSelected: selectedTab == 0) { selectedTab = 0 }
                        
                        TabButton(icon: "square.grid.2x2", text: LanguageManager.shared.localized("Matrix"), isSelected: selectedTab == 1) { selectedTab = 1 }
                        
                        TabButton(icon: "checkmark.seal.fill", text: LanguageManager.shared.localized("Done"), isSelected: selectedTab == 2) { selectedTab = 2 }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity)
                }
                .background(
                    Color(red: 0.25, green: 0.15, blue: 0.05)
                        .ignoresSafeArea(edges: .bottom)
                )
            }
            .ignoresSafeArea(.all, edges: .top)
            
            // MARK: - 弹窗区域 (ZStack Overlay)
            
            // 4. 设置弹窗
            if showingSettings {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    // 👇 修复：点击背景关闭时也要加动画
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showingSettings = false
                        }
                    }
                    .zIndex(99)
                    .transition(.opacity) // 确保背景只做透明度渐变
                
                SettingsView(isPresented: $showingSettings)
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(100)
            }
            
            // 5. 新建任务弹窗
            if showingAddSheet {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    // 在点击背景关闭时，也使用动画
                    .onTapGesture { withAnimation(.spring()) { showingAddSheet = false } }
                    .zIndex(101)
                
                AddEditView(manager: manager, itemToEdit: nil, isPresented: $showingAddSheet)
                    // 👇 修改：添加 .transition(.scale)
                    .transition(.scale.combined(with: .opacity)) // 结合透明度过渡效果更好
                    .zIndex(102)
            }

            // 6. 编辑任务弹窗
            if let item = editingItem {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    // 在点击背景关闭时，也使用动画
                    .onTapGesture { withAnimation(.spring()) { editingItem = nil } }
                    .zIndex(103)
                
                AddEditView(
                    manager: manager,
                    itemToEdit: item,
                    isPresented: Binding(
                        get: { editingItem != nil },
                        set: { if !$0 { editingItem = nil } }
                    )
                )
                // 👇 修改：同样添加 .transition(.scale)
                .transition(.scale.combined(with: .opacity))
                .zIndex(104)
            }
            
            // 🆕 7. 排序弹窗
            if showingSortPopup {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { showingSortPopup = false }
                    .zIndex(105)
                
                SortPopupView(isPresented: $showingSortPopup, currentSort: $sortOption)
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(106)
            }
        }
    }
}

struct TabButton: View {
    let icon: String
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .bold))
                Text(text)
                    .font(.system(size: 10, design: .rounded).weight(.bold))
            }
            .foregroundColor(isSelected ? GameTheme.cream : GameTheme.cream.opacity(0.4))
            .scaleEffect(isSelected ? 1.1 : 1.0)
            .animation(.spring(), value: isSelected)
        }
    }
}

#Preview {
    ContentView()
}
