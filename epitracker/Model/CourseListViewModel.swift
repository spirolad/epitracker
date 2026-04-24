import Foundation
import Supabase

class CourseListViewModel: ObservableObject {
    @Published var courses: [Course] = []
    @Published var isLoading = false

    @MainActor
    func fetchFutureCourses() async {
        self.isLoading = true
        do {
            let now = ISO8601DateFormatter().string(from: Date())
            
            let fetched: [Course] = try await SupabaseManager.shared.client
                .from("courses")
                .select()
                .gt("end_at", value: now)
                .order("start_at", ascending: true)
                .execute()
                .value
            
            self.courses = fetched
        } catch {
            print("❌ Erreur fetch: \(error)")
        }
        self.isLoading = false
    }

    @MainActor
    func deleteCourse(at offsets: IndexSet) async {
        for index in offsets {
            let course = courses[index]
            do {
                try await SupabaseManager.shared.client
                    .from("courses")
                    .delete()
                    .eq("id", value: course.id.description)
                    .execute()
                
                courses.remove(at: index)
                print("✅ Cours \(course.id) supprimé")
            } catch {
                print("❌ Erreur suppression: \(error)")
            }
        }
    }
}
