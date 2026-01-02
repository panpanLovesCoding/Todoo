import SwiftUI

struct ContentView: View {
    @StateObject var manager = TodoManager()
    @State private var showingAddSheet = false
    @State private var showingSettings = false
    @State private var selectedTab = 0
    
    @State private var sortOption: SortOption = .creationDate
    
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
                    sortOption: $sortOption
                )
                
                // 2. 内容区
                TabView(selection: $selectedTab) {
                    TodoListView(manager: manager, sortOption: sortOption)
                        .tag(0)
                    
                    // 👇 修改：传入 sortOption
                    EisenhowerMatrixView(manager: manager, sortOption: sortOption)
                        .tag(1)
                    
                    CompletedListView(manager: manager)
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // 3. 底部 TabBar
                VStack(spacing: 0) {
                    // 分割线
                    Rectangle()
                        .frame(height: 4)
                        .foregroundColor(Color.black.opacity(0.3))
                    
                    // 按钮组
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
