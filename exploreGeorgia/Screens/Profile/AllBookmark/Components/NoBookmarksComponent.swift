//
//  NoBookmarksComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 22.01.25.
//

import SwiftUI

struct NoBookmarksComponent: View {
  var body: some View {
    VStack(alignment: .center){
      
      Text("Your Bucket List Awaits...")
        .styledText(.customGreen, 16, .semibold)
        .padding(.bottom, 40)
    }
    .frame(height: UIScreen.main.bounds.height / 2 + 80)
  }
}

#Preview {
  NoBookmarksComponent()
}
