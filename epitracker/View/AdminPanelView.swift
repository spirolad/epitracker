//
//  AdminPanelView.swift
//  epitracker
//
//  Created by Utilisateur invité on 24/04/2026.
//

import SwiftUI

struct AdminPanelView: View {
    @State private var showingAddCourse = false

    var body: some View {
        List {
            Section("Gestion") {
                Button(action: { showingAddCourse.toggle() }) {
                    Label("Ajouter un cours", systemImage: "plus.circle.fill")
                }
                NavigationLink("Gérer les apprenants", destination: StudentManagementView())
            }
            
            Section("Consultation") {
                NavigationLink("Liste des présences", destination: Text("Historique..."))
            }
        }
        .navigationTitle("Dashboard Admin")
        .sheet(isPresented: $showingAddCourse) {
            AddCourseView()
        }
    }
}

#Preview {
    AdminPanelView()
}
