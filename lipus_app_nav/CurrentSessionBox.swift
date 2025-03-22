import SwiftUI
import Combine

// SessionManager Class
class SessionManager: ObservableObject {
    @Published var isRunning: Bool = false
    @Published var timeRemaining: Int = 0 // Default 0 min

    private var timerCancellable: AnyCancellable?
    var bluetoothManager: BluetoothManager
    
    static let shared = SessionManager(bluetoothManager: BluetoothManager.shared)
    
    init(bluetoothManager: BluetoothManager) {
        self.bluetoothManager = bluetoothManager
    }
        
    // Function to update timeRemaining dynamically
    func updateDuration(from quizPlan: TreatmentPlan) {
        self.timeRemaining = quizPlan.duration * 60
    }
    

    func startSession() {
        guard !isRunning, let peripheral = bluetoothManager.connectedPeripheral else {
            print("No connected peripheral to start session.")
            return
        }
        
        // Send start signal to the peripheral
        let startCommand = "START".data(using: .utf8)!
        bluetoothManager.sendData(to: peripheral, data: startCommand)
        
        if !isRunning {
            isRunning = true
            timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    if self.timeRemaining > 0 {
                        self.timeRemaining -= 1
                    } else {
                        self.stopSession()
                    }
                }
        }
    }

    func stopSession() {
        guard isRunning, let peripheral = bluetoothManager.connectedPeripheral else {
            print("No active session to stop.")
            return
        }
        
        // Send stop signal to the peripheral
        let stopCommand = "STOP".data(using: .utf8)!
        bluetoothManager.sendData(to: peripheral, data: stopCommand)
        
        isRunning = false
        timerCancellable?.cancel()
        timerCancellable = nil
    }
}

// CurrentSessionBox View
struct CurrentSessionBox: View {
    @ObservedObject var sessionManager: SessionManager
    var isConnected: Bool

    var body: some View {
        VStack {
            Text("Current Session")
                .font(.headline)
                .foregroundColor(.white)
            
//            if bluetoothManager.isConnected {
//            if isConnected {
                // Time Remaining View
                Text("Time:")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text("\(sessionManager.timeRemaining / 60):\(String(format: "%02d", sessionManager.timeRemaining % 60))")
                    .font(.largeTitle)
                    .foregroundColor(.orange)

                // Start/Stop Button
                Button(action: {
                    if sessionManager.isRunning {
                        sessionManager.stopSession()
                    } else {
                        sessionManager.startSession()
                    }
                }) {
                    Text(sessionManager.isRunning ? "STOP" : "START")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(sessionManager.isRunning ? Color.red : Color.green)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
//            } else {
//                Text("Connect to start a session")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
    }
}
