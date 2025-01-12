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
  @State var isPresented = false
  
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
            isLightBoxVisible: $isLightBoxVisible,
            isPresented: $isPresented
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
      .sheet(isPresented: $isPresented) {
        MapViewReusable(
          latitudeProp: Double(vm.currentPlace?.latitude ?? 0),
          longitudeProp: Double(vm.currentPlace?.longitude ?? 0),
          locationName: vm.currentPlace?.name ?? "",
          isEditable: false
        )
      }
    }
    .onAppear {
      vm.fetchSinglePlaceByID(by: elementID)
    }
  }
}
