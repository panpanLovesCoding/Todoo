import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    @ObservedObject var manager: TodoManager
    @ObservedObject var lang = LanguageManager.shared
    
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("musicEnabled") var musicEnabled: Bool = true
    
    var body: some View {
        let persona = manager.userPersonality
        
        // ❌ 删除：ZStack 和 Color.black
        // 我们只返回这个核心的 VStack，这样它就是一个紧凑的视图，.scale 动画才会只作用于它
        VStack(spacing: 0) {
            // Banner
            ZStack {
                Image(systemName: "bookmark.fill")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(GameTheme.yellow)
                    .frame(width: 200, height: 60)
                    .shadow(radius: 2, y: 2)
                    .overlay(
                        Text(lang.localized("SETTING"))
                            .font(.custom("Luckiest Guy", size: 28))
                            .foregroundColor(GameTheme.brown)
                            .offset(y: -5)
                    )
            }
            .zIndex(1)
            .offset(y: 25)
            
            // 木板内容
            VStack(spacing: 20) {
                // Title + Vibe
                VStack(spacing: 8) {
                    Text(lang.localized(persona.title))
                        .font(.system(.title2, design: .rounded).weight(.heavy))
                        .foregroundColor(GameTheme.brown)
                        .multilineTextAlignment(.center)
                    
                    Text(lang.localized(persona.vibe))
                        .font(.system(.caption, design: .serif).italic())
                        .foregroundColor(GameTheme.brown.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, 30)
                
                Divider().background(GameTheme.brown)
                
                // 音效开关
                HStack(spacing: 30) {
                    SoundToggleButton(icon: "music.note", label: "Music", isOn: $musicEnabled)
                    SoundToggleButton(icon: "speaker.wave.2.fill", label: "Sound", isOn: $soundEnabled)
                }
                
                Divider().background(GameTheme.brown)
                
                // 语言选择
                HStack {
                    Button(action: { lang.language = "en" }) {
                        Text("ENG")
                            .bold()
                            .frame(width: 80, height: 40)
                            .background(lang.language == "en" ? GameTheme.orange : GameTheme.cream)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(GameTheme.brown, lineWidth: 2))
                            .foregroundColor(GameTheme.brown)
                    }
                    
                    Button(action: { lang.language = "zh" }) {
                        Text("中文")
                            .bold()
                            .frame(width: 80, height: 40)
                            .background(lang.language == "zh" ? GameTheme.orange : GameTheme.cream)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(GameTheme.brown, lineWidth: 2))
                            .foregroundColor(GameTheme.brown)
                    }
                }
                
                // 按钮组
                Button(action: {
                    if let url = URL(string: "itms-apps://itunes.apple.com/app/id123456789") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "star.fill").foregroundColor(.yellow)
                        Text(lang.localized("Rate Us"))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(GameTheme.blue)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(GameTheme.brown, lineWidth: 2))
                    .foregroundColor(.white)
                    .font(.system(.title3, design: .rounded).weight(.bold))
                }
                
                Button(action: {}) {
                    Text(lang.localized("Delete All"))
                        .font(.caption.weight(.bold))
                        .foregroundColor(GameTheme.brown.opacity(0.5))
                }
            }
            .padding(25)
            .background(GameTheme.cream)
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(GameTheme.brown, lineWidth: 5))
            .padding(.horizontal, 40)
            
            // OK Button
            Button(action: {
                // 这里的动画很重要，确保关闭时也有缩放效果
                withAnimation(.spring()) {
                    isPresented = false
                }
            }) {
                Text(lang.localized("OK"))
                    .font(.custom("Luckiest Guy", size: 24))
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 40)
                    .background(GameTheme.green)
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(GameTheme.brown, lineWidth: 3))
                    .shadow(radius: 3, y: 3)
            }
            .offset(y: -25)
        }
        // ❌ 注意：不要在这里加 .frame(maxWidth: .infinity, maxHeight: .infinity)
        // 让 VStack 保持它自己的大小，这样 ContentView 里的 scale 动画才会漂亮地从中心放大
    }
}

// 别忘了 SoundToggleButton (保持在文件底部)
struct SoundToggleButton: View {
    let icon: String
    let label: String
    @Binding var isOn: Bool
    
    var body: some View {
        Button(action: { isOn.toggle() }) {
            VStack {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(isOn ? GameTheme.brown : Color.gray)
            }
            .frame(width: 60, height: 60)
            .background(isOn ? GameTheme.yellow : Color.gray.opacity(0.3))
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(GameTheme.brown, lineWidth: 2))
            .shadow(color: .black.opacity(0.2), radius: 1, y: 2)
        }
    }
}
