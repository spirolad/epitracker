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
    func deleteCourse(id: Int64) async {
        do {
            try await SupabaseManager.shared.client
                .from("courses")
                .delete()
                .eq("id", value: id.description) // On utilise .description pour le type Long
                .execute()
            
            // On met à jour la liste locale pour que l'interface réagisse
            self.courses.removeAll { $0.id == id }
            print("✅ Cours supprimé")
        } catch {
            print("❌ Erreur suppression: \(error)")
        }
    }
}
