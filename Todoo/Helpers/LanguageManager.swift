import SwiftUI

class LanguageManager: ObservableObject {
    @AppStorage("selectedLanguage") var language: String = "en" // "en" or "zh"
    
    static let shared = LanguageManager()
    
    func localized(_ key: String) -> String {
        if language == "zh" {
            return zh[key] ?? key
        } else {
            return en[key] ?? key
        }
    }
    
    // 简单的字典翻译
    let en: [String: String] = [
        "SETTING": "SETTING",
        "Music": "Music",
        "Sound": "Sound",
        "Language": "Language",
        "Rate Us": "Rate Us",
        "OK": "OK",
        "Total": "Total",
        "Important": "Important",
        "Done": "Done",
        "Tasks": "Tasks",
        "Matrix": "Matrix",
        "Add New": "Add New",
        "Delete All": "Reset Data"
    ]
    
    let zh: [String: String] = [
        "SETTING": "设 置",
        "Music": "背 景 音",
        "Sound": "音 效",
        "Language": "语 言",
        "Rate Us": "去 评 分",
        "OK": "确 定",
        "Total": "待 办",
        "Important": "重 要",
        "Done": "已 完 成",
        "Tasks": "任 务 列 表",
        "Matrix": "四 象 限",
        "Add New": "新 建",
        "Delete All": "重 置 数 据"
    ]
}
