//
//  EditCourseView.swift
//  epitracker
//
//  Created by Utilisateur invité on 24/04/2026.
//

import SwiftUI
import Supabase

struct EditCourseView: View {
    @Environment(\.dismiss) var dismiss
    let course: Course
    var onComplete: () -> Void // Le fameux callback
    
    @State private var name: String
    @State private var startAt: Date
    @State private var endAt: Date
    @State private var latitude: Double
    @State private var longitude: Double
    @State private var isLoading = false

    // Constructeur complet
    init(course: Course, onComplete: @escaping () -> Void) {
        self.course = course
        self.onComplete = onComplete
        
        // Initialisation des @State avec les valeurs du cours
        _name = State(initialValue: course.name)
        _startAt = State(initialValue: course.startAt)
        _endAt = State(initialValue: course.endAt)
        _latitude = State(initialValue: course.latitude)
        _longitude = State(initialValue: course.longitude)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Détails du cours") {
                    TextField("Nom du cours", text: $name)
                    DatePicker("Début", selection: $startAt)
                    DatePicker("Fin", selection: $endAt)
                }
                
                Section("Localisation") {
                    HStack {
                        Text("Lat:")
                        TextField("Latitude", value: $latitude, format: .number)
                    }
                    HStack {
                        Text("Lon:")
                        TextField("Longitude", value: $longitude, format: .number)
                    }
                }
                
                Button(action: {
                    Task { await updateCourse() }
                }) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Mettre à jour")
                            .frame(maxWidth: .infinity)
                            .bold()
                    }
                }
                .tint(.orange)
            }
            .navigationTitle("Modifier le cours")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
            }
        }
    }

    func updateCourse() async {
        self.isLoading = true
        let formatter = ISO8601DateFormatter()
        
        let updatedData: [String: AnyJSON] = [
            "name": .string(name),
            "start_at": .string(formatter.string(from: startAt)),
            "end_at": .string(formatter.string(from: endAt)),
            "latitude": .double(latitude),
            "longitude": .double(longitude)
        ]

        do {
            try await SupabaseManager.shared.client
                .from("courses")
                .update(updatedData)
                .eq("id", value: course.id.description)
                .execute()
            
            DispatchQueue.main.async {
                self.isLoading = false
                onComplete() // Appel du callback pour rafraîchir la liste
                dismiss()
            }
        } catch {
            print("❌ Erreur update: \(error)")
            self.isLoading = false
        }
    }
}

