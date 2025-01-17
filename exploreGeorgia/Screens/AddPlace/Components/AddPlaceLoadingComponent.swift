//
//  AddPlaceLoadingComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 17.01.25.
//

import SwiftUI

struct AddPlaceLoadingComponent: View {
    var body: some View {
      ZStack (alignment: .center) {
        VStack(spacing: 12) {
          Text("Sharing your memories...")
            .styledText(.customVine, 18, .semibold)
          
          ProgressView()
            .scaleEffect(2)
            .tint(.customVine)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(.black.opacity(0.7))
      .zIndex(3)
    }
}

#Preview {
    AddPlaceLoadingComponent()
}
