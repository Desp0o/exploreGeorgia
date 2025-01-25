//
//  CoverUploadComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 17.01.25.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct CoverUploadComponent: View {
  @ObservedObject var vm: AddPlaceViewModel
  
    var body: some View {
      HStack(spacing: 20) {
        if let image = vm.choosenCover {
          Image(uiImage: image)
            .defaultOptions()
            .frame(width: 40, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        } else {
          Image("imagePlaceholder")
            .defaultOptions()
            .frame(width: 40, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        
        Spacer()
        
        PhotosPicker(selection: $vm.selectedCoverFromPicker) {
          Text("Upload Cover")
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
      }
    }
}
