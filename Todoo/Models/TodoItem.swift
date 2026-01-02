import SwiftUI

enum EisenhowerQuadrant: String, CaseIterable, Codable {
    case doNow = "DO NOW"
    case schedule = "PLAN"
    case delegate = "DELEGATE"
    case later = "LATER" // ✅ 已修正：改为 later
    
    // 修改：去掉了透明度，改为实心颜色
    var color: Color {
        switch self {
        case .doNow: return GameTheme.red
        case .schedule: return GameTheme.blue
        case .delegate: return GameTheme.yellow
        case .later: return Color.gray // ✅ 已修正：这里也需要改成 .later
        }
    }
}

struct TodoItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var deadline: Date
    var isImportant: Bool
    var isUrgent: Bool
    var isCompleted: Bool = false
    
    // NEW: Timestamps
    var createdAt: Date = Date()
    var completedAt: Date? = nil
    
    var quadrant: EisenhowerQuadrant {
        switch (isImportant, isUrgent) {
        case (true, true): return .doNow
        case (true, false): return .schedule
        case (false, true): return .delegate
        case (false, false): return .later // ✅ 已修正：这里同步改为 .later
        }
    }
}
