//
//  lipus_app_navApp.swift
//  lipus_app_nav
//
//  Created by Melina Daniilidis on 11/7/24.
//

import SwiftUI

@main
struct lipus_app_navApp: App {
//    @StateObject var bluetoothManager = BluetoothManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomePageView()
//                    .environmentObject(bluetoothManager) // Inject the instance
            }
        }
    }
}

