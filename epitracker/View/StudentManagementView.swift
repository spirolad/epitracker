//
//  StudentManagementView.swift
//  epitracker
//
//  Created by Utilisateur invité on 24/04/2026.
//

import SwiftUI

import Foundation
import CoreLocation

struct Course: Codable, Identifiable, Hashable {
    let id: Int64
    var name: String
    var latitude: Double
    var longitude: Double
    var startAt: Date
    var endAt: Date

    enum CodingKeys: String, CodingKey {
        case id, name, latitude, longitude
        case startAt = "start_at"
        case endAt = "end_at"
    }
}

struct Student: Identifiable {
    var id = UUID().uuidString
    var name: String
    var email: String
}

struct StudentManagementView: View {
    @State private var studentName = ""
    @State private var studentEmail = ""
    @State private var students = [Student]()

    var body: some View {
        VStack {
            Form {
                Section("Ajouter un apprenant") {
                    TextField("Nom complet", text: $studentName)
                    TextField("Email", text: $studentEmail)
                    Button("Ajouter à la base") {
                        addStudent()
                    }
                }
                
                Section("Liste des inscrits") {
                    List(students) { student in
                        VStack(alignment: .leading) {
                            Text(student.name).font(.headline)
                            Text(student.email).font(.subheadline).foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .navigationTitle("Apprenants")
    }

    func addStudent() {
        /*let db = Firestore.firestore()
        db.collection("students").addDocument(data: [
            "name": studentName,
            "email": studentEmail
        ]) */
        // Reset des champs
        studentName = ""
        studentEmail = ""
    }
}

#Preview {
    StudentManagementView()
}
