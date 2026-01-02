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
    
    // 英文原文
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
        "Delete All": "Reset Data",
        
        // Titles
        "TITLE_ELITE_VANGUARD": "Elite Vanguard",
        "TITLE_CHAOS_SURFER": "Chaos Surfer",
        "TITLE_DEADLINE_DAREDEVIL": "Deadline Daredevil",
        "TITLE_GRANDMASTER": "Grandmaster Strategist",
        "TITLE_BENEVOLENT_RULER": "The Benevolent Ruler",
        "TITLE_PHILOSOPHER_KING": "Philosopher King",
        "TITLE_SPINNING_TOP": "Spinning Top",
        "TITLE_SIDE_QUEST_HERO": "Side-Quest Hero",
        "TITLE_NPC_ENERGY": "NPC Energy",
        "TITLE_CLUTCH_GAMER": "The Clutch Gamer",
        "TITLE_DAYDREAM_BELIEVER": "Daydream Believer",
        "TITLE_POTATO_MODE": "Potato Mode Activated",
        
        // Vibes
        "VIBE_ELITE_VANGUARD": "\"I don't just put out fires; I build fireproof houses.\"",
        "VIBE_CHAOS_SURFER": "\"Is it 5 PM yet? I've done 100 things and 90 of them were screaming at me.\"",
        "VIBE_DEADLINE_DAREDEVIL": "\"Work hard, play hard, panic harder.\"",
        "VIBE_GRANDMASTER": "\"I planned for this crisis three weeks ago.\"",
        "VIBE_BENEVOLENT_RULER": "\"I'm trying to build an empire here, but sure, I'll fix your printer.\"",
        "VIBE_PHILOSOPHER_KING": "\"I have a 5-year plan, but first, let me watch this cat video for inspiration.\"",
        "VIBE_SPINNING_TOP": "\"So much speed, so little destination.\"",
        "VIBE_SIDE_QUEST_HERO": "\"The world needs saving, but this villager needs 5 apples right now.\"",
        "VIBE_NPC_ENERGY": "\"I'm just here to fill the space.\"",
        "VIBE_CLUTCH_GAMER": "\"I work best when I have exactly 5 minutes left.\"",
        "VIBE_DAYDREAM_BELIEVER": "\"My to-do list is a wish list.\"",
        "VIBE_POTATO_MODE": "\"Can I do this tomorrow? Or never? Never works for me.\""
    ]
    
    // 中文翻译
    let zh: [String: String] = [
        "SETTING": "设 置",
        "Music": "背 景 音",
        "Sound": "音 效",
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
        
        // Titles
        "TITLE_ELITE_VANGUARD": "精英先锋",
        "TITLE_CHAOS_SURFER": "混沌冲浪手",
        "TITLE_DEADLINE_DAREDEVIL": "死线狂徒",
        "TITLE_GRANDMASTER": "特级战略大师",
        "TITLE_BENEVOLENT_RULER": "仁慈的统治者",
        "TITLE_PHILOSOPHER_KING": "哲学之王",
        "TITLE_SPINNING_TOP": "疯狂陀螺",
        "TITLE_SIDE_QUEST_HERO": "支线任务之王",
        "TITLE_NPC_ENERGY": "路人甲体质",
        "TITLE_CLUTCH_GAMER": "翻盘赌徒",
        "TITLE_DAYDREAM_BELIEVER": "白日梦想家",
        "TITLE_POTATO_MODE": "土豆模式开启中",
        
        // Vibes (意译以保留神韵)
        "VIBE_ELITE_VANGUARD": "“我不只负责救火，我还建造防火屋。”",
        "VIBE_CHAOS_SURFER": "“五点了吗？我做了100件事，其中90件都在对我尖叫。”",
        "VIBE_DEADLINE_DAREDEVIL": "“努力工作，尽情玩乐，更加恐慌。”",
        "VIBE_GRANDMASTER": "“为了这场危机，我三周前就做好了计划。”",
        "VIBE_BENEVOLENT_RULER": "“我正忙着建立帝国呢，但行吧，我去修你的打印机。”",
        "VIBE_PHILOSOPHER_KING": "“我有五年计划，但首先，让我看个猫片找找灵感。”",
        "VIBE_SPINNING_TOP": "“速度极快，方向全无。”",
        "VIBE_SIDE_QUEST_HERO": "“世界需要拯救，但这该死的村民现在就要5个苹果。”",
        "VIBE_NPC_ENERGY": "“我只是来充数的 NPC。”",
        "VIBE_CLUTCH_GAMER": "“离死线只有5分钟时，才是我战力最强的时候。”",
        "VIBE_DAYDREAM_BELIEVER": "“我的待办清单其实是许愿单。”",
        "VIBE_POTATO_MODE": "“能明天做吗？或者这辈子都不做？我觉得后者不错。”"
    ]
}
