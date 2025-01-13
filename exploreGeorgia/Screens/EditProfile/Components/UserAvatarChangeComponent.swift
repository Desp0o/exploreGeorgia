//
//  UserAvatarChangeComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 10.01.25.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct UserAvatarChangeComponent: View {
  @ObservedObject var vm: EditProfileViewModel
  
  var body: some View {
    VStack(spacing: 20) {
      
      if let image = vm.choosenAvatar {
        Image(uiImage: image)
          .defaultOptions()
          .clipShape(Circle())
          .frame(width: 96, height: 96)
      } else {
        AsyncImage(url: URL(string: vm.currentAvatar)) { image in
          image
            .defaultOptions()
            .clipShape(Circle())
        } placeholder: {
          ProgressView()
        }
        .frame(width: 96, height: 96)
      }
      
      PhotosPicker(selection: $vm.selectedAvatarFromPicker) {
        Text("Tap to upload profile photo")
          .styledText(
            .customVine,
            18,
            .bold
          )
      }
    }
    
  }
}

#Preview {
  @ObservedObject var vm = EditProfileViewModel()
  UserAvatarChangeComponent(vm: vm)
}
