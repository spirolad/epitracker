import SwiftUI
import Supabase

struct AddCourseView: View {
    @Environment(\.dismiss) var dismiss
    
    var onComplete: () -> Void
    
    @State private var courseName = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(3600 * 2)
    @State private var latitude = 48.8566
    @State private var longitude = 2.3522
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Informations") {
                    TextField("Nom du cours", text: $courseName)
                    DatePicker("Début", selection: $startDate)
                    DatePicker("Fin", selection: $endDate)
                }
                
                Section("Position") {
                    TextField("Lat", value: $latitude, format: .number)
                    TextField("Lon", value: $longitude, format: .number)
                }
                
                Button(action: {
                    Task { await saveCourse() }
                }) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Créer le cours").frame(maxWidth: .infinity).bold()
                    }
                }
                .disabled(courseName.isEmpty)
            }
            .navigationTitle("Nouveau cours")
            .toolbar {
                Button("Annuler") { dismiss() }
            }
        }
    }

    func saveCourse() async {
        self.isLoading = true
        let formatter = ISO8601DateFormatter()
        
        let newCourse: [String: AnyJSON] = [
            "name": .string(courseName),
            "latitude": .double(latitude),
            "longitude": .double(longitude),
            "start_at": .string(formatter.string(from: startDate)),
            "end_at": .string(formatter.string(from: endDate))
        ]
        
        do {
            try await SupabaseManager.shared.client
                .from("courses")
                .insert(newCourse)
                .execute()
            
            DispatchQueue.main.async {
                self.isLoading = false
                // 1. On appelle le refresh de la liste parente
                onComplete()
                // 2. On ferme la fenêtre
                dismiss()
            }
        } catch {
            print("❌ Erreur insert: \(error)")
            self.isLoading = false
        }
    }
}
