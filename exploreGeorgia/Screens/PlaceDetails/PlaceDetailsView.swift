//
//  PlaceDetailsView.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import SwiftUI

struct PlaceDetailsView: View {
  @StateObject var vm = PlaceDetailsViewModel()
  let elementID: String
  @State var isLoaded = false
  @State var selectedImage = ""
  @State var isLightBoxVisible = false
  
  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        if vm.currentPlace == nil {
          ProgressView()
            .foregroundStyle(.customBlue)
        } else {
          PlaceDetailsBGComponent(vm: vm)
          
          PlaceDetailsInfoComponent(
            vm: vm,
            selectedImage: $selectedImage,
            isLightBoxVisible: $isLightBoxVisible
          )
          .offset(y: -20)
        }
      }
      .padding(.bottom, 30)
      .background(.customWhite)
      .ignoresSafeArea(.all)
      .overlay {
        if isLightBoxVisible {
          LightBoxViewReusable(
            selectedImage: $selectedImage,
            isLightBoxVisible: $isLightBoxVisible,
            album: vm.currentPlace?.album ?? []
          )
          .ignoresSafeArea(.all)
        }
      }
    }
    .onAppear {
      vm.fetchSinglePlaceByID(by: elementID)
    }
  }
}
