import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var currentUser: UserProfile?
    
    func signIn(email: String, password: String) {
        self.isLoading = true
        self.errorMessage = ""
        
        Task {
            do {
                // On cherche l'utilisateur dans la table profiles
                let profiles: [UserProfile] = try await SupabaseManager.shared.client
                    .from("profiles")
                    .select()
                    .eq("email", value: email)
                    .eq("temp_password", value: password)
                    .execute()
                    .value
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let user = profiles.first {
                        self.currentUser = user
                        print("✅ Connecté en tant que : \(user.role)")
                    } else {
                        self.errorMessage = "Email ou mot de passe incorrect."
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Erreur de connexion : \(error.localizedDescription)"
                }
            }
        }
    }
}
