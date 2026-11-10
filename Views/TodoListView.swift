import SwiftUI

struct TodoListView: View {
    @EnvironmentObject var auth: AuthService
    @StateObject private var service = TodoService()
    @State private var showingAdd = false

    private var uid: String { auth.user?.uid ?? "" }

    var body: some View {
        NavigationStack {
            List {
                ForEach(service.todos) { item in
                    HStack {
                        Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(item.isDone ? .green : .secondary)
                        Text(item.title)
                            .strikethrough(item.isDone)
                            .foregroundStyle(item.isDone ? .secondary : .primary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        Task { await service.toggle(item, userId: uid) }
                    }
                }
                .onDelete { offsets in
                    let toDelete = offsets.map { service.todos[$0] }
                    Task {
                        for item in toDelete {
                            await service.delete(item, userId: uid)
                        }
                    }
                }
            }
            .overlay {
                if service.todos.isEmpty {
                    ContentUnavailableView("No to-dos yet", systemImage: "checklist",
                                           description: Text("Tap + to add one."))
                }
            }
            .navigationTitle("My To-Dos")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Log out") { auth.signOut() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAdd = true } label: { Image(systemName: "plus") }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddTodoView { title in
                    Task { await service.add(title: title, userId: uid) }
                }
            }
        }
        .onAppear { service.startListening(userId: uid) }
        .onDisappear { service.stopListening() }
    }
}
