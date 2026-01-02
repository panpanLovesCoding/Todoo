import SwiftUI

enum EisenhowerQuadrant: String, CaseIterable, Codable {
    case doNow = "DO NOW"
    case schedule = "PLAN"
    case delegate = "DELEGATE"
    case later = "LATER"
    
    // Slightly adjusted colors for better UI contrast in the new design
    var color: Color {
        switch self {
        case .doNow: return GameTheme.red.opacity(0.9)
        case .schedule: return GameTheme.blue.opacity(0.9)
        case .delegate: return GameTheme.yellow.opacity(0.9)
        case .later: return Color.gray.opacity(0.7)
        }
    }
}

struct TodoItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var deadline: Date // treated as Date only in UI
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
        case (false, false): return .later
        }
    }
}
