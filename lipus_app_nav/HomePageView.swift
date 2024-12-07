//
//  HomePageView.swift
//  lipus_app_nav
//
//  Created by Melina Daniilidis on 11/7/24.
//

import SwiftUI

struct HomePageView: View {
    @StateObject var sessionManager = SessionManager()
    @State private var isConnected = false
    @State private var batteryLevel = 80
    
    var body: some View {
        VStack {
            ConnectionStatusView(isConnected: $isConnected)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
            
            // Setup
            NavigationLink(destination: BTView()) {
                VStack {
                    Text("Setup")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.white))
            }
            
            // Questionnaire
            NavigationLink(destination: QContentView()) {
                VStack {
                    Text("Questionnaire")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.white))
            }

            // Current Session
            NavigationLink(destination: SessionView(sessionManager: sessionManager, isConnected: $isConnected)) {
                            CurrentSessionBox(sessionManager: sessionManager, isConnected: isConnected)
                        }
            .padding(20)
            
            // Pain Diagnostics
            NavigationLink(destination: PainDiagnosticsView()) {
                VStack {
                    Text("Diagnostics")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.white))
            }

            Spacer()
        }
    }
}



struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView().preferredColorScheme(.dark)
    }
}
