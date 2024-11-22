////
////  BTDetails.swift
////  lipus_app_nav
////
////  Created by Melina Daniilidis on 11/22/24.
////
//
//import SwiftUI
//import CoreBluetooth
//
//struct BTDetails: View {
//    @State var device: CBPeripheral // removed "private"
//
//    var body: some View {
//        VStack {
//            Text("Device Name: \(device.name ?? "Unknown Device")")
//            Text("UUID: \(device.identifier.uuidString)")
//            Button("Connect") {
//                BluetoothManager.shared.connect(to: device)
//            }
//        }
//    }
//}
//
//
////struct BTDetails_Previews: PreviewProvider {
////    static var previews: some View {
////        BTDetails(device: $0)
////    }
////}
