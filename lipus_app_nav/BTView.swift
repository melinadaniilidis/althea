//
//  BTView.swift
//  lipus_app_nav
//
//  Created by Melina Daniilidis on 11/22/24.
//

import SwiftUI

struct BTView: View {
    @StateObject var bluetoothManager = BluetoothManager.shared

    var body: some View {
        VStack {
            Button(action: {
            bluetoothManager.toggleBluetooth()
            }) {
            }
            
            Text("Bluetooth is \(bluetoothManager.isBluetoothEnabled ? "enabled" : "disabled")")
                .padding()

            List(bluetoothManager.discoveredPeripherals, id: \.identifier) { peripheral in
                VStack(alignment: .leading) {
                    Text(bluetoothManager.peripheralNames[peripheral] ?? "Unknown Device") // Fetch name from dictionary
                        .font(.headline)
                    Text("UUID: \(peripheral.identifier.uuidString)")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    // Toggleable Connect/Disconnect Button
                    Button(action: {
                        if bluetoothManager.connectedPeripheral == peripheral {
                            bluetoothManager.disconnect(from: peripheral)
                        } else {
                            bluetoothManager.connect(to: peripheral)
                        }
                    }) {
                        Text(bluetoothManager.connectedPeripheral == peripheral ? "Disconnect" : "Connect")
                            .foregroundColor(bluetoothManager.connectedPeripheral == peripheral ? .red : .blue)
                    }
                    .disabled(SessionManager.shared.isRunning) // Disable if session is running
                    .opacity(SessionManager.shared.isRunning ? 0.5 : 1.0) // Make button faded when disabled
                }
            }
        }
    }
}

struct BTView_Previews: PreviewProvider {
    static var previews: some View {
        BTView()
    }
}
