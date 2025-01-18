//
//  TourAlbumComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 18.01.25.
//

import SwiftUI

struct TourAlbumComponent: View {
  @ObservedObject var vm: TourViewModel
  @Binding var isLightBoxVisible: Bool
  @Binding var selectedImage: String
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack(spacing: 12) {
        ForEach(vm.tour?.album ?? [""], id: \.self) { image in
          CachedAsyncImage(url: URL(string: image))
            .frame(width: 52, height: 52)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .onTapGesture {
              selectedImage = image
              isLightBoxVisible = true
            }
        }
      }
      .padding(.horizontal, 10)
    }
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(Color.customWhite)
    )
    .padding(.horizontal, 20)
    .frame(height: 76)
    .frame(maxWidth: .infinity)
  }
}
