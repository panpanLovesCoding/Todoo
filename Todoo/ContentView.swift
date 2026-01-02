import SwiftUI

struct ContentView: View {
    @StateObject var manager = TodoManager()
    @State private var showingAddSheet = false
    @State private var showingSettings = false
    @State private var showingSortPopup = false
    
    @State private var selectedTab = 0
    @State private var editingItem: TodoItem? = nil
    
    // 🆕 修改 1：拆分排序状态，每个页面独立管理
    @State private var tasksSort: SortOption = .creationDate
    @State private var matrixSort: SortOption = .creationDate
    @State private var completedSort: SortOption = .creationDate
    
    // 🆕 修改 2：创建一个动态 Binding，根据当前 Tab 返回对应的排序状态
    // 这样 TopBarView 不需要改代码，它会自动操作当前页面的排序变量
    var currentSortBinding: Binding<SortOption> {
        Binding(
            get: {
                switch selectedTab {
                case 0: return tasksSort
                case 1: return matrixSort
                default: return completedSort
                }
            },
            set: { newValue in
                switch selectedTab {
                case 0: tasksSort = newValue
                case 1: matrixSort = newValue
                default: completedSort = newValue
                }
            }
        )
    }
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.clear
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
    }

    var body: some View {
        ZStack {
            GameTheme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. 顶部栏
                TopBarView(
                    manager: manager,
                    showSettings: $showingSettings,
                    showAddSheet: $showingAddSheet,
                    showSortPopup: $showingSortPopup,
                    // 👇 传入动态 Binding
                    sortOption: currentSortBinding
                )
                
                // 2. 内容区
                TabView(selection: $selectedTab) {
                    // 👇 Tab 0: 传入 tasksSort
                    TodoListView(manager: manager, itemToEdit: $editingItem, sortOption: tasksSort)
                        .tag(0)
                    
                    // 👇 Tab 1: 传入 matrixSort
                    EisenhowerMatrixView(manager: manager, sortOption: matrixSort, itemToEdit: $editingItem)
                        .tag(1)
                    
                    // 👇 Tab 2: 传入 completedSort (需要修改 CompletedListView 支持此参数)
                    CompletedListView(manager: manager, itemToEdit: $editingItem, sortOption: completedSort)
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // 3. 底部 TabBar (保持不变)
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
            
            // 4. 设置弹窗
            if showingSettings {
                // 这一层负责背景变暗，和 SettingsView 分离
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                         withAnimation(.spring()) {
                             showingSettings = false
                         }
                    }
                    .zIndex(99)
                
                // 这一层负责卡片弹窗
                SettingsView(isPresented: $showingSettings, manager: manager) // 👈 记得加上 manager
                    .transition(.scale.combined(with: .opacity)) // 现在它只作用于那个小卡片了
                    .zIndex(100)
            }
            
            if showingAddSheet {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation(.spring()) { showingAddSheet = false } }
                    .zIndex(101)
                
                AddEditView(manager: manager, itemToEdit: nil, isPresented: $showingAddSheet)
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(102)
            }

            if let item = editingItem {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
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
                .transition(.scale.combined(with: .opacity))
                .zIndex(104)
            }
            
            // 🆕 排序弹窗：传入动态 binding
            if showingSortPopup {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { showingSortPopup = false }
                    .zIndex(105)
                
                SortPopupView(isPresented: $showingSortPopup, currentSort: currentSortBinding)
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
