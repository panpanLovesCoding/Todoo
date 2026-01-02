import SwiftUI

struct AddEditView: View {
    @ObservedObject var manager: TodoManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    // Default deadline is tomorrow
    @State private var deadline: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @State private var isImportant: Bool = false
    @State private var isUrgent: Bool = false
    @State private var id: UUID?
    
    init(manager: TodoManager, itemToEdit: TodoItem?) {
        self.manager = manager
        if let item = itemToEdit {
            _title = State(initialValue: item.title)
            _deadline = State(initialValue: item.deadline)
            _isImportant = State(initialValue: item.isImportant)
            _isUrgent = State(initialValue: item.isUrgent)
            _id = State(initialValue: item.id)
        }
    }
    
    var body: some View {
        ZStack {
            GameTheme.cream.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(id == nil ? "NEW QUEST" : "EDIT QUEST")
                    .font(.system(.largeTitle, design: .rounded).weight(.black))
                    .foregroundColor(GameTheme.brown)
                    .padding(.top)
                
                VStack(spacing: 15) {
                    TextField("Quest Name", text: $title)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(GameTheme.brown, lineWidth: 3))
                        .foregroundColor(GameTheme.brown)
                        .font(.system(.body, design: .rounded).weight(.bold))
                    
                    // UPDATED: displayedComponents: .date (No time)
                    DatePicker("Deadline Date", selection: $deadline, displayedComponents: .date)
                        .accentColor(GameTheme.brown)
                        .foregroundColor(GameTheme.brown)
                        .font(.system(.headline, design: .rounded).weight(.bold))
                    
                    Toggle("Important ⭐", isOn: $isImportant)
                        .toggleStyle(SwitchToggleStyle(tint: GameTheme.yellow))
                        .foregroundColor(GameTheme.brown)
                        .font(.system(.headline, design: .rounded).weight(.bold))

                    Toggle("Urgent 🔥", isOn: $isUrgent)
                        .toggleStyle(SwitchToggleStyle(tint: GameTheme.red))
                        .foregroundColor(GameTheme.brown)
                        .font(.system(.headline, design: .rounded).weight(.bold))
                }
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(15)
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(GameTheme.brown, lineWidth: 2))
                .padding()
                
                Spacer()
                
                Button("SAVE") {
                    let newItem = TodoItem(
                        id: id ?? UUID(),
                        title: title,
                        deadline: deadline,
                        isImportant: isImportant,
                        isUrgent: isUrgent
                        // createdAt is handled by default initializer
                    )
                    manager.addOrUpdate(newItem)
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(GameButtonStyle(color: GameTheme.green))
                .disabled(title.isEmpty)
                .opacity(title.isEmpty ? 0.6 : 1.0)
                
                if let safeId = id {
                    Button("DELETE") {
                        manager.delete(id: safeId)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(GameButtonStyle(color: GameTheme.red))
                    .padding(.top, 10)
                }
            }
            .padding()
        }
        .overlay(Rectangle().stroke(GameTheme.brown, lineWidth: 6))
    }
}
