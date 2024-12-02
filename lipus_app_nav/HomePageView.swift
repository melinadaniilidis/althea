//
//  HomePageView.swift
//  lipus_app_nav
//
//  Created by Melina Daniilidis on 11/7/24.
//

//import SwiftUI
//
//struct HomePageView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}

import SwiftUI

struct HomePageView: View {
    @StateObject var sessionManager = SessionManager()
    @State private var isConnected = false
    @State private var batteryLevel = 80
//    @State private var sessionTimeRemaining = 335 // in seconds

    var body: some View {
        VStack {
            ConnectionStatusView(isConnected: $isConnected)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
//            HStack {
//                Text(isConnected ? "Connected" : "Disconnected")
//                    .foregroundColor(isConnected ? .green : .red)
//                    .frame(width: 108, alignment: .leading)
//                Toggle("", isOn: $isConnected).labelsHidden()
//
//                Spacer()
//
//                if isConnected {
//                    Image(systemName: batteryLevel > 20 ? "battery.100" : "battery.0")
//                        .foregroundColor(batteryLevel > 20 ? .green : .red)
//                    Text("\(batteryLevel)%")
//                }
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(20)

            // Questionnaire
            NavigationLink(destination: BTView()) {
                VStack {
                    Text("Setup")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.white))
            }

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
//            NavigationLink(destination: SessionView(isConnected: $isConnected, sessionTimeRemaining: sessionTimeRemaining)) {
//                CurrentSessionBox(isConnected: isConnected, sessionTimeRemaining: sessionTimeRemaining)
//            }
//            NavigationLink(destination: SessionView(isConnected: $isConnected, sessionTimeRemaining: sessionTimeRemaining)) {
//                CurrentSessionBox(isConnected: isConnected)
//            }
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
            //                    Text("Today's Pain Level")
            //                        .font(.title)
            //                        .foregroundColor(.white)
            //                    HStack {
            //                        Button(action: { if painLevel > 0 { painLevel -= 1 } }) {
            //                            Text("-")
            //                                .font(.largeTitle)
            //                                .foregroundColor(.white)
            //                        }
            //                        Text("\(painLevel)/10")
            //                            .font(.title)
            //                            .foregroundColor(.white)
            //                        Button(action: { if painLevel < 10 { painLevel += 1 } }) {
            //                            Text("+")
            //                                .font(.largeTitle)
            //                                .foregroundColor(.white)
            //                        }
            //
            //                    }
                                
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
