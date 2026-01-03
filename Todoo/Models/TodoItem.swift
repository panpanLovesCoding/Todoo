import SwiftUI

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
    
    // 计算属性：决定象限
    var quadrant: EisenhowerQuadrant {
        switch (isUrgent, isImportant) {
        case (true, true): return .doNow
        case (false, true): return .plan
        case (true, false): return .delegate
        // 👇 修改：这里改成 .later
        case (false, false): return .later
        }
    }
}

enum EisenhowerQuadrant: String, CaseIterable, Codable {
    case doNow = "DO NOW"
    case plan = "PLAN"
    case delegate = "DELEGATE"
    // 👇 修改：将 eliminate 改名为 later，rawValue 保持 "LATER"
    case later = "LATER"
    
    var color: Color {
        switch self {
        case .doNow: return GameTheme.crimson
        case .plan: return GameTheme.azure
        case .delegate: return GameTheme.amber
        // 👇 修改：这里改成 .later
        case .later: return GameTheme.stone
        }
    }
}
