import SwiftUI

#Preview{
    ContentView()
}
          
struct ContentView: View {
    @StateObject var manager = TodoManager()
    @State private var showingAddSheet = false
    @State private var showingSettings = false
    @State private var selectedTab = 0
    
    // 新增：保存排序状态，默认按创建时间
    @State private var sortOption: SortOption = .creationDate
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.clear
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
    }

    var body: some View {
        ZStack {
            // 背景色
            GameTheme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. 顶部栏 (传入 sortOption 的绑定 $sortOption)
                TopBarView(
                    manager: manager,
                    showSettings: $showingSettings,
                    showAddSheet: $showingAddSheet,
                    sortOption: $sortOption
                )
                
                // 2. 主要内容区
                TabView(selection: $selectedTab) {
                    // 传入 sortOption 的值 (不需要绑定，只需要读取)
                    TodoListView(manager: manager, sortOption: sortOption)
                        .tag(0)
                    
                    EisenhowerMatrixView(manager: manager)
                        .tag(1)
                    
                    CompletedListView(manager: manager)
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // 3. 底部 TabBar
                VStack(spacing: 0) {
                    Divider()
                        .background(GameTheme.brown)
                        .scaleEffect(y: 4)
                    
                    HStack {
                        TabButton(icon: "list.bullet.clipboard", text: LanguageManager.shared.localized("Tasks"), isSelected: selectedTab == 0) { selectedTab = 0 }
                        Spacer()
                        TabButton(icon: "square.grid.2x2", text: LanguageManager.shared.localized("Matrix"), isSelected: selectedTab == 1) { selectedTab = 1 }
                        Spacer()
                        TabButton(icon: "checkmark.seal.fill", text: LanguageManager.shared.localized("Done"), isSelected: selectedTab == 2) { selectedTab = 2 }
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 5)
                }
                .background(GameTheme.cream.ignoresSafeArea(edges: .bottom))
            }
            .ignoresSafeArea(.all, edges: .top)
            
            // 4. 设置弹窗
            if showingSettings {
                SettingsView(isPresented: $showingSettings)
                    .transition(.opacity.combined(with: .scale(scale: 0.8)))
                    .zIndex(100)
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddEditView(manager: manager, itemToEdit: nil)
        }
    }
}

// (TabButton 保持不变)
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
            .foregroundColor(isSelected ? GameTheme.brown : GameTheme.brown.opacity(0.5))
            .scaleEffect(isSelected ? 1.1 : 1.0)
            .animation(.spring(), value: isSelected)
        }
    }
}
