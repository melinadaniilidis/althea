//
//  PainDiagnosticsView.swift
//  lipus_app_nav
//
//  Created by Melina Daniilidis on 11/7/24.
//

import SwiftUI // NOTE: SwiftUI for iOS 13 or later. UIKit for older versions
import Charts

struct PainData: Identifiable {
    let id = UUID()
    let month: String
    let day: Int
    let painLevel: Int
}

let months = ["Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"]



//var sampleData: [PainData] = [
//    .init(month: "Nov", day: 1, painLevel: 5),
//    .init(month: "Nov", day: 2, painLevel: 6),
//    .init(month: "Nov", day:10, painLevel: 4),
//    .init(month: "Nov",day: 15, painLevel: 7),
//    .init(month: "Nov",day: 20, painLevel: 8),
//    .init(month: "Nov",day: 30, painLevel: 5),
//    .init(month: "Dec", day: 1, painLevel: 4),
//    .init(month: "Dec", day: 2, painLevel: 6),
//    .init(month: "Dec", day:10, painLevel: 8),
//    .init(month: "Dec",day: 15, painLevel: 6),
//    .init(month: "Dec",day: 20, painLevel: 2),
//    .init(month: "Dec",day: 30, painLevel: 3)]

struct PainDiagnosticsView: View {
    @State private var selectedMonth: String = "Mar" // TODO: use built-in date/time features to display current time
    @State private var sampleData: [PainData] = []
    
//        private var months: [String] {
//            Array(Set(sampleData.map { $0.month })).sorted() // Unique, sorted list of months
//        }
        
    private var filteredData: [PainData] {
        sampleData.filter { $0.month == selectedMonth }
    }
    
    var body: some View {
        VStack {
            Text("Pain Diagnostics")
                .font(.title)
                .fontWeight(.bold)
            
            // Dropdown menu for selecting a month
            Menu {
                ForEach(months, id: \.self) { month in
                    Button(action: {
                        selectedMonth = month
                    }) {
                        Text(month)
                        }
                }
            } label: {
                HStack {
                    Text("Month: \(selectedMonth)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.blue)
                        .cornerRadius(8)
                    Spacer()
                }
                .frame(maxWidth: 150)
            }
            .padding(.leading)

            Chart(filteredData) { entry in
                LineMark(
                    x: .value("Day", entry.day),
                    y: .value("Pain Level", entry.painLevel)
                )
                .foregroundStyle(.blue)
                .interpolationMethod(.linear) // Smooths out the line

            }
            .chartXAxis {
                AxisMarks(values: Array(stride(from: 1, through: 31, by: 5))) { value in
                    AxisValueLabel()
                        .font(.system(size: 14, weight: .bold))
                }
            }
            .chartXAxisLabel(position: .bottom, alignment: .center) {
                Text("Day")
                    .font(.system(size: 16, weight: .bold))
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: Array(stride(from: 0, through: 10, by: 1))) { value in
                    AxisValueLabel()
                        .font(.system(size: 14, weight: .bold))
                }
            }
            .chartYAxisLabel(position: .leading, alignment: .center) {
                Text("Pain level")
                    .font(.system(size: 16, weight: .bold))
                    .rotationEffect(.degrees(180))
                    .fixedSize() // Prevents the label from being stretched
                    .frame(width: 20, height: 20)
            }
            .frame(height: 250) // Adjust height as needed
            .padding()
            Spacer()

        }
        .padding()
        .onAppear {
            generateRandomData()
        }


    }
    
    // Function to generate random data points
    private func generateRandomData() {

            let monthPainLevels: [String: Int] = [

                "Jan": 8,  // High pain levels in January

                "Feb": 6,  // Decrease in February

                "Mar": 4,  // Further decrease in March

                "Apr": 2   // Lowest pain levels in April

            ]

            

            var currentPainLevel = 8 // Start high in January

            

            sampleData = months.flatMap { month in

                (1...31).compactMap { day in

                    guard Int.random(in: 0...3) != 0 else { return nil } // Skip some days to simulate missing data

                    

                    if let basePainLevel = monthPainLevels[month] {

                        // Ensure a steady decrease from Jan to Apr

                        currentPainLevel = max(0, min(10, basePainLevel + Int.random(in: -1...0)))

                    } else {

                        // Random fluctuations for other months

                        let painLevelChange = Int.random(in: -1...1) // Small change in pain level

                        currentPainLevel = max(0, min(10, currentPainLevel + painLevelChange))

                    }

                    

                    return PainData(

                        month: month,

                        day: day,

                        painLevel: currentPainLevel

                    )

                }

            }

        }
//    private func generateRandomData() {
//        var currentPainLevel = Int.random(in: 2...7) // Start with a moderate pain level
//
//        sampleData = months.flatMap { month in
//            (1...31).compactMap { day in
//                // Only include days before the 4th for December
//                if month == "Dec" && day >= 4 {
//                    return nil
//                }
//
//                guard Int.random(in: 0...3) != 0 else { return nil } // Skip some days to simulate missing data
//                let painLevelChange = Int.random(in: -1...1) // Small change in pain level
//                currentPainLevel = max(0, min(10, currentPainLevel + painLevelChange)) // Ensure pain level stays between 0 and 10
//                return PainData(
//                    month: month,
//                    day: day,
//                    painLevel: currentPainLevel
//                )
//            }
//        }
//    }
}

struct PainDiagnosticsView_Previews: PreviewProvider {
    static var previews: some View {
        PainDiagnosticsView()
    }
}
