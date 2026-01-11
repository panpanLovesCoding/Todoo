import SwiftUI

// ❌ 已删除：enum SortOption 定义移到了 TodoManager.swift，避免重复

struct TopBarView: View {
    @ObservedObject var manager: TodoManager
    @Binding var showSettings: Bool
    @Binding var showAddSheet: Bool
    
    // 🆕 新增：排序弹窗开关
    @Binding var showSortPopup: Bool
    
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
                HStack(spacing: 8) {
                    StatusCounter(icon: "list.bullet", color: GameTheme.yellow, value: totalActive)
                    StatusCounter(icon: "exclamationmark.2", color: GameTheme.red, value: urgentImportant)
                    StatusCounter(icon: "checkmark", color: GameTheme.green, value: totalDone)
                }
                
                Spacer()
                
                // 右侧：功能按键组
                HStack(spacing: 10) {
                    
                    // 1. Add Button
                    TopBarButton(icon: "plus", color: GameTheme.green) {
                        // ✨ 1. 播放指定的可爱气泡音效
                        SoundManager.shared.playSound(sound: "cassette_click_sound_1", type: "mp3", volume : 0.5)
                        
                        // 👇 确保这里有 withAnimation
                        withAnimation(.spring()) {
                            showAddSheet = true
                        }
                        
                    }
                    
                    // 2. Sort Button (👇 修改：改为点击触发 showSortPopup)
                    Button(action: {
                        // ✨ 1. 播放指定的可爱气泡音效
                        SoundManager.shared.playSound(sound: "cassette_click_sound_1", type: "mp3", volume : 0.5)
                        
                        withAnimation {
                            showSortPopup = true
                        }
                    }) {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(.white)
                            .frame(width: 38, height: 38)
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10).fill(GameTheme.orange)
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.6), lineWidth: 3)
                                        .padding(1)
                                }
                            )
                            .shadow(color: .black.opacity(0.4), radius: 2, y: 2)
                    }
                    
                    // 3. Settings Button
                    TopBarButton(icon: "gearshape.fill", color: GameTheme.blue) {
                        // ✨ 1. 播放指定的可爱气泡音效
                        SoundManager.shared.playSound(sound: "cassette_click_sound_1", type: "mp3", volume : 0.5)
                        
                        // 👇 修复：必须加上 withAnimation，否则ContentView里的 transition 不会触发
                        withAnimation(.spring()) {
                            showSettings = true
                        }
                    }
                }
            }
            // 边距
            .padding(.horizontal, 25)
            .padding(.top, 60)
            
            // MARK: - 第二行：App 标题
            Text("TO-DO QUEST")
                .font(.custom("Luckiest Guy", size: 40))
                .foregroundColor(GameTheme.cream)
                .shadow(color: GameTheme.brown, radius: 0, x: 4, y: 4)
                .padding(.bottom, 10)
                .padding(.top, 10)
        }
        .background(
            Color(red: 0.25, green: 0.15, blue: 0.05)
                .ignoresSafeArea()
        )
    }
}

// (StatusCounter 和 TopBarButton 保持不变...)
struct StatusCounter: View {
    let icon: String
    let color: Color
    let value: Int
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text("\(value)")
                .font(.system(size: 12, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .padding(.leading, 36)
                .padding(.trailing, 10)
                .padding(.vertical, 4)
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
                    .frame(width: 28, height: 28)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .shadow(radius: 2, y: 2)
                
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .black))
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
                .font(.system(size: 16, weight: .black))
                .foregroundColor(.white)
                .frame(width: 38, height: 38)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).fill(color)
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.6), lineWidth: 3)
                            .padding(1)
                    }
                )
                .shadow(color: .black.opacity(0.4), radius: 2, y: 2)
        }
    }
}
