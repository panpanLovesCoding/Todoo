import SwiftUI

class LanguageManager: ObservableObject {
    @AppStorage("selectedLanguage") var language: String = "en"
    
    static let shared = LanguageManager()
    
    func localized(_ key: String) -> String {
        if language == "zh" {
            return zh[key] ?? key
        } else {
            return en[key] ?? key
        }
    }
    
    let en: [String: String] = [
        "SETTINGS": "SETTINGS", // 之前已改为复数
        
        "Music": "Music",
        "Sound": "Sound",
        "Notifications": "Notif",
        "Version": "Version",
        
        "Language": "Language",
        "Rate Us": "Rate Us",
        "OK": "OK",
        "Total": "Total",
        "Important": "Important",
        "Done": "Done",
        "Tasks": "Tasks",
        "Matrix": "Matrix",
        "Add New": "Add New",
        "Delete All": "Reset Data",
        
        // 🆕 新增：删除确认弹窗文案
        "Confirm Delete": "Confirm Delete",
        "RESET_WARNING": "Are you sure you want to delete all data? This cannot be undone.",
        "Cancel": "Cancel",
        "Delete": "Delete",
        
        // Titles & Vibes ... (保持不变)
        "TITLE_ELITE_VANGUARD": "Elite Vanguard",
        "VIBE_ELITE_VANGUARD": "\"I don't just put out fires; I build fireproof houses.\"",
        "TITLE_CHAOS_SURFER": "Chaos Surfer",
        "VIBE_CHAOS_SURFER": "\"Is it 5 PM yet? I've done 100 things and 90 of them were screaming at me.\"",
        "TITLE_DEADLINE_DAREDEVIL": "Deadline Daredevil",
        "VIBE_DEADLINE_DAREDEVIL": "\"Work hard, play hard, panic harder.\"",
        "TITLE_GRANDMASTER": "Grandmaster Strategist",
        "VIBE_GRANDMASTER": "\"I planned for this crisis three weeks ago.\"",
        "TITLE_BENEVOLENT_RULER": "The Benevolent Ruler",
        "VIBE_BENEVOLENT_RULER": "\"I'm trying to build an empire here, but sure, I'll fix your printer.\"",
        "TITLE_PHILOSOPHER_KING": "Philosopher King",
        "VIBE_PHILOSOPHER_KING": "\"I have a 5-year plan, but first, let me watch this cat video for inspiration.\"",
        "TITLE_SPINNING_TOP": "Spinning Top",
        "VIBE_SPINNING_TOP": "\"So much speed, so little destination.\"",
        "TITLE_SIDE_QUEST_HERO": "Side-Quest Hero",
        "VIBE_SIDE_QUEST_HERO": "\"The world needs saving, but this villager needs 5 apples right now.\"",
        "TITLE_NPC_ENERGY": "NPC Energy",
        "VIBE_NPC_ENERGY": "\"I'm just here to fill the space.\"",
        "TITLE_CLUTCH_GAMER": "The Clutch Gamer",
        "VIBE_CLUTCH_GAMER": "\"I work best when I have exactly 5 minutes left.\"",
        "TITLE_DAYDREAM_BELIEVER": "Daydream Believer",
        "VIBE_DAYDREAM_BELIEVER": "\"My to-do list is a wish list.\"",
        "TITLE_POTATO_MODE": "Potato Mode Activated",
        "VIBE_POTATO_MODE": "\"Can I do this tomorrow? Or never? Never works for me.\""
    ]
    
    let zh: [String: String] = [
        "SETTINGS": "设 置",
        "Music": "背 景 音",
        "Sound": "音 效",
        "Notifications": "提 醒",
        "Version": "版 本",
        
        "Language": "语 言",
        "Rate Us": "去 App Store 评分",
        "OK": "确 定",
        "Total": "待 办",
        "Important": "重 要",
        "Done": "已 完 成",
        "Tasks": "任 务 列 表",
        "Matrix": "四 象 限",
        "Add New": "新 建",
        "Delete All": "重 置 数 据",
        
        // 🆕 新增：删除确认弹窗文案
        "Confirm Delete": "确认删除",
        "RESET_WARNING": "你确定要清空所有数据吗？此操作无法撤销。",
        "Cancel": "取消",
        "Delete": "删除",
        
        // Titles & Vibes ... (保持不变)
        "TITLE_ELITE_VANGUARD": "精英先锋",
        "VIBE_ELITE_VANGUARD": "“我不只负责救火，我还建造防火屋。”",
        "TITLE_CHAOS_SURFER": "混沌冲浪手",
        "VIBE_CHAOS_SURFER": "“五点了吗？我做了100件事，其中90件都在对我尖叫。”",
        "TITLE_DEADLINE_DAREDEVIL": "死线狂徒",
        "VIBE_DEADLINE_DAREDEVIL": "“努力工作，尽情玩乐，更加恐慌。”",
        "TITLE_GRANDMASTER": "特级战略大师",
        "VIBE_GRANDMASTER": "“为了这场危机，我三周前就做好了计划。”",
        "TITLE_BENEVOLENT_RULER": "仁慈的统治者",
        "VIBE_BENEVOLENT_RULER": "“我正忙着建立帝国呢，但行吧，我去修你的打印机。”",
        "TITLE_PHILOSOPHER_KING": "哲学之王",
        "VIBE_PHILOSOPHER_KING": "“我有五年计划，但首先，让我看个猫片找找灵感。”",
        "TITLE_SPINNING_TOP": "疯狂陀螺",
        "VIBE_SPINNING_TOP": "“速度极快，方向全无。”",
        "TITLE_SIDE_QUEST_HERO": "支线任务之王",
        "VIBE_SIDE_QUEST_HERO": "“世界需要拯救，但这该死的村民现在就要5个苹果。”",
        "TITLE_NPC_ENERGY": "路人甲体质",
        "VIBE_NPC_ENERGY": "“我只是来充数的 NPC。”",
        "TITLE_CLUTCH_GAMER": "翻盘赌徒",
        "VIBE_CLUTCH_GAMER": "“离死线只有5分钟时，才是我战力最强的时候。”",
        "TITLE_DAYDREAM_BELIEVER": "白日梦想家",
        "VIBE_DAYDREAM_BELIEVER": "“我的待办清单其实是许愿单。”",
        "TITLE_POTATO_MODE": "土豆模式开启中",
        "VIBE_POTATO_MODE": "“能明天做吗？或者这辈子都不做？我觉得后者不错。”"
    ]
}
