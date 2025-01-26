//
//  AlbumAddComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 17.01.25.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct AlbumAddComponent: View {
  @ObservedObject var vm: AddPlaceViewModel
  
  var body: some View {
    VStack(spacing: 10) {
      PhotosPicker(selection: $vm.selectedAlbum, maxSelectionCount: 5) {
        Text("Tap to Upload Photos")
          .styledText(.customBlue, 16, .semibold)
          .frame(maxWidth: .infinity)
          .frame(height: 40)
          .background(.customWhite)
          .roundedCorners(12)
          .overlay(
            RoundedRectangle(cornerRadius: 12)
              .stroke(.customBlue, lineWidth: 1)
          )
      }
      
      HStack(spacing: 10) {
        ForEach(Array(vm.choosenAlbum.enumerated()), id: \.offset) { _, image in
          Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: 40, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
      }
    }
    .frame(height: 110, alignment: .top)
  }
}
