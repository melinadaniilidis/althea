//
//  ResultsView.swift
//  lipus_app_nav
//
//  Created by Melina Daniilidis on 12/7/24.
//

import SwiftUI

struct ResultsView: View {
    @Environment(\.dismiss) var dismiss
    @State var result: QResult
    @ObservedObject var manager: QManager // Observe manager for dynamic updates
    @State private var navigateToHome = false


    var body: some View {
        VStack {
            Text("Results")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Text("Pain level: \(result.painLevel)")
                .font(.title)
                .padding()
            
            Text("Oswestry score: \(result.scorePercentage)")
                .font(.title)
                .padding()
            
            Text("\(result.interpretation)")
            
            // Use `manager.quizPlan` directly
            Text("Treatment plan: \(manager.quizPlan.duration ) min. sessions, \(manager.quizPlan.frequency )x per week")
                .font(.title)
                .padding()
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Retake Questionnaire")
                    .padding()
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color("AppColor"))
                            .frame(width: 340)
                    )
            }
            .padding(.bottom, 10)
            
            NavigationLink(
                            destination: HomePageView(),
                            isActive: $navigateToHome
                        ) {
                            Button(action: {
                                navigateToHome = true
                            }) {
                                Text("Back to Home")
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .fill(Color.orange)
                                            .frame(width: 340)
                                    )
                            }
                        }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding(.bottom, 50)
        .navigationBarBackButtonHidden(true) // Hide default back button
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
//        ResultsView(result: .init(painLevel: 8, scorePercentage: 44, interpretation: "severe disability"), plan: .init(duration: 0, frequency: 0))
        ResultsView(result: .init(painLevel: 8, scorePercentage: 44, interpretation: "severe disability"), manager: QManager())
    }
}
