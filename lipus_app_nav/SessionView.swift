import SwiftUI

struct SessionView: View {
    @ObservedObject var sessionManager: SessionManager
    @Binding var isConnected: Bool
//    var sessionTimeRemaining: Int

//    @State private var isPaused = false
//    @State private var nextSessionDate = Date()
    @State private var nextSessionDate = "12/6/2024"

    var body: some View {
        VStack {
            Text("Session Info")
                .font(.title)
                .fontWeight(.bold)
            
            // Connection Status and Battery
            HStack {
                ConnectionStatusView(isConnected: $isConnected)
                Spacer()
//                Image(systemName: "battery.100") // Replace with actual battery status
//                    .foregroundColor(.green)
            }
            .padding()

            // Current Session Box
//            CurrentSessionBox(isConnected: isConnected, sessionTimeRemaining: sessionTimeRemaining)
//            CurrentSessionBox(isConnected: isConnected)
//                .padding()
            CurrentSessionBox(sessionManager: sessionManager, isConnected: isConnected)
                            .padding()

            // Pause Button
//            Button(action: {
//                isPaused.toggle()
//            }) {
//                Text(isPaused ? "RESUME" : "PAUSE")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(isPaused ? Color.green : Color.red)
//                    .cornerRadius(10)
//            }
//            .padding()

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
//                    Button(action: {
//                        // Logic for editing next session date
//                    }) {
//                        Text("Edit")
//                            .foregroundColor(.blue)
//                            .underline()
//                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))

            Spacer()
        }
        .padding()
    }
}



//struct SessionView_Previews: PreviewProvider {
//    static var previews: some View {
//        SessionView().preferredColorScheme(.dark)
//    }
//}
