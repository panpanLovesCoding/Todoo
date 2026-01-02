import SwiftUI

#Preview {
    ContentView()
}

struct ContentView: View {
    @StateObject var manager = TodoManager()
    @State private var showingAddSheet = false
    @State private var selectedTab = 0
    
    init() {
        // We are now handling the tab bar background manually in the body view
        // to get the thick border effect, so we set standard appearance to clear.
        UITabBar.appearance().backgroundColor = UIColor.clear
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
    }

    var body: some View {
        NavigationView {
            ZStack {
                GameTheme.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Main Content Area
                    TabView(selection: $selectedTab) {
                        TodoListView(manager: manager)
                            .tag(0)
                        EisenhowerMatrixView(manager: manager)
                            .tag(1)
                        CompletedListView(manager: manager)
                            .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never)) // Use page style to hide default tab bar
                    
                    // NEW: Custom Toolbar Separator & Background
                    VStack(spacing: 0) {
                        Divider()
                            .background(GameTheme.brown)
                            .scaleEffect(y: 4) // Thick separator line
                        
                        HStack {
                            TabButton(icon: "list.bullet.clipboard", text: "Tasks", isSelected: selectedTab == 0) { selectedTab = 0 }
                            Spacer()
                            TabButton(icon: "square.grid.2x2", text: "Matrix", isSelected: selectedTab == 1) { selectedTab = 1 }
                            Spacer()
                            TabButton(icon: "checkmark.seal.fill", text: "Done", isSelected: selectedTab == 2) { selectedTab = 2 }
                        }
                        .padding(.top, 10)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 5)
                    }
                    .background(GameTheme.cream.ignoresSafeArea(edges: .bottom))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("TO-DO QUEST")
                        .font(.custom("Luckiest Guy", size: 30))
                        .foregroundColor(GameTheme.cream)
                        .shadow(color: GameTheme.brown, radius: 0, x: 2, y: 2)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(
                            Capsule().fill(GameTheme.brown)
                                     .overlay(Capsule().stroke(Color.white, lineWidth: 2))
                        )
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus")
                            .font(.title2.weight(.bold))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Circle().fill(GameTheme.green))
                            .overlay(Circle().stroke(GameTheme.brown, lineWidth: 2))
                            .shadow(radius: 2, y: 2)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddEditView(manager: manager, itemToEdit: nil)
            }
        }
    }
}

// Helper for custom tab buttons
struct TabButton: View {
    let icon: String
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .bold))
                Text(text)
                    .font(.system(size: 10, design: .rounded).weight(.bold))
            }
            .foregroundColor(isSelected ? GameTheme.brown : GameTheme.brown.opacity(0.5))
            .scaleEffect(isSelected ? 1.1 : 1.0)
            .animation(.spring(), value: isSelected)
        }
    }
}
