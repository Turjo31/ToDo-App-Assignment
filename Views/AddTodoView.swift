import SwiftUI

struct AddTodoView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""

    /// The parent screen passes in what should happen on Save.
    let onSave: (String) -> Void

    var body: some View {
        NavigationStack {
            Form {
                TextField("What needs doing?", text: $title)
            }
            .navigationTitle("New To-Do")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(title.trimmingCharacters(in: .whitespaces))
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
