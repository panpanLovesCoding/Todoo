import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    
    // 传入 manager 获取称号数据
    @ObservedObject var manager: TodoManager
    
    @ObservedObject var lang = LanguageManager.shared
    
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("musicEnabled") var musicEnabled: Bool = true
    
    var body: some View {
        // 获取当前人设
        let persona = manager.userPersonality
        
        // ❌ 之前的问题：这里如果有 ZStack + Color.black，弹窗动画就会错。
        // ✅ 修复：直接返回内容 VStack，背景交给 ContentView 处理。
        VStack(spacing: 0) {
            // 1. 顶部标题 Banner
            ZStack {
                Image(systemName: "bookmark.fill")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(GameTheme.yellow)
                    .frame(width: 200, height: 60)
                    .shadow(radius: 2, y: 2)
                    .overlay(
                        Text(lang.localized("SETTING"))
                            .font(.custom("Luckiest Guy", size: 28)) // 标题保持不变
                            .foregroundColor(GameTheme.brown)
                            .offset(y: -5)
                    )
            }
            .zIndex(1)
            .offset(y: 25)
            
            // 2. 木板内容区域
            VStack(spacing: 20) {
                
                // 用户信息展示 (Title + Vibe)
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
                            // 👇 修改 1: 字体改为 Luckiest Guy
                            .font(.custom("Luckiest Guy", size: 18))
                            .frame(width: 80, height: 40)
                            .background(lang.language == "en" ? GameTheme.orange : GameTheme.cream)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(GameTheme.brown, lineWidth: 2))
                            .foregroundColor(GameTheme.brown)
                    }
                    
                    Button(action: { lang.language = "zh" }) {
                        Text("中文")
                            // 👇 修改 2: 字体改为 Luckiest Guy
                            .font(.custom("Luckiest Guy", size: 18))
                            .frame(width: 80, height: 40)
                            .background(lang.language == "zh" ? GameTheme.orange : GameTheme.cream)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(GameTheme.brown, lineWidth: 2))
                            .foregroundColor(GameTheme.brown)
                    }
                }
                
                // Rate Us 按钮
                Button(action: {
                    if let url = URL(string: "itms-apps://itunes.apple.com/app/id123456789") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "star.fill").foregroundColor(.yellow)
                        Text(lang.localized("Rate Us"))
                            // 👇 修改 3: 字体改为 Luckiest Guy
                            .font(.custom("Luckiest Guy", size: 20))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(GameTheme.blue)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(GameTheme.brown, lineWidth: 2))
                    .foregroundColor(.white)
                }
                
                // 重置数据按钮
                Button(action: {
                    // manager.items.removeAll()
                }) {
                    Text(lang.localized("Delete All"))
                         // 👇 修改 4: 字体改为 Luckiest Guy (稍微小一点)
                        .font(.custom("Luckiest Guy", size: 16))
                        .foregroundColor(GameTheme.brown.opacity(0.5))
                }
            }
            .padding(25)
            .background(GameTheme.cream)
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(GameTheme.brown, lineWidth: 5))
            .padding(.horizontal, 40)
            
            // 3. 底部 OK 按钮
            Button(action: {
                withAnimation(.spring()) {
                    isPresented = false
                }
            }) {
                Text(lang.localized("OK"))
                    // 这个本来就是 Luckiest Guy，保持不变
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
    }
}

// 辅助组件 (保持在文件底部)
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
