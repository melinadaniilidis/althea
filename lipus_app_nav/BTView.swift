//
//  BTView.swift
//  lipus_app_nav
//
//  Created by Melina Daniilidis on 11/22/24.
//

import SwiftUI
//import CoreBluetooth

struct BTView: View {
//    @StateObject var bluetoothManager = BluetoothManager() // this is Bluetooth manager
    
//    @EnvironmentObject var bluetoothManager: BluetoothManager
    
    @StateObject var bluetoothManager = BluetoothManager.shared

    var body: some View {
        VStack {
            Button(action: {
            bluetoothManager.toggleBluetooth()
            }) {
//        Text(bluetoothManager.isBluetoothEnabled ? "Turn Off Bluetooth" : "Turn On Bluetooth")
//                    .padding()
            }
            
            // TODO: implement turning off BT -- or not
            
            Text("Bluetooth is \(bluetoothManager.isBluetoothEnabled ? "enabled" : "disabled")")
                .padding()

            List(bluetoothManager.discoveredPeripherals, id: \.identifier) { peripheral in
                VStack(alignment: .leading) {
                    Text(bluetoothManager.peripheralNames[peripheral] ?? "Unknown Device") // Fetch name from dictionary
                        .font(.headline)
                    Text("UUID: \(peripheral.identifier.uuidString)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Button("Connect") {
                        bluetoothManager.connect(to: peripheral)
                    }
                }
            }
            
            // If a peripheral is connected, show the "Disconnect" button
            if let connectedPeripheral = bluetoothManager.connectedPeripheral {
                VStack {
                    Text("Connected to: \(connectedPeripheral.name ?? "Unknown Device")")
                        .font(.headline)
                        .padding()

                    // Use SessionManager to track session state
                    let sessionManager = SessionManager.shared

                    Button("Disconnect") {
                        bluetoothManager.disconnect(from: connectedPeripheral)
                    }
                    .padding()
                    .foregroundColor(.red)
                    .disabled(sessionManager.isRunning) // Disable button if session is running
                    .opacity(sessionManager.isRunning ? 0.5 : 1.0) // Adjust opacity when disabled
                }
            }

//            if let connectedPeripheral = bluetoothManager.connectedPeripheral {
//                VStack {
//                    Text("Connected to: \(connectedPeripheral.name ?? "Unknown Device")")
//                        .font(.headline)
//                        .padding()
//
//                    Button("Disconnect") {
//                        bluetoothManager.disconnect(from: connectedPeripheral)
//                    }
//                    .padding()
//                    .foregroundColor(.red)
//
////                    Button("Send Data") {
////                        let data = Data("Hello, peripheral!".utf8) // Create some data to send
////                        bluetoothManager.sendData(to: connectedPeripheral, data: data) // Send the data to the connected peripheral
////                    }
////                    .padding()
////                    .foregroundColor(.green)
//                }
//            }
        }
    }
}

struct BTView_Previews: PreviewProvider {
    static var previews: some View {
        BTView()
    }
}
