//
//  MainUserComponet.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import SwiftUI

struct MainUserComponet: View {
  @ObservedObject var vm: MainViewModel
  
  var body: some View {
    HStack {
      HStack {
        CachedAsyncImage(url: URL(string: vm.user?.avatar ?? ""))
          .clipShape(Circle())
        .frame(width: 37, height: 37)
        
        Text(vm.user?.firstName ?? "")
          .styledText(
            .customBlack,
            14,
            .semibold
          )
      }
      .padding(.vertical, 6)
      .padding(.horizontal, 10)
      .background(.customWhite)
      .clipShape(Capsule())
      
      Spacer()
    }
  }
}

#Preview {
  let vm = MainViewModel()
  MainUserComponet(vm: vm)
}
