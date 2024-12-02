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
