import Foundation
import FirebaseFirestore

/// One to-do. This is the "M" (model): plain data, no UI, no networking.
struct TodoItem: Identifiable {
    let id: String          // the Firestore document ID
    var title: String
    var isDone: Bool
    var createdAt: Date

    /// Build a TodoItem from a Firestore document (a dictionary of fields).
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let title = data["title"] as? String else { return nil }
        self.id = document.documentID
        self.title = title
        self.isDone = data["isDone"] as? Bool ?? false
        self.createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
    }
}
