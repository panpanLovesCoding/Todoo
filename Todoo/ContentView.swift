import SwiftUI

struct ContentView: View {
    @StateObject var manager = TodoManager()
    @State private var showingAddSheet = false
    @State private var showingSettings = false
    @State private var selectedTab = 0
    
    // 排序状态
    @State private var sortOption: SortOption = .creationDate
    
    init() {
        // 隐藏系统原生的 TabBar，因为我们要自定义
        UITabBar.appearance().backgroundColor = UIColor.clear
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
    }

    var body: some View {
        ZStack {
            // 背景色 (会被中间的内容遮挡，主要防止边缘漏光)
            GameTheme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. 顶部栏 (Top Bar)
                TopBarView(
                    manager: manager,
                    showSettings: $showingSettings,
                    showAddSheet: $showingAddSheet,
                    sortOption: $sortOption
                )
                
                // 2. 主要内容区 (TabView)
                TabView(selection: $selectedTab) {
                    TodoListView(manager: manager, sortOption: sortOption)
                        .tag(0)
                    
                    EisenhowerMatrixView(manager: manager)
                        .tag(1)
                    
                    CompletedListView(manager: manager)
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never)) // 滑动切换
                
                // 3. 底部自定义 TabBar
                VStack(spacing: 0) {
                    // 顶部分割线
                    Rectangle()
                        .frame(height: 4)
                        .foregroundColor(Color.black.opacity(0.3))
                    
                    HStack {
                        // 任务列表
                        TabButton(icon: "list.bullet.clipboard", text: LanguageManager.shared.localized("Tasks"), isSelected: selectedTab == 0) { selectedTab = 0 }
                        Spacer()
                        // 四象限
                        TabButton(icon: "square.grid.2x2", text: LanguageManager.shared.localized("Matrix"), isSelected: selectedTab == 1) { selectedTab = 1 }
                        Spacer()
                        // 已完成
                        TabButton(icon: "checkmark.seal.fill", text: LanguageManager.shared.localized("Done"), isSelected: selectedTab == 2) { selectedTab = 2 }
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 5)
                }
                // 背景色：深褐色 (与 Top Bar 保持一致)
                .background(
                    Color(red: 0.25, green: 0.15, blue: 0.05)
                        .ignoresSafeArea(edges: .bottom)
                )
            }
            .ignoresSafeArea(.all, edges: .top)
            
            // 4. 设置弹窗
            if showingSettings {
                SettingsView(isPresented: $showingSettings)
                    .transition(.opacity.combined(with: .scale(scale: 0.8)))
                    .zIndex(100)
            }
        }
        // 添加任务弹窗
        .sheet(isPresented: $showingAddSheet) {
            AddEditView(manager: manager, itemToEdit: nil)
        }
    }
}

// MARK: - 自定义 Tab 按钮组件
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
            // 颜色适配深色背景：选中为米色，未选中为半透明米色
            .foregroundColor(isSelected ? GameTheme.cream : GameTheme.cream.opacity(0.4))
            .scaleEffect(isSelected ? 1.1 : 1.0)
            .animation(.spring(), value: isSelected)
        }
    }
}

// MARK: - PREVIEW (预览功能)
#Preview {
    ContentView()
}
