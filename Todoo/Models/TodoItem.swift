import SwiftUI

struct TodoItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var createdAt: Date = Date()
    var deadline: Date = Date()
    var completedAt: Date? = nil
    
    // Matrix 属性
    var isUrgent: Bool = false
    var isImportant: Bool = false
    
    var quadrant: EisenhowerQuadrant {
        switch (isUrgent, isImportant) {
        case (true, true): return .doNow
        case (false, true): return .plan
        case (true, false): return .delegate
        case (false, false): return .eliminate
        }
    }
}

enum EisenhowerQuadrant: String, CaseIterable, Codable {
    case doNow = "DO NOW"
    case plan = "PLAN"
    case delegate = "DELEGATE"
    case eliminate = "LATER"
    
    var color: Color {
        switch self {
        case .doNow: return GameTheme.red
        case .plan: return GameTheme.blue
        case .delegate: return GameTheme.yellow
        // 👇 修复：把 GameTheme.gray 改成 Color.gray (系统自带灰色)
        case .eliminate: return Color.gray
        }
    }
}
