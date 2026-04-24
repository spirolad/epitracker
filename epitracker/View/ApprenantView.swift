//
//  ApprenantView.swift
//  epitracker
//
//  Created by Utilisateur invité on 24/04/2026.
//

import SwiftUI

struct ApprenantView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Bonjour, Apprenant !")
                .font(.title2)
            
            Button(action: { /* Logique Scan */ }) {
                VStack {
                    Image(systemName: "qrcode.viewfinder")
                        .resizable()
                        .frame(width: 150, height: 150)
                    Text("Scanner pour présence")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .padding(40)
                .background(Color.green)
                .cornerRadius(20)
            }
        }
        .navigationTitle("Ma Présence")
    }
}

#Preview {
    ApprenantView()
}
