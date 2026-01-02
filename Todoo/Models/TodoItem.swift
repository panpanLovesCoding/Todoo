import SwiftUI

// 👇 修改：添加 Equatable 协议
struct TodoItem: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var createdAt: Date = Date()
    var deadline: Date = Date()
    var completedAt: Date? = nil
    
    // Matrix 属性
    var isUrgent: Bool = false
    var isImportant: Bool = false
    
    // 计算属性不需要参与 Equatable 的合成，Swift 会自动处理存储属性
    var quadrant: EisenhowerQuadrant {
        switch (isUrgent, isImportant) {
        case (true, true): return .doNow
        case (false, true): return .plan
        case (true, false): return .delegate
        case (false, false): return .eliminate
        }
    }
    
    // 👇 手动实现 Equatable (可选)，但通常不需要，
    // 只要上面加了 Equatable，Swift 就会自动对比所有存储属性。
    // 如果你以后添加了无法自动比较的属性，才需要手动实现。
}

enum EisenhowerQuadrant: String, CaseIterable, Codable {
    case doNow = "DO NOW"
    case plan = "PLAN"
    case delegate = "DELEGATE"
    case eliminate = "LATER"
    
    var color: Color {
        switch self {
        case .doNow: return GameTheme.crimson
        case .plan: return GameTheme.azure
        case .delegate: return GameTheme.amber
        // 👇 修复：把 GameTheme.gray 改成 Color.gray (系统自带灰色)
        case .eliminate: return GameTheme.stone
        }
    }
}
