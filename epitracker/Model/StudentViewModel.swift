import Foundation
import Supabase

class StudentViewModel: ObservableObject {
    @Published var students: [UserProfile] = []
    @Published var isLoading = false

    @MainActor
    func fetchStudents() async {
        self.isLoading = true
        do {
            let fetched: [UserProfile] = try await SupabaseManager.shared.client
                .from("profiles")
                .select()
                .eq("role", value: "apprenant")
                .order("full_name", ascending: true)
                .execute()
                .value
            
            self.students = fetched
        } catch {
            print("❌ Erreur fetch students: \(error)")
        }
        self.isLoading = false
    }

    @MainActor
    func deleteStudent(id: Int64) async {
        do {
            try await SupabaseManager.shared.client
                .from("profiles")
                .delete()
                .eq("id", value: id.description)
                .execute()
            
            self.students.removeAll { $0.id == id }
        } catch {
            print("❌ Erreur suppression étudiant: \(error)")
        }
    }
}
