import SwiftUI

struct AddCourseView: View {
    @StateObject var viewModel = AddCourseViewModel()
    @Environment(\.dismiss) var dismiss
    
    // Champs du formulaire
    @State private var courseName = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(3600 * 2) // +2h par défaut
    
    // Coordonnées GPS (on verra plus tard pour les récupérer auto)
    @State private var latitude = 48.8566
    @State private var longitude = 2.3522

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Informations du cours")) {
                    TextField("Titre (ex: Cours de Swift)", text: $courseName)
                }
                
                Section(header: Text("Horaires de validité")) {
                    DatePicker("Début", selection: $startDate)
                    DatePicker("Fin", selection: $endDate)
                }
                
                Section(header: Text("Localisation du cours")) {
                    HStack {
                        Text("Lat:")
                        TextField("Latitude", value: $latitude, format: .number)
                            .keyboardType(.decimalPad)
                    }
                    HStack {
                        Text("Lon:")
                        TextField("Longitude", value: $longitude, format: .number)
                            .keyboardType(.decimalPad)
                    }
                    Button("Ma position actuelle") {
                        // TODO: CoreLocation pour remplir lat/lon
                    }
                }
                
                if !viewModel.message.isEmpty {
                    Text(viewModel.message).foregroundColor(.red).font(.caption)
                }
                
                Button(action: {
                    viewModel.saveCourse(name: courseName, lat: latitude, lon: longitude, start: startDate, end: endDate) {
                        dismiss() // Ferme la vue après succès
                    }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Enregistrer le cours")
                            .frame(maxWidth: .infinity)
                            .bold()
                    }
                }
                .disabled(courseName.isEmpty || viewModel.isLoading)
            }
            .navigationTitle("Nouveau Cours")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
            }
        }
    }
}
