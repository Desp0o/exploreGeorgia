//
//  FoodViewSingleComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 24.01.25.
//

import SwiftUI

struct FoodViewSingleComponent: View {
  let cover: String
  let name: String
  let type: String
  
    var body: some View {
      VStack {
        
          CachedAsyncImage(url: URL(string: cover))
          .frame(height: 140)
          .roundedCorners(12)
          .shadow(color: .black.opacity(0.25), radius: 4, y: 2)

        HStack {
          Text(name)
            .styledText(.customBlack, 16, .bold)

          Spacer()

          Text(type)
            .styledText(.customBlack, 13, .semibold)
            .padding(4)
            .background(.customVine)
            .roundedCorners(5)
        }
        
      }
    }
}

#Preview {
  let cover: String = "https://glovo.dhmedia.io/image/stores-glovo/stores/937e4015255efca155264a9fd734d3fb4e97658806b2114b9504399a81f68193?t=W3siYXV0byI6eyJxIjoibG93In19LHsicmVzaXplIjp7Im1vZGUiOiJmaWxsIiwiYmciOiJ0cmFuc3BhcmVudCIsIndpZHRoIjo1ODgsImhlaWdodCI6MzIwfX1d"
  let name: String = "Tsikvili"
  let type: String = "National"
  FoodViewSingleComponent(cover: cover, name: name, type: type)
}
