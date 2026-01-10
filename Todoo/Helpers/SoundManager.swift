import SwiftUI
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    var audioPlayer: AVAudioPlayer?

    func playSound(sound: String = "cute_click_sound_1", type: String = "mp3") {
        // 1. 检查 UserDefaults 中的 "soundEnabled" 键
        // 这与你在 SettingsView 中 @AppStorage("soundEnabled") 是对应的
        let isSoundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
        
        guard isSoundEnabled else { return }

        // 2. 播放逻辑
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                // 允许混合播放（不打断后台音乐）
                try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                audioPlayer?.play()
            } catch {
                print("音效播放失败: \(error)")
            }
        }
    }
}
