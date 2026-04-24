//
//  AddCheckpointView.swift
//  epitracker
//
//  Created by Utilisateur invité on 24/04/2026.
//

import SwiftUI
import Helpers

struct AddCheckpointView: View {
    @Environment(\.dismiss) var dismiss
    var onComplete: () -> Void
    @State private var name = ""
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            Form {
                TextField("Nom de la salle (ex: Salle 204)", text: $name)
                
                Button("Générer la borne") { Task { await save() } }
                .disabled(name.isEmpty || isLoading)
            }
            .navigationTitle("Nouveau QR Code")
            .toolbar { Button("Annuler") { dismiss() } }
        }
    }

    func save() async {
        isLoading = true
        let data: [String: AnyJSON] = ["name": .string(name)]
        try? await SupabaseManager.shared.client.from("checkpoints").insert(data).execute()
        onComplete()
        dismiss()
    }
}

