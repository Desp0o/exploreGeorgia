//
//  CoverUploadComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 17.01.25.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct CoverUploadComponent: View {
  var choosenCover: UIImage?
  @Binding var selectedCoverFromPicker: PhotosPickerItem?
  
    var body: some View {
      HStack(spacing: 20) {
        if let image = choosenCover {
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
        
        PhotosPicker(selection: $selectedCoverFromPicker) {
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
