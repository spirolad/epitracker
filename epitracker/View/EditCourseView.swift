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
    var onComplete: () -> Void
    
    @State private var name: String
    @State private var startAt: Date
    @State private var endAt: Date
    @State private var lat: Double
    @State private var lon: Double

    init(course: Course, onComplete: @escaping () -> Void) {
        self.course = course
        self.onComplete = onComplete
        _name = State(initialValue: course.name)
        _startAt = State(initialValue: course.startAt)
        _endAt = State(initialValue: course.endAt)
        _lat = State(initialValue: course.latitude)
        _lon = State(initialValue: course.longitude)
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Nom du cours", text: $name)
                DatePicker("Début", selection: $startAt)
                DatePicker("Fin", selection: $endAt)
                TextField("Lat", value: $lat, format: .number)
                TextField("Lon", value: $lon, format: .number)
                
                Button("Mettre à jour") { Task { await update() } }.tint(.orange)
            }
            .navigationTitle("Modifier")
            .toolbar { Button("Annuler") { dismiss() } }
        }
    }

    func update() async {
        let data: [String: AnyJSON] = [
            "name": .string(name),
            "start_at": .string(ISO8601DateFormatter().string(from: startAt)),
            "end_at": .string(ISO8601DateFormatter().string(from: endAt)),
            "latitude": .double(lat),
            "longitude": .double(lon)
        ]
        try? await SupabaseManager.shared.client.from("courses").update(data).eq("id", value: course.id.description).execute()
        onComplete()
        dismiss()
    }
}
