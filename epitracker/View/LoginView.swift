import SwiftUI
import Foundation

struct UserProfile: Codable, Identifiable, Hashable, Equatable {
    let id: Int64
    let email: String
    let fullName: String?
    let role: String
    let tempPassword: String?

    enum CodingKeys: String, CodingKey {
        case id, email, role
        case fullName = "full_name"
        case tempPassword = "temp_password"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.id == rhs.id
    }
}

struct LoginView: View {
    @StateObject var auth = AuthService()
    @State private var email = ""
    @State private var mdp = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                Text("Check-In App")
                    .font(.system(size: 40, weight: .black))
                
                VStack {
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                    
                    SecureField("Mot de passe", text: $mdp)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)

                Button(action: {
                    Task { await auth.login(email: email, password: mdp) }
                }) {
                    Text("SE CONNECTER")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                if auth.isError {
                    Text("Accès refusé. Vérifie tes infos.")
                        .foregroundColor(.red)
                }
            }
            .navigationDestination(item: $auth.currentUser) { user in
                if user.role == "admin" {
                    AdminPanelView()
                } else {
                    ApprenantView()
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
