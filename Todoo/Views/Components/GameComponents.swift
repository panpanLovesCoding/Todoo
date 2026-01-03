import SwiftUI

// MARK: - 1. 通用面板样式 (保持不变)
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

// MARK: - 2. 3D 按钮样式 (保持不变)
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
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.6))
                        .offset(y: 6)
                    RoundedRectangle(cornerRadius: 12)
                        .fill(configuration.isPressed ? color.opacity(0.8) : color)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(GameTheme.brown, lineWidth: 3)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

// MARK: - 3. 任务卡片组件 (更新逻辑)
struct TodoCard: View {
    let item: TodoItem
    var isCardStyle: Bool = true
    var showSeparator: Bool = true
    let onToggle: () -> Void
    
    // 状态
    @State private var justChecked = false
    @State private var isUnchecking = false
    
    // 判断是否是今天
    var isDueToday: Bool {
        Calendar.current.isDateInToday(item.deadline)
    }
    
    // 🆕 新增：判断是否过期 (截止日期在今天之前)
    var isOverdue: Bool {
        // 比较 deadline 和 当前时间(Date())，粒度为“天”
        // orderedAscending 意味着 deadline < today (即过去)
        Calendar.current.compare(item.deadline, to: Date(), toGranularity: .day) == .orderedAscending
    }
    
    // 🆕 辅助函数：获取日期颜色
    func getDateColor() -> Color {
        if item.isCompleted {
            return GameTheme.brown // 已完成：保持棕色
        } else if isOverdue {
            return Color.gray      // 已过期：显示灰色
        } else if isDueToday {
            return GameTheme.red   // 今天：显示红色
        } else {
            return GameTheme.brown // 未来：显示棕色
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                // 复选框
                Button(action: handleToggle) {
                    ZStack {
                        // 白方块背景
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .frame(width: 32, height: 32)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(GameTheme.brown, lineWidth: 3))
                        
                        // 绿勾
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
                        // 🆕 应用颜色逻辑
                        Label("Due: \(item.deadline.formatted(date: .abbreviated, time: .omitted))", systemImage: "calendar")
                            .foregroundColor(getDateColor()) // 使用上面的函数
                        
                        Spacer()
                        if item.isUrgent { Text("🔥 Urgent") }
                        if item.isImportant { Text("⭐ Important") }
                    }
                    .font(.system(size: 11, design: .rounded).weight(.bold))
                    // 这里原本是统一设置颜色，现在 label 颜色会覆盖，右边的 urgent/important 继承这里的棕色
                    .foregroundColor(GameTheme.brown)
                }
                Spacer()
            }
            .padding(12)
            
            // 底部分割线
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
    
    // 逻辑处理函数 (保持不变)
    func handleToggle() {
        if !item.isCompleted {
            withAnimation(.spring()) {
                justChecked = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                onToggle()
                justChecked = false
            }
        } else {
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
