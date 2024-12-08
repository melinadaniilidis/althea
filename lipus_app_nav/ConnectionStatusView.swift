import SwiftUI

struct ConnectionStatusView: View {
    @Binding var isConnected: Bool

    var body: some View {
        HStack {
            Text(isConnected ? "Connected" : "Disconnected")
                .foregroundColor(isConnected ? .green : .red)
            Toggle("", isOn: $isConnected)
                .labelsHidden()
        }
        .padding()
    }
}

//import SwiftUI
//
//struct ConnectionStatusView: View {
////    @StateObject var bluetoothManager = BluetoothManager.shared
////    @Binding var isConnected: Bool
//    var bluetoothManager: BluetoothManager
//
//    var body: some View {
//        HStack {
//            Text(bluetoothManager.isConnected ? "Connected" : "Disconnected")
//                .foregroundColor(bluetoothManager.isConnected ? .green : .red)
//
//            Toggle("", isOn: Binding(
//                get: { bluetoothManager.isConnected },
//                set: { newValue in
//                    if !newValue {
//                        guard let peripheral = bluetoothManager.connectedPeripheral else {
//                            print("No connected peripheral to disconnect session.")
//                            return
//                        }
//                        bluetoothManager.disconnect(from: peripheral)
//                    }
//                }
//            ))
//            .labelsHidden()
//        }
//        .padding()
//    }
//}
