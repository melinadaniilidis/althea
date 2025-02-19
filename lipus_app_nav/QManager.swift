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

    let client = SupabaseClient(supabaseURL: URL(string: "https://wvabrtrfutkizrhdcytf.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind2YWJydHJmdXRraXpyaGRjeXRmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIzOTY2NDUsImV4cCI6MjA0Nzk3MjY0NX0.oP6tHdcY0xEMPYLcSfC9lZ_xr1cFT8zjtQhJAT8fcSM")
    
    init() {
        Task {
            do {
                let response = try await client.database.from("questionnaire").select().execute()
                let data = response.underlyingResponse.data
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let questions = try decoder.decode([Question].self, from: data)
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
