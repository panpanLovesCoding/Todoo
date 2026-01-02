import SwiftUI

struct GameTheme {
    // MARK: - 🪵 基础色板 (保持兼容)
    // 这些是你原来的颜色，保留它们以防其他代码报错
    static let brown = Color(red: 0.35, green: 0.20, blue: 0.05)
    static let cream = Color(red: 1.0, green: 0.98, blue: 0.90)
    static let background = Color(red: 0.45, green: 0.75, blue: 0.35)
    
    // 下面这几个也可以保留作为“默认值”
    static let red = Color(red: 1.0, green: 0.40, blue: 0.40)
    static let yellow = Color(red: 1.0, green: 0.85, blue: 0.30)
    static let blue = Color(red: 0.30, green: 0.70, blue: 1.0)
    static let green = Color(red: 0.60, green: 0.85, blue: 0.30)
    static let orange = Color(red: 1.0, green: 0.60, blue: 0.20)

    // MARK: - 🎨 扩展色板 (Extended Palette)

    // 🔴 红色系 (Reds) - 适合：生命值、紧急、攻击、错误
    static let roseRed = Color(red: 1.0, green: 0.65, blue: 0.65) // 玫瑰红：柔和，适合次要警告或背景
    static let coral = Color(red: 1.0, green: 0.45, blue: 0.35)   // 珊瑚红：活泼，适合按钮
    static let crimson = Color(red: 0.75, green: 0.10, blue: 0.10)// 猩红/深红：极度紧急，Boss 战，删除
    
    // 🟡 黄色系 (Yellows) - 适合：金币、星星、高亮、普通提示
    static let lemon = Color(red: 1.0, green: 0.95, blue: 0.50)   // 柠檬黄：明亮，适合高亮文字背景
    static let gold = Color(red: 1.0, green: 0.80, blue: 0.00)    // 金色：经典的金币颜色，奖励
    static let amber = Color(red: 1.0, green: 0.70, blue: 0.10)   // 琥珀色：深黄偏橙，更有质感，适合图标
    
    // 🔵 蓝色系 (Blues) - 适合：魔法、蓝钻、冷静、普通状态
    static let skyBlue = Color(red: 0.50, green: 0.85, blue: 1.0) // 天蓝：清新，适合轻量级任务
    static let azure = Color(red: 0.00, green: 0.50, blue: 1.00)  // 蔚蓝：标准的 RPG 魔法蓝
    static let navy = Color(red: 0.10, green: 0.10, blue: 0.35)   // 海军蓝/夜空：深沉，适合深色背景或文字
    
    // 🟢 绿色系 (Greens) - 适合：成功、恢复、自然、安全
    static let mint = Color(red: 0.60, green: 1.00, blue: 0.70)   // 薄荷绿：非常清新，适合“轻松”标签
    static let emerald = Color(red: 0.20, green: 0.75, blue: 0.45)// 祖母绿：宝石质感，适合“完成”按钮
    static let forest = Color(red: 0.15, green: 0.40, blue: 0.20) // 森林绿：深邃自然，适合边框或深色底
    
    // 🟠 橙色系 (Oranges) - 适合：活力、第二警告、经验值
    static let peach = Color(red: 1.0, green: 0.80, blue: 0.60)   // 桃色/肉色：皮肤感，柔和
    static let pumpkin = Color(red: 1.0, green: 0.55, blue: 0.15) // 南瓜橙：万圣节风格，非常显眼
    static let rust = Color(red: 0.75, green: 0.35, blue: 0.10)   // 铁锈色：旧金属感，适合复古 UI
    
    // ⚫️ 灰色系 (Grays) - 适合：石头、金属、禁用状态、阴影
    static let silver = Color(red: 0.85, green: 0.85, blue: 0.90) // 银色：明亮的金属，适合边框高光
    static let stone = Color(red: 0.60, green: 0.63, blue: 0.65)  // 石头灰：完美的“未激活”或“禁用”颜色
    static let charcoal = Color(red: 0.25, green: 0.25, blue: 0.30)// 炭灰/黑曜石：接近黑色但带有冷色调，适合正文文字
    
    // MARK: - Constants
    static let cornerRadius: CGFloat = 20
    static let borderWidth: CGFloat = 4
}
