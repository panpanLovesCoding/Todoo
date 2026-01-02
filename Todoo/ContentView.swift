import SwiftUI

struct ContentView: View {
    @StateObject var manager = TodoManager()
    @State private var showingAddSheet = false
    @State private var showingSettings = false
    @State private var selectedTab = 0
    
    // 🆕 新增：将编辑状态提升到此处管理
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
                    showAddSheet: $showingAddSheet, // 新建任务的开关
                    sortOption: $sortOption
                )
                
                // 2. 内容区
                TabView(selection: $selectedTab) {
                    // 👇 修改：传入 editingItem 的 Binding
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
                    .onTapGesture { showingSettings = false }
                    .zIndex(99)
                
                SettingsView(isPresented: $showingSettings)
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(100)
            }
            
            // 5. 新建任务弹窗
            if showingAddSheet {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { showingAddSheet = false }
                    .zIndex(101)
                
                AddEditView(manager: manager, itemToEdit: nil, isPresented: $showingAddSheet)
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(102)
            }
            
            // 🆕 6. 编辑任务弹窗 (修改为 Overlay 方式)
            if let item = editingItem {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { editingItem = nil } // 点击背景关闭
                    .zIndex(103)
                
                AddEditView(
                    manager: manager,
                    itemToEdit: item,
                    // 创建一个临时的 Binding 来控制关闭
                    isPresented: Binding(
                        get: { editingItem != nil },
                        set: { if !$0 { editingItem = nil } }
                    )
                )
                .transition(.scale.combined(with: .opacity))
                .zIndex(104)
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
