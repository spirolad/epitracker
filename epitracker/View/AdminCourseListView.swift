//
//  AdminCourseListView.swift
//  epitracker
//
//  Created by Utilisateur invité on 24/04/2026.
//

import SwiftUI

struct AdminCourseListView: View {
    @StateObject var viewModel = CourseListViewModel()
    @State private var courseToEdit: Course?
    @State private var isShowingAdd = false

    var body: some View {
        List {
            ForEach(viewModel.courses) { course in
                VStack(alignment: .leading) {
                    Text(course.name).font(.headline)
                    Text("Début: \(course.startAt.formatted(date: .abbreviated, time: .shortened))").font(.caption)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        Task { await viewModel.deleteCourse(id: course.id) }
                    } label: { Label("Supprimer", systemImage: "trash") }
                    
                    Button { courseToEdit = course } label: { Label("Modifier", systemImage: "pencil") }.tint(.orange)
                }
            }
        }
        .navigationTitle("Cours")
        .toolbar { Button { isShowingAdd = true } label: { Image(systemName: "plus") } }
        .refreshable { await viewModel.fetchFutureCourses() }
        .onAppear { Task { await viewModel.fetchFutureCourses() } }
        .sheet(isPresented: $isShowingAdd) {
            AddCourseView(onComplete: {
                Task {
                    await viewModel.fetchFutureCourses()
                }
            })
        }
        .sheet(item: $courseToEdit) { course in
            EditCourseView(course: course) { Task { await viewModel.fetchFutureCourses() } }
        }
    }
}

#Preview {
    AdminCourseListView()
}
