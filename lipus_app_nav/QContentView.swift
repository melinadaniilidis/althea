//
//  QContentView.swift
//  lipus_app_nav
//
//  Created by Melina Daniilidis on 11/22/24.
//

import SwiftUI

// TODO: DB implementation

struct QContentView: View {
    @State var selection = 0
    @StateObject var manager = QManager()
    @State var showResults = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Questionnaire")
                    .font(.title)
                    .fontWeight(.bold)
                
                TabView(selection: $selection) {
                    ForEach(manager.questions.indices, id: \.self) { index in
                        VStack {
                            Spacer()
                            QuestionView(question: $manager.questions[index])
                            Spacer()

                            if let lastQuestion = manager.questions.last,
                               lastQuestion.id == manager.questions[index].id {
                                Button {
                                    manager.gradeQuiz()
                                    print("called gradQuiz")
                                    
                                    // Call fetchTreatmentPlan asynchronously
                                    Task {
                                        print("about fetch treatment plan")
                                        await manager.fetchTreatmentPlan()
                                        print("fetched treatment plan")
                                    }
//                                    Task {
//                                            await manager.fetchTreatmentPlan()
//
//                                            if let plan = manager.quizPlan {
//                                                // Navigate to ResultsView only after fetch completes
//                                                navigationPath.append(
//                                                    ResultsView(result: manager.quizResult, manager: manager)
//                                                )
//                                            }
                                    
                                    showResults = true
                                    manager.resetQuiz()
                                    selection = 0
                                } label: {
                                    Text("Submit")
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                .fill(Color("AppColor"))
                                                .frame(width: 340)
                                        )
                                }
                                .buttonStyle(.plain)
                                .disabled(!manager.canSubmitQuiz())
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
//                .navigationDestination(isPresented: $showResults) {
//                                ResultsView(result: manager.quizResult, manager: manager)
//                            }
//
//                .fullScreenCover(isPresented: $showResults) { ResultsView(result: manager.quizResult, plan: manager.quizPlan)
//                }
//                .fullScreenCover(isPresented: $showResults) { ResultsView(result: manager.quizResult, manager: manager)
//                }
                .fullScreenCover(isPresented: $showResults) {
                    NavigationStack {
                        ResultsView(result: manager.quizResult, manager: manager)
                    }
                }
            }
            .padding(.bottom, 20)
        }
    }
}


struct QContentView_Previews: PreviewProvider {
    static var previews: some View {
        QContentView()
    }
}

