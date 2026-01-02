import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    @ObservedObject var lang = LanguageManager.shared
    
    // 设置状态
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("musicEnabled") var musicEnabled: Bool = true
    
    var body: some View {
        ZStack {
            // 半透明黑色背景
            Color.black.opacity(0.5).ignoresSafeArea()
                .onTapGesture { isPresented = false }
            
            // 主面板
            VStack(spacing: 0) {
                // 1. 顶部标题 Banner (模仿 Setting 图片)
                ZStack {
                    Image(systemName: "bookmark.fill") // 这里简单用形状模拟 banner，实际可以用图片
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
                .zIndex(1) // 让它浮在木板上面
                .offset(y: 25) // 下沉一点盖住木板顶部
                
                // 2. 木板内容区域
                VStack(spacing: 20) {
                    
                    // 用户信息 (装饰用)
                    VStack(spacing: 5) {
                        Text("PLAYER ONE")
                            .font(.system(.headline, design: .rounded).weight(.heavy))
                            .foregroundColor(GameTheme.brown)
                        Text("ID: 8888-TODO")
                            .font(.system(.caption, design: .rounded).weight(.bold))
                            .foregroundColor(GameTheme.brown.opacity(0.6))
                    }
                    .padding(.top, 30)
                    
                    Divider().background(GameTheme.brown)
                    
                    // 音效开关 (模仿图片中的方块按钮)
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
                    
                    // Rate Us 按钮
                    Button(action: {
                        // 跳转到 App Store (示例链接)
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
                    
                    // 危险区域：重置数据
                    Button(action: {
                         // 这里可以添加清空数据的逻辑
                    }) {
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
                
                // 3. 底部 OK 按钮
                Button(action: { isPresented = false }) {
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
                .offset(y: -25) // 上移盖住木板底部
            }
        }
    }
}

// 辅助组件：音效方块开关
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
