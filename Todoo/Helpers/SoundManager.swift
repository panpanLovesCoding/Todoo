import SwiftUI
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    var audioPlayer: AVAudioPlayer?
    
    // ✨ 修改定义：增加 volume 参数，默认值为 0.2
    func playSound(sound: String = "cute_click_sound_1", type: String = "mp3", volume: Float = 0.4) {
        
        let isSoundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
        guard isSoundEnabled else { return }
        
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                
                // ✨ 使用传入的 volume 参数
                audioPlayer?.volume = volume
                
                try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                audioPlayer?.play()
            } catch {
                print("音效播放失败: \(error)")
            }
        }
    }
}
