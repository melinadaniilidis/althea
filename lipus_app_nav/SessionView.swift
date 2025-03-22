import SwiftUI

struct SessionView: View {
    @ObservedObject var sessionManager: SessionManager
    @Binding var isConnected: Bool
    @State private var nextSessionDate = "3/25/2025" // TODO: not hardcode this

    var body: some View {
        VStack {
            Text("Session Info")
                .font(.title)
                .fontWeight(.bold)
            
            // Connection Status and Battery
            HStack {
//                ConnectionStatusView(isConnected: $isConnected)
////                ConnectionStatusView(bluetoothManager: bluetoothManager)
//                Spacer()
            }
            .padding()

            // Current Session Box
            CurrentSessionBox(sessionManager: sessionManager, isConnected: isConnected)
//            CurrentSessionBox(sessionManager: sessionManager, bluetoothManager: bluetoothManager)
            .padding()

            // Next Session Box
            VStack {
                Text("Next Session:")
                    .font(.headline)
                HStack {
                    Text(nextSessionDate) // add style: .date for non-hardcoded version
                        .font(.title)
                        .foregroundColor(.purple)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))

            Spacer()
        }
        .padding()
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock SessionManager instance
        let mockSessionManager = SessionManager(bluetoothManager: BluetoothManager.shared)

        // Provide a Binding for isConnected
        let mockIsConnected = Binding.constant(true)
        
        return SessionView(sessionManager: mockSessionManager, isConnected: mockIsConnected)
            .preferredColorScheme(.dark)
    }
}
