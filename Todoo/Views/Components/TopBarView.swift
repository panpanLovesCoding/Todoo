import SwiftUI

// 1. 定义排序选项 (全局可用)
enum SortOption: String, CaseIterable {
    case creationDate = "Created Time"
    case deadline = "Due Date"
    case title = "Task Name"
}

struct TopBarView: View {
    @ObservedObject var manager: TodoManager
    @Binding var showSettings: Bool
    @Binding var showAddSheet: Bool
    
    // 2. 新增：绑定排序选项
    @Binding var sortOption: SortOption
    
    @ObservedObject var lang = LanguageManager.shared
    
    // 统计数据
    var totalActive: Int { manager.items.filter { !$0.isCompleted }.count }
    var urgentImportant: Int { manager.items.filter { !$0.isCompleted && $0.isUrgent && $0.isImportant }.count }
    var totalDone: Int { manager.items.filter { $0.isCompleted }.count }
    
    var body: some View {
        VStack(spacing: 10) {
            
            // MARK: - 第一行：资源计数器 和 功能按钮
            HStack(alignment: .center) {
                
                // 左侧：状态计数器
                HStack(spacing: 12) {
                    StatusCounter(icon: "list.bullet", color: GameTheme.yellow, value: totalActive)
                    StatusCounter(icon: "exclamationmark.2", color: GameTheme.red, value: urgentImportant)
                    StatusCounter(icon: "checkmark", color: GameTheme.green, value: totalDone)
                }
                
                Spacer()
                
                // 右侧：功能按键组
                HStack(spacing: 15) {
                    
                    // 1. Add Button (最左)
                    TopBarButton(icon: "plus", color: GameTheme.green) {
                        showAddSheet = true
                    }
                    
                    // 2. Sort Button (中间) - 这是一个菜单按钮
                    Menu {
                        Picker("Sort By", selection: $sortOption) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        // 使用跟 TopBarButton 一模一样的样式
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12).fill(GameTheme.orange) // 使用橙色区分
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.6), lineWidth: 3)
                                        .padding(1)
                                }
                            )
                            .shadow(color: .black.opacity(0.4), radius: 3, y: 3)
                    }
                    
                    // 3. Settings Button (最右)
                    TopBarButton(icon: "gearshape.fill", color: GameTheme.blue) {
                        showSettings = true
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 60)
            
            // MARK: - 第二行：App 标题
            Text("TO-DO QUEST")
                .font(.custom("Luckiest Guy", size: 40))
                .foregroundColor(GameTheme.cream)
                .shadow(color: GameTheme.brown, radius: 0, x: 4, y: 4)
                .padding(.bottom, 10)
                .padding(.top, 20)
        }
        .background(
            Color(red: 0.25, green: 0.15, blue: 0.05) // 深褐色木纹背景
                .ignoresSafeArea()
        )
    }
}

// (下面的 StatusCounter 和 TopBarButton 保持不变)
struct StatusCounter: View {
    let icon: String
    let color: Color
    let value: Int
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text("\(value)")
                .font(.system(size: 14, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .padding(.leading, 42)
                .padding(.trailing, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.black.opacity(0.5))
                        .overlay(
                            Capsule().stroke(Color(red: 0.2, green: 0.1, blue: 0.05), lineWidth: 2)
                        )
                )
                .fixedSize(horizontal: true, vertical: false)
            
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .shadow(radius: 2, y: 2)
                
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(GameTheme.brown)
            }
        }
    }
}

struct TopBarButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .black))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 12).fill(color)
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.6), lineWidth: 3)
                            .padding(1)
                    }
                )
                .shadow(color: .black.opacity(0.4), radius: 3, y: 3)
        }
    }
}
