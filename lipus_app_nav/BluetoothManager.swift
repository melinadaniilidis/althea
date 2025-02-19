//
//  BluetoothManager.swift
//  lipus_app_nav
//
//  Created by Melina Daniilidis on 12/8/24.
//

import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, ObservableObject, CBPeripheralDelegate {
    
    static let shared = BluetoothManager() // Singleton instance
    
    @Published var isBluetoothEnabled = false
    @Published var discoveredPeripherals = [CBPeripheral]()
    @Published var connectedPeripheral: CBPeripheral?

    private var centralManager: CBCentralManager!
    var peripheralNames: [CBPeripheral: String] = [:] // Store names for peripherals
    private var characteristicToWrite: CBCharacteristic? // Store the writable characteristic

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
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        // Check if the peripheral has a local name
        if let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String, !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
            peripheralNames[peripheral] = localName // Store the name for display
            print("Discovered peripheral: \(localName)")
        }
    }

    
    // Connect to the selected peripheral
    func connect(to peripheral: CBPeripheral) {
        centralManager.stopScan()
        peripheral.delegate = self
        centralManager.connect(peripheral, options: nil)
        connectedPeripheral = peripheral
        print("Connecting to peripheral: \(peripheral.name ?? "Unknown")")
    }

    // Disconnect from the connected peripheral
    func disconnect(from peripheral: CBPeripheral) {
        centralManager.cancelPeripheralConnection(peripheral)
        print("Disconnected from peripheral: \(peripheral.name ?? "Unknown")")
        connectedPeripheral = nil
        characteristicToWrite = nil
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            print("Connected to peripheral: \(peripheral.name ?? "Unknown")")
            peripheral.discoverServices(nil) // Discover all services
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }

        guard let services = peripheral.services else { return }
        for service in services {
            print("Discovered service: \(service.uuid)")
            peripheral.discoverCharacteristics(nil, for: service) // Discover all characteristics
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }

        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            print("Discovered characteristic: \(characteristic.uuid)")
            if characteristic.properties.contains(.write) {
                characteristicToWrite = characteristic
                print("Writable characteristic found: \(characteristic.uuid)")
            }
        }
    }
    
    func toggleBluetooth() {
        if centralManager.state == .poweredOn {
            centralManager.stopScan()
            centralManager = nil
        } else {
            centralManager = CBCentralManager(delegate: self, queue: nil)
        }
    }
    
//    func toggleBluetooth() {
//        if centralManager.state == .poweredOn {
//            centralManager.stopScan()
//            isBluetoothEnabled = false
//            print("Bluetooth scanning stopped.")
//        } else {
//            centralManager = CBCentralManager(delegate: self, queue: nil)
//            print("Bluetooth scanning restarted.")
//        }
//    }

    
    // MARK: - Write Data to the Device

    // Function to send data to a connected peripheral
    // transmitting data
    func sendData(to peripheral: CBPeripheral, data: Data) {
            guard let characteristic = characteristicToWrite else {
                print("Characteristic not found")
                return
            }
            peripheral.writeValue(data, for: characteristic, type: .withResponse)
            print("Sent data to peripheral")
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
}
