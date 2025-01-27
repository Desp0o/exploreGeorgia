//
//  UserAvatarChangeComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 10.01.25.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct UserAvatarChangeComponent: View {
  @ObservedObject var vm = EditProfileViewModel()
  
  var body: some View {
    VStack(spacing: 20) {
      PhotosPicker(selection: $vm.selectedAvatarFromPicker) {
        ZStack(alignment: .bottomTrailing) {
          
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
          
          Image(systemName: "camera.fill")
            .renderingMode(.template)
            .scaleEffect(1.1)
            .foregroundStyle(.customBlue)
            .offset(x: 5, y: 5)
        }
      }
      .frame(alignment: .bottomTrailing)
    }
  }
}
