//
//  PlaceDetailsBGComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import SwiftUI

struct PlaceDetailsBGComponent: View {
  let cover: String
  
  var body: some View {
    VStack {
      CachedAsyncImage(url: URL(string: cover))
        .frame(maxWidth: .infinity)
    }
  }
}
