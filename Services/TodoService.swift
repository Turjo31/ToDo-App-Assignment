import Foundation
import FirebaseFirestore

/// Talks to Firestore. Each user's to-dos live at:  users/{uid}/todos/{todoId}
@MainActor
final class TodoService: ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var errorMessage: String?

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    private func collection(for uid: String) -> CollectionReference {
        db.collection("users").document(uid).collection("todos")
    }

    /// Start a live listener: Firestore pushes updates to us whenever data changes.
    func startListening(userId: String) {
        stopListening()
        listener = collection(for: userId)
            .order(by: "createdAt")
            .addSnapshotListener { [weak self] snapshot, error in
                let items = snapshot?.documents.compactMap { TodoItem(document: $0) } ?? []
                let message = error?.localizedDescription
                Task { @MainActor in
                    if let message {
                        self?.errorMessage = message
                    } else {
                        self?.todos = items
                    }
                }
            }
    }

    func stopListening() {
        listener?.remove()
        listener = nil
        todos = []
    }

    func add(title: String, userId: String) async {
        do {
            try await collection(for: userId).addDocument(data: [
                "title": title,
                "isDone": false,
                "createdAt": Timestamp(date: Date())
            ])
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func toggle(_ item: TodoItem, userId: String) async {
        do {
            try await collection(for: userId).document(item.id)
                .updateData(["isDone": !item.isDone])
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func delete(_ item: TodoItem, userId: String) async {
        do {
            try await collection(for: userId).document(item.id).delete()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
