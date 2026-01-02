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
    
    // 状态 1: 刚刚勾选 (从无到有)
    @State private var justChecked = false
    // 🆕 状态 2: 正在取消勾选 (从有到无)
    @State private var isUnchecking = false
    
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
                        // 显示条件：(任务是完成状态 OR 刚刚勾选) AND (不在取消勾选的过程中)
                        if (item.isCompleted || justChecked) && !isUnchecking {
                            Image(systemName: "checkmark")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(GameTheme.green)
                                // 动画：缩放+透明度 (出现和消失都会有这个效果)
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
                        // 删除线逻辑：(已完成 OR 刚勾选) AND (没在取消)
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
    
    // 逻辑处理函数
    func handleToggle() {
        if !item.isCompleted {
            // [动作：去完成]
            // 1. 立即显示绿勾
            withAnimation(.spring()) {
                justChecked = true
            }
            // 2. 延迟执行数据更新
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                onToggle()
                justChecked = false
            }
        } else {
            // [动作：取消完成/倒放]
            // 1. 立即触发“取消中”动画 -> 绿勾会消失
            withAnimation(.spring()) {
                isUnchecking = true
            }
            // 2. 延迟执行数据更新 (让绿勾消失动画播放完)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                onToggle()
                // 重置状态
                isUnchecking = false
            }
        }
    }
}
