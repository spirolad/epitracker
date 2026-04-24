import SwiftUI


enum UserRole: String {
    case admin
    case apprenant
}

struct UserProfile {
    let email: String
    let role: UserRole
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var userRole: UserRole? = nil
    @State private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                Text("Présence Alternants")
                    .font(.largeTitle)
                    .bold()

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding(.horizontal)

                SecureField("Mot de passe", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: login) {
                    Text("Se connecter")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                if userRole == .admin {
                    AdminPanelView()
                } else {
                    ApprenantView()
                }
            }
        }
    }

    // Logique de simulation (À lier à Firebase plus tard)
    func login() {
        if email.contains("admin") {
            userRole = .admin
        } else {
            userRole = .apprenant
        }
        isLoggedIn = true
    }
}

#Preview {
    LoginView()
}
