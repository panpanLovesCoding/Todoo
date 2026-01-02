import SwiftUI

#Preview {
    ContentView()
}

// 1. The Card Style (unchanged)
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

// 2. The 3D Button Style (unchanged)
struct GameButtonStyle: ButtonStyle {
    var color: Color = GameTheme.yellow // 默认颜色
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // 1. 字体设置
            .font(.custom("Luckiest Guy", size: 28))
            //.font(.system(.headline, design: .rounded).weight(.heavy))
            .foregroundColor(GameTheme.brown)
            
            // 2. 按钮内边距 (控制按钮的大小/胖瘦)
            .padding(.vertical, 12)    // 上下高度：数字越大，按钮越高
            .padding(.horizontal, 24)  // 左右宽度：数字越大，按钮越宽
            
            .background(
                ZStack {
                    // 3. 3D 阴影层 (按钮的"厚度")
                    RoundedRectangle(cornerRadius: 15) // 圆角 A
                        .fill(color.opacity(0.6))      // 阴影颜色
                        .offset(y: 6)                  // ⬇️ 关键参数：垂直偏移量。数字越大，按钮看起来越"厚"
                    
                    // 4. 按钮顶层 (实际按下去的那一面)
                    RoundedRectangle(cornerRadius: 15) // 圆角 B (必须和圆角 A 一样)
                        // 下面这行实现了按下去变暗的效果
                        .fill(configuration.isPressed ? color.opacity(0.8) : color)
                }
            )
            .overlay(
                // 5. 描边 (黑框)
                RoundedRectangle(cornerRadius: 15) // 圆角 C (必须和圆角 A、B 一样)
                    .stroke(GameTheme.brown, lineWidth: 3) // ⬇️ 关键参数：边框粗细。数字越大，边框越粗
            )
            // 6. 按下缩放动画
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // 按下时缩小到 95%
    }
}

// 3. The Todo List Cell (Updated for Timestamps & Date format)
struct TodoCard: View {
    let item: TodoItem
    let onToggle: () -> Void
    
    // Helper date formatter for short dates
    private var shortDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Button(action: onToggle) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(item.isCompleted ? GameTheme.green : Color.white)
                        .frame(width: 32, height: 32)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(GameTheme.brown, lineWidth: 3))
                    
                    if item.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.top, 4)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.system(.title3, design: .rounded).weight(.heavy))
                    .strikethrough(item.isCompleted)
                    .foregroundColor(GameTheme.brown)
                    .fixedSize(horizontal: false, vertical: true)
                
                // NEW: Timestamps logic
                Group {
                    if item.isCompleted, let doneTime = item.completedAt {
                        Text("Done: \(doneTime.formatted(date: .abbreviated, time: .shortened))")
                    } else {
                        Text("Created: \(item.createdAt.formatted(date: .abbreviated, time: .shortened))")
                    }
                }
                .font(.system(size: 11, design: .rounded).weight(.medium))
                .foregroundColor(GameTheme.brown.opacity(0.7))

                Divider().background(GameTheme.brown.opacity(0.3))

                HStack {
                    // Changed: Only display DATE for deadline
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
        .modifier(GamePanelStyle())
    }
}
