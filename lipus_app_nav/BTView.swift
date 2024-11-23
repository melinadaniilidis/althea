//
//  BTView.swift
//  lipus_app_nav
//
//  Created by Melina Daniilidis on 11/22/24.
//

import SwiftUI
//
//  BleutoothManager.swift
//  CoreBluetoothExample
//
//  Created by Mourad KIRAT on 23/02/2024.
//

import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, ObservableObject {
    @Published var isBluetoothEnabled = false
    @Published var discoveredPeripherals = [CBPeripheral]()
    @Published var connectedPeripheral: CBPeripheral?

    private var centralManager: CBCentralManager!
    var peripheralNames: [CBPeripheral: String] = [:] // Store names for peripherals

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isBluetoothEnabled = true
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            isBluetoothEnabled = false
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
            let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String
            peripheralNames[peripheral] = localName ?? "Unknown Device"
            print("Discovered peripheral: \(peripheralNames[peripheral] ?? "Unknown Device")")
        }
    }
    
    // Connect to the selected peripheral
        func connect(to peripheral: CBPeripheral) {
            centralManager.connect(peripheral, options: nil)
            connectedPeripheral = peripheral
            print("Connecting to peripheral: \(peripheral.name ?? "Unknown")")
        }

        // Disconnect from the connected peripheral
        func disconnect(from peripheral: CBPeripheral) {
            centralManager.cancelPeripheralConnection(peripheral)
            print("Disconnected from peripheral: \(peripheral.name ?? "Unknown")")
            connectedPeripheral = nil
        }

    func toggleBluetooth() {
        if centralManager.state == .poweredOn {
            centralManager.stopScan()
            centralManager = nil
        } else {
            centralManager = CBCentralManager(delegate: self, queue: nil)
        }
    }
    
    // MARK: - Write Data to the Device

        // Function to send data to a connected peripheral
    // transmitting data
        func sendData(to peripheral: CBPeripheral, data: Data) {
            let characteristicUUID = CBUUID(string: "2A56")
            if let characteristic = findCharacteristic(with: characteristicUUID, for: peripheral) {
                peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
            } else {
                print("Characteristic not found")
            }
        }
    
        // GPT solution to CBCharacteristicUUID() error
        func findCharacteristic(with uuid: CBUUID, for peripheral: CBPeripheral) -> CBCharacteristic? {
            guard let services = peripheral.services else { return nil }
            for service in services {
                if let characteristics = service.characteristics {
                    for characteristic in characteristics {
                        if characteristic.uuid == uuid {
                            return characteristic
                        }
                    }
                }
            }
            return nil
        }
//        func sendData(_ data: Data) {
//            guard let peripheral = connectedPeripheral else {
//                print("No peripheral connected")
//                return
//            }
//
//            // Ensure the peripheral has services and characteristics
//
//            peripheral.discoverServices(nil)
//            guard let services = peripheral.services else {
//                print("Peripheral does not have services")
//                return
//            }
//
//            var n = 0
//            // Assuming the first service is the one we need
//            for service in services {
//                print(n)
//                n = n+1
//                // For each service, we look for characteristics
//                if let characteristics = service.characteristics {
//                    for characteristic in characteristics {
//                        // Check if the characteristic supports write (e.g., check properties)
//                        if characteristic.properties.contains(.write) {
//                            // Write the data to the characteristic
//                            peripheral.writeValue(data, for: characteristic, type: .withResponse)
//                            print("Sent data to characteristic: \(characteristic.uuid.uuidString)")
//                            return
//                        }
//                    }
//                }
//            }
//
//            print("No writable characteristic found")
//        }
    // Toggle Bluetooth state (scan on/off)
//        func toggleBluetooth() {
//            if isBluetoothEnabled {
//                // Turn off Bluetooth
//                centralManager.stopScan() // Stop scanning for devices
//                if let peripheral = connectedPeripheral {
//                    disconnect(from: peripheral) // Disconnect from the peripheral if connected
//                }
//                centralManager = nil // Clear centralManager
//            } else {
//                // Turn on Bluetooth
//                centralManager = CBCentralManager(delegate: self, queue: nil)
//            }
//        }
    
}

struct BTView: View {
 @StateObject var bluetoothManager = BluetoothManager() // this is Bluetooth manager

    var body: some View {

        VStack {
    Button(action: {
                bluetoothManager.toggleBluetooth()
            }) {
        Text(bluetoothManager.isBluetoothEnabled ? "Turn Off Bluetooth" : "Turn On Bluetooth")
                    .padding()
       }
            
            // TODO: implement turning off BT
            
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
                                
                                Button("Disconnect") {
                                    bluetoothManager.disconnect(from: connectedPeripheral)
                                }
                                .padding()
                                .foregroundColor(.red)
                                
                                Button("Send Data") {
                                    let data = Data("Hello, peripheral!".utf8) // Create some data to send
//                                    peripheral.writeValue(data, for: characteristic, type: .withResponse)
                                    bluetoothManager.sendData(to: connectedPeripheral, data: data) // Send the data to the connected peripheral
                                                    }
                                    .padding()
                                    .foregroundColor(.green)
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
