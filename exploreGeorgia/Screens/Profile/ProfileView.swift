//
//  ProfileView.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import SwiftUI

struct ProfileView: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 40) {
        Spacer()
        
        ProfileStatistic()
        
        ProfileSettings()
      }
      .padding(.horizontal, 20)
    }
    .scrollIndicators(.hidden)
    .scrollBounceBehavior(.basedOnSize)
  }
}

#Preview {
  ProfileView()
}
