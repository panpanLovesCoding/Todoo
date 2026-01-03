import SwiftUI
import UserNotifications

struct SettingsView: View {
    @Binding var isPresented: Bool
    
    @ObservedObject var manager: TodoManager
    @ObservedObject var lang = LanguageManager.shared
    
    // 设置状态
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("musicEnabled") var musicEnabled: Bool = true
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = true
    
    // 控制删除确认弹窗
    @State private var showResetAlert = false
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    
    // 字体逻辑
    func getFontName() -> String {
        if lang.language == "zh" {
            return "HappyZcool-2016"
        } else {
            return "LuckiestGuy-Regular"
        }
    }
    
    // 物理外挂：获取阴影颜色
    func boldShadowColor(_ color: Color) -> Color {
        return lang.language == "zh" ? color : .clear
    }
    
    // 🆕 辅助函数：获取垂直偏移量
    // 如果是中文，通常不需要偏移；如果是 Luckiest Guy，向下偏移
    func getTextOffset(small: Bool = false) -> CGFloat {
        if lang.language == "zh" { return 0 }
        return small ? 3 : 5 // 小字移3，大字移5
    }
    
    var body: some View {
        let persona = manager.userPersonality
        
        VStack(spacing: 0) {
            // 1. 顶部标题 Banner
            ZStack {
                Image(systemName: "bookmark.fill")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(GameTheme.yellow)
                    .frame(width: 200, height: 60)
                    .shadow(color: GameTheme.brown.opacity(0.3), radius: 0, x: 0, y: 3)
                    .overlay(
                        Text(lang.localized("SETTINGS"))
                            .font(.custom(getFontName(), size: 28))
                            .foregroundColor(GameTheme.brown)
                            // 🆕 修正位置：这里原本偏移了 -5，现在改为 2 (相当于下移了7)
                            .offset(y: lang.language == "zh" ? -2 : 2)
                            .shadow(color: boldShadowColor(GameTheme.brown), radius: 0, x: 1, y: 1)
                    )
            }
            .zIndex(1)
            .offset(y: 25)
            
            // 2. 木板内容区域
            VStack(spacing: 20) {
                
                // 用户信息
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
                
                // 开关控制区
                HStack(spacing: 15) {
                    SoundToggleButton(icon: "music.note", label: "Music", isOn: $musicEnabled)
                    SoundToggleButton(icon: "speaker.wave.2.fill", label: "Sound", isOn: $soundEnabled)
                    
                    SoundToggleButton(icon: "bell.fill", label: "Notifications", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { oldValue, newValue in
                            if newValue {
                                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
                            }
                        }
                }
                
                Divider().background(GameTheme.brown)
                
                // 语言选择
                HStack {
                    Button(action: { lang.language = "en" }) {
                        Text("ENG")
                            .font(.custom("LuckiestGuy-Regular", size: 18))
                            .frame(width: 80, height: 40)
                            .foregroundColor(GameTheme.brown)
                            // 🆕 修正位置：英文 Luckiest Guy 下移 3
                            .offset(y: 3)
                    }
                    .buttonStyle(CartoonButtonStyle(
                        color: lang.language == "en" ? GameTheme.orange : GameTheme.cream,
                        cornerRadius: 8
                    ))
                    
                    Button(action: { lang.language = "zh" }) {
                        Text("中文")
                            .font(.custom("HappyZcool-2016", size: 18))
                            .frame(width: 80, height: 40)
                            .foregroundColor(GameTheme.brown)
                            .shadow(color: GameTheme.brown, radius: 0, x: 0.5, y: 0.5)
                            // 中文不需要偏移
                    }
                    .buttonStyle(CartoonButtonStyle(
                        color: lang.language == "zh" ? GameTheme.orange : GameTheme.cream,
                        cornerRadius: 8
                    ))
                }
                
                // 按钮组
                VStack(spacing: 12) {
                    
                    // Rate Us 按钮
                    Button(action: {
                        if let url = URL(string: "itms-apps://itunes.apple.com/app/id123456789") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Text(lang.localized("Rate Us"))
                                .font(.custom(getFontName(), size: 20))
                                // 🆕 修正位置：动态偏移
                                .offset(y: getTextOffset(small: true))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .foregroundColor(.white)
                        .shadow(color: boldShadowColor(.white), radius: 0, x: 1, y: 1)
                    }
                    .buttonStyle(CartoonButtonStyle(color: GameTheme.blue, cornerRadius: 12))
                    
                    // Reset Data 按钮 & Version
                    VStack(spacing: 8) {
                        Button(action: {
                            showResetAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash.fill")
                                Text(lang.localized("Delete All"))
                                    .font(.custom(getFontName(), size: 18))
                                    // 🆕 修正位置
                                    .offset(y: getTextOffset(small: true))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .foregroundColor(.white)
                            .shadow(color: boldShadowColor(.white), radius: 0, x: 1, y: 1)
                        }
                        .buttonStyle(CartoonButtonStyle(color: Color(red: 0.85, green: 0.3, blue: 0.3), cornerRadius: 12))
                        .alert(isPresented: $showResetAlert) {
                            Alert(
                                title: Text(lang.localized("Confirm Delete")),
                                message: Text(lang.localized("RESET_WARNING")),
                                primaryButton: .destructive(Text(lang.localized("Delete"))) {
                                    manager.items.removeAll()
                                },
                                secondaryButton: .cancel(Text(lang.localized("Cancel")))
                            )
                        }
                        
                        Text("\(lang.localized("Version")) \(appVersion)")
                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                            .foregroundColor(GameTheme.brown.opacity(0.3))
                    }
                }
                .padding(.bottom, 15)
            }
            .padding(25)
            .background(GameTheme.cream)
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(GameTheme.brown, lineWidth: 5))
            .padding(.horizontal, 40)
            
            // 3. 底部 OK 按钮
            Button(action: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.spring()) {
                        isPresented = false
                    }
                }
            }) {
                Text(lang.localized("OK"))
                    .font(.custom(getFontName(), size: 24))
                    .foregroundColor(.white)
                    // 🆕 修正位置：大按钮下移 5
                    .offset(y: getTextOffset(small: false))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 40)
                    .shadow(color: boldShadowColor(.white), radius: 0, x: 1, y: 1)
            }
            .offset(y: -25)
            .buttonStyle(CartoonButtonStyle(color: GameTheme.green, cornerRadius: 15))
        }
    }
}

// 3D 卡通按钮样式 (保持不变)
struct CartoonButtonStyle: ButtonStyle {
    let color: Color
    var cornerRadius: CGFloat = 12
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.black.opacity(0.6), lineWidth: 3)
                    )
            )
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(GameTheme.brown.opacity(0.4))
                    .offset(y: configuration.isPressed ? 0 : 4)
            )
            .offset(y: configuration.isPressed ? 4 : 0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// 辅助组件 (保持不变)
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
        }
        .buttonStyle(CartoonButtonStyle(
            color: isOn ? GameTheme.yellow : Color.gray.opacity(0.3),
            cornerRadius: 12
        ))
    }
}
