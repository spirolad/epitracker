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

    var body: some View {
        List {
            if viewModel.isLoading {
                ProgressView("Chargement des cours...")
            }
            
            ForEach(viewModel.courses) { course in
                VStack(alignment: .leading, spacing: 5) {
                    Text(course.name)
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: "calendar")
                        Text(course.startAt.formatted(date: .abbreviated, time: .shortened))
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        Task { await viewModel.deleteCourse(at: [viewModel.courses.firstIndex(where: { $0.id == course.id })!]) }
                    } label: {
                        Label("Supprimer", systemImage: "trash")
                    }
                    
                    // BOUTON MODIFIER
                    Button {
                        courseToEdit = course
                    } label: {
                        Label("Modifier", systemImage: "pencil")
                    }
                    .tint(.orange)
                }
            }
        }
        .navigationTitle("Cours à venir")
        .refreshable {
            await viewModel.fetchFutureCourses()
        }
        .onAppear {
            Task { await viewModel.fetchFutureCourses() }
        }
        .sheet(item: $courseToEdit) { course in
                    EditCourseView(course: course, onComplete: {
                        Task {
                            await viewModel.fetchFutureCourses()
                        }
                    })
                }
    }
}
#Preview {
    AdminCourseListView()
}
