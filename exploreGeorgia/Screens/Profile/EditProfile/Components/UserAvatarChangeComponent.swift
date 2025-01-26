//
//  UserAvatarChangeComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 10.01.25.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct UserAvatarChangeComponent: View {
  @EnvironmentObject var vm: EditProfileViewModel
  
  var body: some View {
    VStack(spacing: 20) {
      if let image = vm.choosenAvatar {
        Image(uiImage: image)
          .defaultOptions()
          .clipShape(Circle())
          .frame(width: 96, height: 96)
      } else {
        CachedAsyncImage(url: URL(string: vm.currentAvatar))
          .clipShape(Circle())
          .frame(width: 96, height: 96)
      }
      
      PhotosPicker(selection: $vm.selectedAvatarFromPicker) {
        Text("Tap to upload profile photo")
          .styledText(.customBlue, 18, .bold)
      }
    }
    .padding(.top, 40)
  }
}
