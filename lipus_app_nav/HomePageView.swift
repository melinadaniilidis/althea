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
    @State private var isConnected = false
    @State private var batteryLevel = 80
    @State private var sessionTimeRemaining = 335 // in seconds
    @State private var painLevel = 4

    
//    let sampleData = [
//            PainData(date: Date().addingTimeInterval(-5 * 24 * 60 * 60), painLevel: 5),
//            PainData(date: Date().addingTimeInterval(-4 * 24 * 60 * 60), painLevel: 6),
//            PainData(date: Date().addingTimeInterval(-3 * 24 * 60 * 60), painLevel: 4),
//            PainData(date: Date().addingTimeInterval(-2 * 24 * 60 * 60), painLevel: 7),
//            PainData(date: Date().addingTimeInterval(-1 * 24 * 60 * 60), painLevel: 8),
//            PainData(date: Date(), painLevel: 5)
//        ]
    
    var body: some View {
        VStack {
            HStack {
                // Device connection
                Text(isConnected ? "Connected" : "Disconnected")
                    .foregroundColor(isConnected ? .green : .red)
                    .frame(width: 108, alignment: .leading)
                Toggle("", isOn: $isConnected).labelsHidden()
                
                Spacer()
                
                // Device battery
                if isConnected {
                    Image(systemName: batteryLevel > 20 ? "battery.100" : "battery.0")
                        .foregroundColor(batteryLevel > 20 ? .green : .red)
                    Text("\(batteryLevel)%")
                    
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            .padding(20)
            
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
            NavigationLink(destination: SessionView()) {
                        VStack {
                            Text("Current Session")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            Text("Time Remaining")
                                .font(.title)
                                .foregroundColor(.white)
                            if isConnected {
                                Text("\(sessionTimeRemaining / 60):\(String(format: "%02d", sessionTimeRemaining % 60))")
                                    .font(.system(size: 50))
                                    .foregroundColor(.orange)
                            } else {
                                Text("--")
                                    .font(.title)
                                    .foregroundColor(.white)
                                
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.white))
                    }
            
            .padding(20)
            
            // Pain Diagnostics
            NavigationLink(destination: PainDiagnosticsView()) {
                VStack {
                    Text("Diagnostics")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    Text("Today's Pain Level")
                        .font(.title)
                        .foregroundColor(.white)
                    HStack {
                        Button(action: { if painLevel > 0 { painLevel -= 1 } }) {
                            Text("-")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                        Text("\(painLevel)/10")
                            .font(.title)
                            .foregroundColor(.white)
                        Button(action: { if painLevel < 10 { painLevel += 1 } }) {
                            Text("+")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                        
                    }
                    
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
