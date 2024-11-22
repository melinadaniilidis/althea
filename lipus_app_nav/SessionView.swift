//
//  SessionView.swift
//  lipus_app_nav
//
//  Created by Melina Daniilidis on 11/8/24.
//

import SwiftUI

struct SessionView: View {
    var body: some View {
        VStack {
            Text("Current Session")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
                
        }
        .padding()
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView().preferredColorScheme(.dark)
    }
}
