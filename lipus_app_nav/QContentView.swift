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
        // VAS
        Question(title: "Rank your level of pain on a scale of 1 to 10", answer: "A", options: [
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "10"
        ]),
            // Section 1: Pain Intensity
            Question(title: "Section 1—Pain intensity", answer: "A", options: [
                "I have no pain at the moment.",
                "The pain is very mild at the moment.",
                "The pain is moderate at the moment.",
                "The pain is fairly severe at the moment.",
                "The pain is very severe at the moment.",
                "The pain is the worst imaginable at the moment."
            ]),

            // Section 2: Personal Care
            Question(title: "Section 2—Personal care (washing, dressing, etc.)", answer: "A", options: [
                "I can look after myself normally without causing extra pain.",
                "I can look after myself normally but it causes extra pain.",
                "It is painful to look after myself and I am slow and careful.",
                "I need some help but manage most of my personal care.",
                "I need help every day in most aspects of self-care.",
                "I do not get dressed, I wash with difficulty and stay in bed."
            ]),

            // Section 3: Lifting
            Question(title: "Section 3—Lifting", answer: "A", options: [
                "I can lift heavy weights without extra pain.",
                "I can lift heavy weights but it gives extra pain.",
                "Pain prevents me from lifting heavy weights off the floor, but I can manage if they are conveniently placed, e.g., on a table.",
                "Pain prevents me from lifting heavy weights, but I can manage light to medium weights if they are conveniently positioned.",
                "I can lift very light weights.",
                "I cannot lift or carry anything at all."
            ]),

            // Section 4: Walking
            Question(title: "Section 4—Walking", answer: "A", options: [
                "Pain does not prevent me walking any distance.",
                "Pain prevents me from walking more than 1 mile.",
                "Pain prevents me from walking more than ½ mile.",
                "Pain prevents me from walking more than 100 yards.",
                "I can only walk using a stick or crutches.",
                "I am in bed most of the time."
            ]),

            // Section 5: Sitting
            Question(title: "Section 5—Sitting", answer: "A", options: [
                "I can sit in any chair as long as I like.",
                "I can only sit in my favorite chair as long as I like.",
                "Pain prevents me from sitting more than one hour.",
                "Pain prevents me from sitting more than 30 minutes.",
                "Pain prevents me from sitting more than 10 minutes.",
                "Pain prevents me from sitting at all."
            ]),

            // Section 6: Standing
            Question(title: "Section 6—Standing", answer: "A", options: [
                "I can stand as long as I want without extra pain.",
                "I can stand as long as I want but it gives me extra pain.",
                "Pain prevents me from standing for more than 1 hour.",
                "Pain prevents me from standing for more than 30 minutes.",
                "Pain prevents me from standing for more than 10 minutes.",
                "Pain prevents me from standing at all."
            ]),

            // Section 7: Sleeping
            Question(title: "Section 7—Sleeping", answer: "A", options: [
                "My sleep is never disturbed by pain.",
                "My sleep is occasionally disturbed by pain.",
                "Because of pain, I have less than 6 hours of sleep.",
                "Because of pain, I have less than 4 hours of sleep.",
                "Because of pain, I have less than 2 hours of sleep.",
                "Pain prevents me from sleeping at all."
            ]),

            // Section 8: Sex Life (if applicable)
            Question(title: "Section 8—Sex life (if applicable)", answer: "A", options: [
                "My sex life is normal and causes no extra pain.",
                "My sex life is normal but causes some extra pain.",
                "My sex life is nearly normal but is very painful.",
                "My sex life is severely restricted by pain.",
                "My sex life is nearly absent because of pain.",
                "Pain prevents any sex life at all."
            ]),

            // Section 9: Social Life
            Question(title: "Section 9—Social life", answer: "A", options: [
                "My social life is normal and gives me no extra pain.",
                "My social life is normal but increases the degree of pain.",
                "Pain has no significant effect on my social life apart from limiting my more energetic interests (e.g., sports).",
                "Pain has restricted my social life and I do not go out as often.",
                "Pain has restricted my social life to my home.",
                "I have no social life because of pain."
            ]),

            // Section 10: Travelling
            Question(title: "Section 10—Travelling", answer: "A", options: [
                "I can travel anywhere without pain.",
                "I can travel anywhere but it gives me extra pain.",
                "Pain is bad but I manage journeys over two hours.",
                "Pain restricts me to journeys of less than one hour.",
                "Pain restricts me to short necessary journeys under 30 minutes.",
                "Pain prevents me from travelling except to receive treatment."
            ])
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

struct ResultsView: View {
    let score: String
//    @Environment(\.presentationMode) var presentationMode // For dismissing modal

    var body: some View {
        VStack {
            Text("Results")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Text("Pain level: 6")
                .font(.title)
                .padding()

            Text("Oswestry score: 44% (severe disability)")
                .font(.title)
                .padding()
            
            Text("Treatment plan: 25 min. sessions, 3x per week")
                .font(.title)
                .padding()


            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true) // Hide the back button
    }
}


struct QContentView: View {
    @StateObject var manager = QManager()
    @State private var showResults = false

    var body: some View {
        NavigationView {
            VStack {
                TabView {
                    ForEach(manager.mockQuestions.indices, id: \.self) { index in
                        VStack {
                            Spacer()
                            QuestionView(question: $manager.mockQuestions[index])
                            Spacer()

                            if let lastQuestion = manager.mockQuestions.last,
                               lastQuestion.id == manager.mockQuestions[index].id {
                                Button {
                                    if manager.canSubmitQuiz() {
                                        showResults = true
                                    }
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

                NavigationLink(destination: ResultsView(score: manager.gradeQuiz()), isActive: $showResults) {
                    EmptyView()
                }
                .hidden()
            }
        }
    }
}


struct QContentView_Previews: PreviewProvider {
    static var previews: some View {
        QContentView()
    }
}

