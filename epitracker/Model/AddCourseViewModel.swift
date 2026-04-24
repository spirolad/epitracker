import Foundation
import Supabase

class AddCourseViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var message = ""

    func saveCourse(name: String, lat: Double, lon: Double, start: Date, end: Date, completion: @escaping () -> Void) {
        self.isLoading = true
        
        let formatter = ISO8601DateFormatter()
        
        let newCourse: [String: AnyJSON] = [
            "name": .string(name),
            "latitude": .double(lat),
            "longitude": .double(lon),
            "start_at": .string(formatter.string(from: start)),
            "end_at": .string(formatter.string(from: end))
        ]
        
        Task {
            do {
                try await SupabaseManager.shared.client
                    .from("courses")
                    .insert(newCourse)
                    .execute()
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    completion()
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.message = "Erreur : \(error.localizedDescription)"
                }
            }
        }
    }
}
