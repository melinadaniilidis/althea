////
////  BTDeviceList.swift
////  lipus_app_nav
////
////  Created by Melina Daniilidis on 11/22/24.
////
//
//import SwiftUI
//import CoreBluetooth
//
////extension CBPeripheral: Identifiable {
////    public var id: UUID {
////        return self.identifier
////    }
////}
//
//class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
//    static let shared = BluetoothManager() // Singleton instance (GPT solution)
//    @Published var isBluetoothEnabled = false
//    @Published var discoveredPeripherals = [CBPeripheral]()
//    private var centralManager: CBCentralManager!
//
//    override init() {
//        super.init()
//        centralManager = CBCentralManager(delegate: self, queue: nil)
//    }
//    
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        if central.state == .poweredOn {
//                    isBluetoothEnabled = true
//                    centralManager.scanForPeripherals(withServices: nil, options: nil)
//                } else {
//                    isBluetoothEnabled = false
//                }
//    }
//    
//    
//    // (don't know if we should have the function below
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//            if !discoveredPeripherals.contains(peripheral) {
//                discoveredPeripherals.append(peripheral)
//            }
//        }
//
//    
//    // scanning for devices
//    func startScanning() {
//        centralManager.scanForPeripherals(withServices: [CBUUID(string: "YOUR_SERVICE_UUID")])
//    }
//    
//    // connecting to a device
//    func connect(to peripheral: CBPeripheral) {
//        centralManager.connect(peripheral, options: nil)
//    }
//    
//    // transmitting data
//    func sendData(to peripheral: CBPeripheral, data: Data) {
//        let characteristicUUID = CBUUID(string: "YOUR_CHARACTERISTIC_UUID")
//        if let characteristic = findCharacteristic(with: characteristicUUID, for: peripheral) {
//            peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
//        } else {
//            print("Characteristic not found")
//        }
//    }
//    
//    // GPT solution to CBCharacteristicUUID() error
//    func findCharacteristic(with uuid: CBUUID, for peripheral: CBPeripheral) -> CBCharacteristic? {
//        guard let services = peripheral.services else { return nil }
//        for service in services {
//            if let characteristics = service.characteristics {
//                for characteristic in characteristics {
//                    if characteristic.uuid == uuid {
//                        return characteristic
//                    }
//                }
//            }
//        }
//        return nil
//    }
//
//
//}
//
//struct BTDeviceList: View {
//    @State private var devices: [CBPeripheral] = []
//
//    var body: some View {
//        List(devices, id: \.identifier) { device in
//            VStack(alignment: .leading) {
//                Text(device.name ?? "Unknown Device")
//                Text("UUID: \(device.identifier.uuidString)")
//            }
//        }
//        .onAppear {
//            BluetoothManager.shared.startScanning()
//        }
//    }
//}
//
//
//struct BTDeviceList_Previews: PreviewProvider {
//    static var previews: some View {
//        BTDeviceList()
//    }
//}
