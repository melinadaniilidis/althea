//import SwiftUI
//
//struct CurrentSessionBox: View {
//    var isConnected: Bool
//    var sessionTimeRemaining: Int
//
//    var body: some View {
//        VStack {
//            Text("Current Session")
//                .font(.largeTitle)
//                .foregroundColor(.white)
//            if isConnected {
//                VStack {
//                    Text("Time Remaining")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                    Text("\(sessionTimeRemaining / 60):\(String(format: "%02d", sessionTimeRemaining % 60))")
//                        .font(.largeTitle)
//                        .foregroundColor(.orange)
//                }
//            } else {
//                Text("--")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//        }
//        .padding()
//        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
//    }
//}

//import SwiftUI
//
//struct CurrentSessionBox: View {
//    var isConnected: Bool
//    @State private var isRunning: Bool = false // Tracks whether the timer is running
//    @State private var timeRemaining: Int = 600 // Example: 10 minutes in seconds
//
//    private var timer: Timer.TimerPublisher {
//        Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//    }
//
//    var body: some View {
//        VStack {
//            Text("Current Session")
//                .font(.headline)
//                .foregroundColor(.black)
//
//            if isConnected {
//                // Time Remaining View
//                Text("Time Remaining")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//
//                Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
//                    .font(.largeTitle)
//                    .foregroundColor(.orange)
//                    .onReceive(timer) { _ in
//                        if isRunning && timeRemaining > 0 {
//                            timeRemaining -= 1
//                        }
//                    }
//
//                // Start/Stop Button
//                Button(action: {
//                    if isRunning {
//                        stopSession()
//                    } else {
//                        startSession()
//                    }
//                }) {
//                    Text(isRunning ? "STOP" : "START")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(isRunning ? Color.red : Color.green)
//                        .cornerRadius(10)
//                }
//                .padding(.top, 10)
//            } else {
//                Text("Connect to start a session")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//        }
//        .padding()
//        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
//    }
//
//    // Start the session
//    private func startSession() {
//        isRunning = true
//    }
//
//    // Stop the session
//    private func stopSession() {
//        isRunning = false
//    }
//}

//import SwiftUI
//
//struct CurrentSessionBox: View {
//    var isConnected: Bool
//    @State private var isRunning: Bool = false // Tracks whether the timer is running
//    @State private var timeRemaining: Int = 1500 // Example: 25 minutes in seconds
//
//    var body: some View {
//        VStack {
//            Text("Current Session")
//                .font(.headline)
//                .foregroundColor(.white)
//
//            if isConnected {
//                // Time Remaining View
//                Text("Time:")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//
//                Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
//                    .font(.largeTitle)
//                    .foregroundColor(.orange)
//                    .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
//                        if isRunning && timeRemaining > 0 {
//                            timeRemaining -= 1
//                        }
//                    }
//
//                // Start/Stop Button
//                Button(action: {
//                    if isRunning {
//                        stopSession()
//                    } else {
//                        startSession()
//                    }
//                }) {
//                    Text(isRunning ? "STOP" : "START")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(isRunning ? Color.red : Color.green)
//                        .cornerRadius(10)
//                }
//                .padding(.top, 10)
//            } else {
//                Text("Connect to start a session")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//        }
//        .padding()
//        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
//    }
//
//    // Start the session
//    private func startSession() {
//        isRunning = true
//    }
//
//    // Stop the session
//    private func stopSession() {
//        isRunning = false
//    }
//}

import SwiftUI
import Combine

// SessionManager Class
class SessionManager: ObservableObject {
    @Published var isRunning: Bool = false
    @Published var timeRemaining: Int = 1500 // Example: 10 minutes in seconds

    private var timerCancellable: AnyCancellable?

    func startSession() {
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

            if isConnected {
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
            } else {
                Text("Connect to start a session")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
    }
}
