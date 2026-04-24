//
//  AddStudentView.swift
//  epitracker
//
//  Created by Utilisateur invité on 24/04/2026.
//

import SwiftUI
import Helpers

struct AddStudentView: View {
    @Environment(\.dismiss) var dismiss
    @State private var fullName = ""
    @State private var email = ""
    @State private var generatedPassword = ""
    @State private var isLoading = false
    
    var onComplete: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Informations") {
                    TextField("Nom complet", text: $fullName)
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                }
                
                Section("Sécurité") {
                    if generatedPassword.isEmpty {
                        Button("Générer un mot de passe") {
                            generatedPassword = String((0..<6).map { _ in "0123456789".randomElement()! })
                        }
                    } else {
                        HStack {
                            Text("Mot de passe :").foregroundColor(.secondary)
                            Text(generatedPassword).bold().foregroundColor(.blue)
                        }
                    }
                }
                
                Button(action: saveStudent) {
                    if isLoading { ProgressView() }
                    else { Text("Créer l'étudiant").frame(maxWidth: .infinity) }
                }
                .disabled(fullName.isEmpty || email.isEmpty || generatedPassword.isEmpty)
            }
            .navigationTitle("Nouvel Étudiant")
            .toolbar {
                Button("Annuler") { dismiss() }
            }
        }
    }

    func saveStudent() {
        isLoading = true
        let studentData: [String: AnyJSON] = [
            "full_name": .string(fullName),
            "email": .string(email),
            "temp_password": .string(generatedPassword),
            "role": .string("apprenant")
        ]
        
        Task {
            do {
                try await SupabaseManager.shared.client.from("profiles").insert(studentData).execute()
                onComplete()
                dismiss()
            } catch {
                print("❌ Erreur insert: \(error)")
                isLoading = false
            }
        }
    }
}
