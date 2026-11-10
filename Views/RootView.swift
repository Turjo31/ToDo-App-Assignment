import SwiftUI

/// Decides which screen to show: logged in -> list, logged out -> login.
struct RootView: View {
    @EnvironmentObject var auth: AuthService

    var body: some View {
        if auth.user != nil {
            TodoListView()
        } else {
            LoginView()
        }
    }
}
