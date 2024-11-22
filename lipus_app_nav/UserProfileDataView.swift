//
//  UserProfileDataView.swift
//  lipus_app_nav
//
//  Created by Melina Daniilidis on 11/7/24.
//

import SwiftUI

//struct UserProfileDataView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}

struct UserProfileDataView: View {
    @State private var medicalHistory = "Medical history details here..."
    @State private var acuteInjuries = "Acute injuries details here..."
    @State private var pastProcedures = "Past procedures details here..."
    
    var body: some View {
        Form {
            Section(header: Text("Medical History")) {
                TextEditor(text: $medicalHistory)
                    .frame(height: 100)
            }
            Section(header: Text("Acute Injuries")) {
                TextEditor(text: $acuteInjuries)
                    .frame(height: 100)
            }
            Section(header: Text("Past Procedures")) {
                TextEditor(text: $pastProcedures)
                    .frame(height: 100)
            }
        }
        .navigationTitle("User Profile Data")
    }
}


struct UserProfileDataView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileDataView()
    }
}
