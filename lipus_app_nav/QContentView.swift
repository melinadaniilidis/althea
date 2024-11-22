//
//  QContentView.swift
//  lipus_app_nav
//
//  Created by Melina Daniilidis on 11/22/24.
//

import SwiftUI

// TODO: DB implementation

class QManager: ObservableObject {
    @Published var mockQuestions = [
        Question(title: "Q1", answer: "A", options: ["A", "B", "C", "D"]),
        Question(title: "Q2", answer: "A", options: ["A", "B", "C", "D"]),
        Question(title: "Q3", answer: "A", options: ["A", "B", "C", "D"]),
        Question(title: "Q4", answer: "A", options: ["A", "B", "C", "D"])
    ]
    
    func canSubmitQuiz() -> Bool {
        return mockQuestions.filter({$0.selection == nil}).isEmpty
    }
    
    func gradeQuiz() -> String {
        var correct: CGFloat = 0
        for question in mockQuestions {
            if question.answer == question.selection {
                correct += 1
            }
        }
        return "\((correct/CGFloat(mockQuestions.count))*100)%"
    }
}

struct QContentView: View {
    @StateObject var manager = QManager()
    
    var body: some View {
        TabView {
            ForEach(manager.mockQuestions.indices, id: \.self) { index in
                VStack {
                    Spacer()
                    QuestionView(question: $manager.mockQuestions[index])
                    Spacer()
                    
                    if let lastQuestion = manager.mockQuestions.last,
                           lastQuestion.id == manager.mockQuestions[index].id {
                        Button {
                            print(manager.canSubmitQuiz())
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
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

struct QContentView_Previews: PreviewProvider {
    static var previews: some View {
        QContentView()
    }
}
