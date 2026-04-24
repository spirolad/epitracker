//
//  CheckpointListView.swift
//  epitracker
//
//  Created by Utilisateur invité on 24/04/2026.
//

import SwiftUI

struct Checkpoint: Codable, Identifiable, Hashable {
    let id: Int64
    let name: String
}

import SwiftUI
import Supabase

struct CheckpointListView: View {
    @State private var checkpoints: [Checkpoint] = []
    @State private var isShowingAdd = false
    let qrService = QRCodeService()

    var body: some View {
        List {
            ForEach(checkpoints) { cp in
                NavigationLink(destination: CheckpointDetailView(checkpoint: cp)) {
                    VStack(alignment: .leading) {
                        Text(cp.name)
                            .font(.headline)
                        Text("ID Borne: \(cp.id)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        Task { await delete(id: cp.id) }
                    } label: {
                        Label("Supprimer", systemImage: "trash")
                    }
                }
            }
        }
        .navigationTitle("Bornes Salles")
        .toolbar {
            Button { isShowingAdd = true } label: { Image(systemName: "plus") }
        }
        .onAppear {
            Task { await fetch() }
        }
        .refreshable {
            await fetch()
        }
        .sheet(isPresented: $isShowingAdd) {
            AddCheckpointView {
                Task { await fetch() }
            }
        }
    }
    
    func fetch() async {
        do {
            let fetched: [Checkpoint] = try await SupabaseManager.shared.client
                .from("checkpoints")
                .select()
                .order("name", ascending: true)
                .execute()
                .value
            
            DispatchQueue.main.async {
                self.checkpoints = fetched
            }
        } catch {
            print("❌ Erreur fetch checkpoints: \(error)")
        }
    }

    // 2. Supprimer une borne
    func delete(id: Int64) async {
        do {
            try await SupabaseManager.shared.client
                .from("checkpoints")
                .delete()
                .eq("id", value: id.description)
                .execute()
            
            // On rafraîchit la liste après suppression
            await fetch()
        } catch {
            print("❌ Erreur suppression: \(error)")
        }
    }
}

struct CheckpointDetailView: View {
    let checkpoint: Checkpoint
    let qrService = QRCodeService()

    var body: some View {
        VStack(spacing: 40) {
            Text(checkpoint.name).font(.largeTitle).bold()
            
            // On génère le QR à partir de l'ID de la borne
            Image(uiImage: qrService.generate(from: checkpoint.id))
                .resizable()
                .interpolation(.none)
                .frame(width: 300, height: 300)
                .padding()
                .background(Color.white)
                .border(Color.black, width: 2)

            Text("ID unique : \(checkpoint.id)").font(.caption).monospaced()
            
            Text("À imprimer et coller dans la salle.")
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    CheckpointListView()
}
