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
        "SETTINGS": "SETTINGS",
        
        // 🆕 头部标题
        "QUEST LOG": "QUEST LOG",
        "COMPLETED LOG": "COMPLETED LOG",
        
        // 🆕 四象限 (使用硬编码 Key 对应)
        "Do Now": "DO NOW",
        "Plan": "PLAN",
        "Delegate": "DELEGATE",
        "Later": "LATER",
        
        // 🆕 新建任务界面
        "NEW QUEST": "NEW QUEST",
        "EDIT QUEST": "EDIT QUEST",
        "Quest Name": "Quest Name",
        "Enter quest name...": "Enter quest name...",
        "Deadline": "Deadline",
        "Urgent": "Urgent",
        "Important": "Important",
        "Save": "Save",
        "Cancel": "Cancel",
        "Abandon Quest": "Abandon Quest",
        
        // 🆕 排序
        "SORT BY": "SORT BY",
        "Select": "Select",
        "Created Time": "Created Time",
        "Due Date": "Due Date",
        "Task Name": "Task Name",
        
        // 🆕 空状态与弹窗
        "No active quests!": "No active quests!",
        "No completed quests yet!": "No completed quests yet!",
        "Empty": "Empty",
        "Abandon Quest?": "Abandon Quest?",
        "ABANDON_WARNING": "Are you sure you want to abandon this quest? This cannot be undone.",
        "Abandon": "Abandon",
        
        // 其他
        "Music": "Music",
        "Sound": "Sound",
        "Notifications": "Notif",
        "Version": "Version",
        "Rate Us": "Rate Us",
        "OK": "OK",
        "Total": "Total",
        "Done": "Done",
        "Tasks": "Tasks",
        "Matrix": "Matrix",
        "Add New": "Add New",
        "Delete All": "Reset Data",
        "Confirm Delete": "Confirm Delete",
        "RESET_WARNING": "Are you sure you want to delete all data? This cannot be undone.",
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
        
        // 🆕 头部标题
        "QUEST LOG": "任 务 日 志",
        "COMPLETED LOG": "完 成 记 录",
        
        // 🆕 四象限
        "Do Now": "马 上 做",
        "Plan": "计 划 做",
        "Delegate": "授 权 做",
        "Later": "稍 后 做",
        
        // 🆕 新建任务界面
        "NEW QUEST": "新 建 任 务",
        "EDIT QUEST": "编 辑 任 务",
        "Quest Name": "任务名称",
        "Enter quest name...": "输入任务名称...",
        "Deadline": "截止日期",
        "Urgent": "紧 急",
        "Important": "重 要",
        "Save": "保 存",
        "Cancel": "取 消",
        "Abandon Quest": "放弃任务",
        
        // 🆕 排序
        "SORT BY": "排 序",
        "Select": "选 择",
        "Created Time": "创 建 时 间",
        "Due Date": "截 止 日 期",
        "Task Name": "任 务 名 称",
        
        // 🆕 空状态
        "No active quests!": "暂无进行中的冒险！",
        "No completed quests yet!": "还没有完成的任务！",
        "Empty": "空",
        "Abandon Quest?": "放弃任务？",
        "ABANDON_WARNING": "确定要放弃这个任务吗？此操作无法撤销。",
        "Abandon": "放 弃",
        
        // 其他
        "Music": "背 景 音",
        "Sound": "音 效",
        "Notifications": "提 醒",
        "Version": "版 本",
        "Rate Us": "去 App Store 评分",
        "OK": "确 定",
        "Total": "待 办",
        "Done": "已 完 成",
        "Tasks": "任 务 列 表",
        "Matrix": "四 象 限",
        "Add New": "新 建",
        "Delete All": "重 置 数 据",
        "Confirm Delete": "确认删除",
        "RESET_WARNING": "你确定要清空所有数据吗？此操作无法撤销。",
        "Delete": "删 除",
        
        // Titles & Vibes ... (保持原样)
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
