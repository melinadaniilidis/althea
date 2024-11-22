////
////  BTContentView.swift
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
//struct IdentifiablePeripheral: Identifiable {
//    let id = UUID()
//    let peripheral: CBPeripheral
//}
//
//struct BTContentView: View {
//    @State private var selectedDevice: IdentifiablePeripheral?
//
//    var body: some View {
//        NavigationView {
//            BTDeviceList()
//                .navigationTitle("Devices")
//                .sheet(item: $selectedDevice) {
//                    BTDetails(device: $0.peripheral)
//                }
//        }
//    }
//}
//
//struct BTContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        BTContentView()
//    }
//}
