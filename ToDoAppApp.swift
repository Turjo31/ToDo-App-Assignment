import SwiftUI
import FirebaseCore

@main
struct ToDoAppApp: App {
    // One AuthService for the whole app. Every screen can read it via @EnvironmentObject.
    @StateObject private var auth: AuthService

    init() {
        
        FirebaseApp.configure()
        // 2. Only now create AuthService (it talks to Firebase Auth in its init).
        _auth = StateObject(wrappedValue: AuthService())
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(auth)
        }
    }
}
