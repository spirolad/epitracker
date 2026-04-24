//
//  AdminPanelView.swift
//  epitracker
//
//  Created by Utilisateur invité on 24/04/2026.
//

import SwiftUI

import SwiftUI

struct AdminPanelView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Calendrier & Cours")) {
                    NavigationLink(destination: AdminCourseListView()) {
                        Label("Liste des cours", systemImage: "calendar.badge.plus")
                    }
                }
                
                Section(header: Text("Utilisateurs")) {
                    NavigationLink(destination: StudentListView()) {
                        Label("Liste des étudiants", systemImage: "person.2.fill")
                    }
                }
                                Section(header: Text("Infrastructure")) {
                                    NavigationLink(destination: CheckpointListView()) {
                                        Label {
                                            VStack(alignment: .leading) {
                                                Text("Bornes QR des salles")
                                                Text("Générer les QR à imprimer").font(.caption2).foregroundColor(.secondary)
                                            }
                                        } icon: {
                                            Image(systemName: "qrcode.viewfinder")
                                                .foregroundColor(.purple)
                                        }
                                    }
                                }
            }
            .navigationTitle("Dashboard Admin")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Déconnexion") { dismiss() }.foregroundColor(.red)
                }
            }
        }
    }
}

// Pour la preview
#Preview {
    AdminPanelView()
}
#Preview {
    AdminPanelView()
}
