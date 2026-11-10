import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthService

    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            Form {
                Picker("Mode", selection: $isSignUp) {
                    Text("Log in").tag(false)
                    Text("Sign up").tag(true)
                }
                .pickerStyle(.segmented)

                Section {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                    SecureField("Password (min 6 characters)", text: $password)
                }

                if let message = auth.errorMessage {
                    Text(message).foregroundStyle(.red).font(.footnote)
                }

                Button(isSignUp ? "Create account" : "Log in") {
                    Task {
                        isLoading = true
                        if isSignUp {
                            await auth.signUp(email: email, password: password)
                        } else {
                            await auth.signIn(email: email, password: password)
                        }
                        isLoading = false
                    }
                }
                .disabled(email.isEmpty || password.count < 6 || isLoading)
            }
            .navigationTitle("To-Do App")
        }
    }
}
