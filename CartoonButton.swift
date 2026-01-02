import SwiftUI

struct CartoonButton: View {
    var body: some View {
        ZStack {
            // 背景颜色（为了看清按钮效果）
            Color(red: 0.95, green: 0.9, blue: 0.8)
                .edgesIgnoringSafeArea(.all)
            
            // 按钮本体
            Button(action: {
                print("Help/FAQ Tapped")
            }) {
                CartoonButtonLabel(text: "HELP/FAQ")
            }
        }
    }
}

struct CartoonButtonLabel: View {
    var text: String
    
    // 定义颜色 (从图片中提取的近似色)
    let borderDarkBrown = Color(red: 0.25, green: 0.05, blue: 0.0) // 深棕色边框
    let gradientTop = Color(red: 1.0, green: 0.85, blue: 0.4)      // 顶部浅橙色
    let gradientBottom = Color(red: 0.9, green: 0.4, blue: 0.1)    // 底部深橙色
    
    var body: some View {
        ZStack {
            // 1. 最底层：深色边框 + 3D阴影层
            RoundedRectangle(cornerRadius: 16)
                .fill(borderDarkBrown)
                .frame(width: 200, height: 64)
                // 这一层稍微大一点，形成边框效果
            
            // 2. 中间层：主渐变按钮面
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [gradientTop, gradientBottom]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 192, height: 54)
                .overlay(
                    // 给橙色区域加一个极细的内高光，增加质感
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                )
                // 向上偏移，露出底部的深色，形成“按压”前的3D厚度
                .offset(y: -4)
            
            // 3. 顶层：描边文字
            OutlinedText(text: text)
                .offset(y: -4) // 文字跟随按钮面向上偏移
        }
    }
}

// 辅助视图：用于创建卡通描边文字
struct OutlinedText: View {
    var text: String
    
    var body: some View {
        ZStack {
            // 描边层 (通过多重阴影或叠加实现粗描边效果)
            // 这里为了简单且效果好，我们叠加几个偏移的黑色文字
            ForEach(0..<8) { i in
                Text(text)
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(red: 0.25, green: 0.05, blue: 0.0)) // 描边颜色
                    .offset(x: cos(Double(i) * .pi / 4) * 2,
                            y: sin(Double(i) * .pi / 4) * 2)
            }
            
            // 纯白文字层
            Text(text)
                .font(.system(size: 32, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    CartoonButton()
}
