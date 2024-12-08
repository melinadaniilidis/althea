//
//  QManager.swift
//  lipus_app_nav
//
//  Created by Melina Daniilidis on 12/7/24.
//

import Foundation
import Supabase

class QManager: ObservableObject {
    @Published var questions = [Question]()
    @Published var quizResult = QResult(painLevel: 8, scorePercentage: 44, interpretation: "severe disability")
    @Published var quizPlan = TreatmentPlan(duration: 0, frequency: 0)
//    @Published var mockQuestions = [
        // VAS
//        Question(title: "Rank your level of pain on a scale of 1 to 10", answer: "A", options: [
//            "1",
//            "2",
//            "3",
//            "4",
//            "5",
//            "6",
//            "7",
//            "8",
//            "9",
//            "10"
//        ]),
//            // Section 1: Pain Intensity
//            Question(title: "Section 1—Pain intensity", answer: "A", options: [
//                "I have no pain at the moment.",
//                "The pain is very mild at the moment.",
//                "The pain is moderate at the moment.",
//                "The pain is fairly severe at the moment.",
//                "The pain is very severe at the moment.",
//                "The pain is the worst imaginable at the moment."
//            ]),
//
//            // Section 2: Personal Care
//            Question(title: "Section 2—Personal care (washing, dressing, etc.)", answer: "A", options: [
//                "I can look after myself normally without causing extra pain.",
//                "I can look after myself normally but it causes extra pain.",
//                "It is painful to look after myself and I am slow and careful.",
//                "I need some help but manage most of my personal care.",
//                "I need help every day in most aspects of self-care.",
//                "I do not get dressed, I wash with difficulty and stay in bed."
//            ]),
//
//            // Section 3: Lifting
//            Question(title: "Section 3—Lifting", answer: "A", options: [
//                "I can lift heavy weights without extra pain.",
//                "I can lift heavy weights but it gives extra pain.",
//                "Pain prevents me from lifting heavy weights off the floor, but I can manage if they are conveniently placed, e.g., on a table.",
//                "Pain prevents me from lifting heavy weights, but I can manage light to medium weights if they are conveniently positioned.",
//                "I can lift very light weights.",
//                "I cannot lift or carry anything at all."
//            ]),
//
//            // Section 4: Walking
//            Question(title: "Section 4—Walking", answer: "A", options: [
//                "Pain does not prevent me walking any distance.",
//                "Pain prevents me from walking more than 1 mile.",
//                "Pain prevents me from walking more than ½ mile.",
//                "Pain prevents me from walking more than 100 yards.",
//                "I can only walk using a stick or crutches.",
//                "I am in bed most of the time."
//            ]),
//
//            // Section 5: Sitting
//            Question(title: "Section 5—Sitting", answer: "A", options: [
//                "I can sit in any chair as long as I like.",
//                "I can only sit in my favorite chair as long as I like.",
//                "Pain prevents me from sitting more than one hour.",
//                "Pain prevents me from sitting more than 30 minutes.",
//                "Pain prevents me from sitting more than 10 minutes.",
//                "Pain prevents me from sitting at all."
//            ]),
//
//            // Section 6: Standing
//            Question(title: "Section 6—Standing", answer: "A", options: [
//                "I can stand as long as I want without extra pain.",
//                "I can stand as long as I want but it gives me extra pain.",
//                "Pain prevents me from standing for more than 1 hour.",
//                "Pain prevents me from standing for more than 30 minutes.",
//                "Pain prevents me from standing for more than 10 minutes.",
//                "Pain prevents me from standing at all."
//            ]),
//
//            // Section 7: Sleeping
//            Question(title: "Section 7—Sleeping", answer: "A", options: [
//                "My sleep is never disturbed by pain.",
//                "My sleep is occasionally disturbed by pain.",
//                "Because of pain, I have less than 6 hours of sleep.",
//                "Because of pain, I have less than 4 hours of sleep.",
//                "Because of pain, I have less than 2 hours of sleep.",
//                "Pain prevents me from sleeping at all."
//            ]),
//
//            // Section 8: Sex Life (if applicable)
//            Question(title: "Section 8—Sex life (if applicable)", answer: "A", options: [
//                "My sex life is normal and causes no extra pain.",
//                "My sex life is normal but causes some extra pain.",
//                "My sex life is nearly normal but is very painful.",
//                "My sex life is severely restricted by pain.",
//                "My sex life is nearly absent because of pain.",
//                "Pain prevents any sex life at all."
//            ]),
//
//            // Section 9: Social Life
//            Question(title: "Section 9—Social life", answer: "A", options: [
//                "My social life is normal and gives me no extra pain.",
//                "My social life is normal but increases the degree of pain.",
//                "Pain has no significant effect on my social life apart from limiting my more energetic interests (e.g., sports).",
//                "Pain has restricted my social life and I do not go out as often.",
//                "Pain has restricted my social life to my home.",
//                "I have no social life because of pain."
//            ]),
//
//            // Section 10: Travelling
//            Question(title: "Section 10—Travelling", answer: "A", options: [
//                "I can travel anywhere without pain.",
//                "I can travel anywhere but it gives me extra pain.",
//                "Pain is bad but I manage journeys over two hours.",
//                "Pain restricts me to journeys of less than one hour.",
//                "Pain restricts me to short necessary journeys under 30 minutes.",
//                "Pain prevents me from travelling except to receive treatment."
//            ])
//        ]
    let client = SupabaseClient(supabaseURL: URL(string: "https://wvabrtrfutkizrhdcytf.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind2YWJydHJmdXRraXpyaGRjeXRmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIzOTY2NDUsImV4cCI6MjA0Nzk3MjY0NX0.oP6tHdcY0xEMPYLcSfC9lZ_xr1cFT8zjtQhJAT8fcSM")
    
    init() {
        Task {
            do {
                let response = try await client.database.from("questionnaire").select().execute()
//                print("Raw Response:", response)
                let data = response.underlyingResponse.data
//                print("data: ", data)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let questions = try decoder.decode([Question].self, from: data)
//                print("Questions: ", questions)
//                print("Decoded Data:", String(data: data, encoding: .utf8) ?? "No data")
                await MainActor.run {
                    self.questions = questions
                }
            } catch {
                print("error fetching questions")
            }
        }
    }
    
    func canSubmitQuiz() -> Bool {
        return questions.filter({$0.selection == nil}).isEmpty
    }
    
    func gradeQuiz() {
        // store pain level to output in result
        var painLevel: Int? = nil
            if let firstQuestion = questions.first,
               let selection = firstQuestion.selection {
                painLevel = Int(selection) // Convert the selected string to an integer
            }
        
        // Total score accumulator
        var totalScore = 0
        let maxScore = (questions.count - 1) * 5 // Adjust max score to account for skipping the first question
        
        // Calculate the total score, starting from the second question
        for question in questions.dropFirst() {
            if let selection = question.selection, let selectionIndex = question.options.firstIndex(of: selection) {
                totalScore += selectionIndex // Map the selected string to its index
            }
        }
        
        // Calculate the score percentage
        let scorePercentage = ((Double(totalScore) / Double(maxScore)) * 100).rounded()
        
        // Determine the score interpretation
        let interpretation: String
        switch scorePercentage {
        case 0..<20:
            interpretation = "Minimal disability: The patient can cope with most living activities. Usually no treatment is indicated apart from advice on lifting, sitting, and exercise."
        case 21..<40:
            interpretation = "Moderate disability: The patient experiences more pain and difficulty with sitting, lifting, and standing. Travel and social life are more difficult, and they may be disabled from work."
        case 41..<60:
            interpretation = "Severe disability: Pain remains the main problem, but activities of daily living are affected. A detailed investigation is required."
        case 61..<80:
            interpretation = "Crippled: Back pain impinges on all aspects of the patient’s life. Positive intervention is required."
        case 81...100:
            interpretation = "These patients are either bed-bound or exaggerating their symptoms."
        default:
            interpretation = "Error in scoring calculation."
        }
        
        self.quizResult = QResult(painLevel: painLevel ?? 0, scorePercentage: Int(scorePercentage), interpretation: interpretation)
    }
    
    func resetQuiz() {
        self.questions = questions.map({Question(id: $0.id, createdAt: $0.createdAt, title: $0.title, options: $0.options, selection: nil)})
        self.quizPlan = TreatmentPlan(duration: 0, frequency: 0) // reset treatment plan
    }
    
    func fetchTreatmentPlan() async {
        let painLevel = quizResult.painLevel
        let oswestryRange = determineOswestryRange(scorePercentage: Double(quizResult.scorePercentage))
            
//        do {
//            let response = try await client.database
//                .from("treatment_lookup")
//                .select(columns: "duration, frequency")
//                .eq(column: "oswestry_range", value: oswestryRange)
//                .eq(column: "vas_range", value: painLevel)
//                .single()
//                .execute()
//
//            let data = response.underlyingResponse.data
//            let treatment = try JSONDecoder().decode(TreatmentPlan.self, from: data)
//            await MainActor.run {
//                self.quizPlan = treatment
//            }
//        } catch {
//            print("Error fetching treatment plan: \(error)")
//        }
        
        do {
            let response = try await client.database
                .from("treatment_lookup")
                .select(columns: "duration, frequency")
                .eq(column: "oswestry_range", value: oswestryRange)
                .eq(column: "vas_range", value: painLevel)
                .single()
                .execute()

            print("Query Response: \(response)") // Log the full response
            let data = response.underlyingResponse.data
            print("Raw Data: \(String(data: data, encoding: .utf8) ?? "Invalid data")") // Log raw JSON

            let treatment = try JSONDecoder().decode(TreatmentPlan.self, from: data)
            print("Decoded Treatment: \(treatment)") // Log the decoded treatment

            await MainActor.run {
                self.quizPlan = treatment // Update quizPlan
            }
        } catch {
            print("Error fetching treatment plan: \(error)")
            await MainActor.run {
                self.quizPlan = TreatmentPlan(duration: 0, frequency: 0) // Set default values
            }
        }

    }
    
    private func determineOswestryRange(scorePercentage: Double) -> String {
        switch scorePercentage {
        case 0..<20: return "0-20"
        case 21..<40: return "21-40"
        case 41..<60: return "41-60"
        case 61..<80: return "61-80"
        case 81...100: return "81-100"
        default: return "Unknown"
        }
    }
}

struct QResult {
    let painLevel: Int
    let scorePercentage: Int
    let interpretation: String
}

struct TreatmentPlan: Decodable {
    let duration: Int
    let frequency: Int
}
