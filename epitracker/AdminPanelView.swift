//
//  AdminPanelView.swift
//  epitracker
//
//  Created by Utilisateur invité on 24/04/2026.
//

import SwiftUI

struct AdminPanelView: View {
    var body: some View {
        List {
            Section(header: Text("Gestion des Cours")) {
                NavigationLink("Créer un nouveau cours", destination: Text("Formulaire de création ici"))
                NavigationLink("Voir les présences", destination: Text("Liste des présences ici"))
            }
        }
        .navigationTitle("Panel Admin")
    }
}

#Preview {
    AdminPanelView()
}
