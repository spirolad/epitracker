import SwiftUI

class AuthService: ObservableObject {
    @Published var currentUser: UserProfile?
    @Published var isError = false
    
    func login(email: String, password: String) async {
        do {
            // Équivalent d'un SELECT * FROM profiles WHERE email = ... AND temp_password = ...
            let response: [UserProfile] = try await SupabaseManager.shared.client
                .from("profiles")
                .select()
                .eq("email", value: email)
                .eq("temp_password", value: password)
                .execute()
                .value
            
            DispatchQueue.main.async {
                if let user = response.first {
                    self.currentUser = user
                    print("✅ Bienvenue \(user.fullName ?? "Admin")")
                } else {
                    self.isError = true
                }
            }
        } catch {
            print("❌ Erreur de connexion : \(error)")
            DispatchQueue.main.async { self.isError = true }
        }
    }
}
