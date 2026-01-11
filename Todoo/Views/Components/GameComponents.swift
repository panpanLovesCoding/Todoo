import SwiftUI

// MARK: - 1. 通用面板样式
struct GamePanelStyle: ViewModifier {
    var color: Color = GameTheme.cream
    var cornerRadius: CGFloat = GameTheme.cornerRadius
    var border: CGFloat = GameTheme.borderWidth
    
    func body(content: Content) -> some View {
        content
            .background(color)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(GameTheme.brown, lineWidth: border)
            )
            .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 4)
    }
}

// MARK: - 2. 3D 按钮样式 (已更新慢速动画)
struct GameButtonStyle: ButtonStyle {
    var color: Color = GameTheme.yellow
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("Luckiest Guy", size: 20))
            .foregroundColor(GameTheme.brown)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(
                ZStack {
                    // 阴影底座
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.6))
                        .offset(y: 6)
                    
                    // 按钮本体
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color)
                    // 变暗层
                        .overlay(
                            Color.black
                                .opacity(configuration.isPressed ? 0.3 : 0)
                                .cornerRadius(12)
                        )
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(GameTheme.brown, lineWidth: 3)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        // 🆕 核心修改：时长加长到 0.4秒，使用 easeOut
            .animation(.easeOut(duration: 0.4), value: configuration.isPressed)
    }
}

// MARK: - 3. 任务卡片组件 (保持不变)
struct TodoCard: View {
    let item: TodoItem
    var isCardStyle: Bool = true
    var showSeparator: Bool = true
    let onToggle: () -> Void
    
    @State private var justChecked = false
    @State private var isUnchecking = false
    
    var isDueToday: Bool {
        Calendar.current.isDateInToday(item.deadline)
    }
    
    var isOverdue: Bool {
        Calendar.current.compare(item.deadline, to: Date(), toGranularity: .day) == .orderedAscending
    }
    
    func getDateColor() -> Color {
        if item.isCompleted {
            return GameTheme.brown
        } else if isOverdue {
            return Color.gray
        } else if isDueToday {
            return GameTheme.red
        } else {
            return GameTheme.brown
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                // 复选框
                Button(action: handleToggle) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .frame(width: 32, height: 32)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(GameTheme.brown, lineWidth: 3))
                        
                        if (item.isCompleted || justChecked) && !isUnchecking {
                            Image(systemName: "checkmark")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(GameTheme.green)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 4)
                
                // 文本区域
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title)
                        .font(.system(.title3, design: .rounded).weight(.heavy))
                        .strikethrough((item.isCompleted || justChecked) && !isUnchecking)
                        .foregroundColor(GameTheme.brown)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Group {
                        if item.isCompleted, let doneTime = item.completedAt {
                            Text("Done: \(doneTime.formatted(date: .abbreviated, time: .shortened))")
                        } else {
                            Text("Created: \(item.createdAt.formatted(date: .abbreviated, time: .shortened))")
                        }
                    }
                    .font(.system(size: 11, design: .rounded).weight(.medium))
                    .foregroundColor(GameTheme.brown.opacity(0.7))
                    
                    if isCardStyle {
                        Divider().background(GameTheme.brown.opacity(0.3))
                    }
                    
                    HStack {
                        Label("Due: \(item.deadline.formatted(date: .abbreviated, time: .omitted))", systemImage: "calendar")
                            .foregroundColor(getDateColor())
                        
                        Spacer()
                        if item.isUrgent { Text("🔥 Urgent") }
                        if item.isImportant { Text("⭐ Important") }
                    }
                    .font(.system(size: 11, design: .rounded).weight(.bold))
                    .foregroundColor(GameTheme.brown)
                }
                Spacer()
            }
            .padding(12)
            
            if !isCardStyle && showSeparator {
                Divider()
                    .background(GameTheme.brown.opacity(0.5))
            }
        }
        .background(isCardStyle ? GameTheme.cream : Color.clear)
        .cornerRadius(isCardStyle ? 20 : 0)
        .overlay(
            RoundedRectangle(cornerRadius: isCardStyle ? 20 : 0)
                .stroke(GameTheme.brown, lineWidth: isCardStyle ? GameTheme.borderWidth : 0)
        )
        .shadow(color: isCardStyle ? .black.opacity(0.3) : .clear, radius: 2, x: 2, y: 4)
    }
    
    func handleToggle() {
        if !item.isCompleted {
            // 1. 先播放完成时的 Click 音效
            SoundManager.shared.playSound(sound: "complete_click_sound_1", type: "mp3")
            
            // ✨ 2. 延迟 0.5 秒后，紧接着播放 Swoosh 音效
            // 这样能形成 "咔哒-嗖" 的连贯听感
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                SoundManager.shared.playSound(sound: "swoosh_sound_1", type: "mp3", volume: 1.5)
            }
            
            withAnimation(.spring()) {
                justChecked = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                onToggle()
                justChecked = false
            }
        } else {
            // 取消完成时的逻辑（如果需要也可以加声音）
            withAnimation(.spring()) {
                isUnchecking = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                onToggle()
                isUnchecking = false
            }
        }
    }
}
