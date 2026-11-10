import Foundation
import FirebaseAuth

/// Talks to Firebase Authentication. Views never call Firebase Auth directly,
/// they call this class and watch its @Published properties.
@MainActor
final class AuthService: ObservableObject {
    /// nil = logged out, non-nil = logged in. SwiftUI redraws when this changes.
    @Published var user: User?
    @Published var errorMessage: String?

    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        user = Auth.auth().currentUser
        // Firebase calls this closure whenever someone logs in or out.
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.user = user
            }
        }
    }

    func signUp(email: String, password: String) async {
        errorMessage = nil
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signIn(email: String, password: String) async {
        errorMessage = nil
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
