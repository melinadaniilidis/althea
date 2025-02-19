//
//  QuestionView.swift
//  lipus_app_nav
//
//  Created by Melina Daniilidis on 11/22/24.
//

import SwiftUI

struct Question : Identifiable, Decodable {
    let id: Int
    let createdAt: String
    let title: String
    let options: [String]
    var selection: String? // option selected for the question
}

struct QuestionView: View {
    @Binding var question: Question
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(question.title)
            ForEach(question.options, id: \.self) {option in
                HStack {
                    Button {
                        question.selection = option
                        print(option)
                    } label: {
                        if question.selection == option {
                            Circle()
                                .shadow(radius: 3)
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color("AppColor"))
                        } else {
                            Circle()
                                .stroke()
                                .shadow(radius: 3)
                                .frame(width: 20, height: 20)
                        }
                        
                    }
                    
                    Text(option)
                }
                .foregroundColor(Color(uiColor: .secondaryLabel))
                
            }
        }
        // box for the question:
        .padding(.horizontal, 5)
        .frame(width: 340, height: 460, alignment: .leading)
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(10)
        .shadow(color: Color(uiColor: .label).opacity(0.2), radius: 15)
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(question: .constant(Question(id: 1, createdAt: "", title: "Q1", options: ["A", "B", "C", "D"])))
    }
}
