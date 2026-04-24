//
//  StudentListView.swift
//  epitracker
//
//  Created by Utilisateur invité on 24/04/2026.
//

import SwiftUI

struct StudentListView: View {
    @StateObject var viewModel = StudentViewModel()
    @State private var isShowingAdd = false

    var body: some View {
        List {
            ForEach(viewModel.students) { student in
                VStack(alignment: .leading) {
                    Text(student.fullName ?? "Sans nom").font(.headline)
                    Text(student.email).font(.subheadline)
                    Text("Pass: \(student.tempPassword ?? "N/A")").font(.caption).foregroundColor(.blue)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        Task { await viewModel.deleteStudent(id: student.id) }
                    } label: { Label("Supprimer", systemImage: "trash") }
                }
            }
        }
        .navigationTitle("Étudiants")
        .toolbar { Button { isShowingAdd = true } label: { Image(systemName: "person.badge.plus") } }
        .onAppear { Task { await viewModel.fetchStudents() } }
        .sheet(isPresented: $isShowingAdd) {
            AddStudentView { Task { await viewModel.fetchStudents() } }
        }
    }
}

#Preview {
    StudentListView()
}
