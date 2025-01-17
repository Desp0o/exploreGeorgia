//
//  PlaceDetailsView.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import SwiftUI

struct PlaceDetailsView: View {
  @StateObject var vm = PlaceDetailsViewModel()
  @State var isLoaded = false
  @State var selectedImage = ""
  @State var isLightBoxVisible = false
  @State var isPresented = false
  @State var isBookmarked = false
  let elementID: String
  var collectionName: String

  var body: some View {
    VStack(spacing: 0) {
      if vm.currentPlace == nil {
        VStack {
          PlaceDetailsNavigationBar(
            isBookMarked: $isBookmarked,
            placeID: ""
          )
          Spacer()
          ProgressView()
            .tint(.customBlue)
          
          Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else {
        PlaceDetailsBGComponent(vm: vm)
          .overlay {
            VStack {
              PlaceDetailsNavigationBar(
                isBookMarked: $vm.isBookMarked,
                placeID: vm.currentPlace?.id ?? ""
              )
              
              Spacer()
            }
          }
        
        PlaceDetailsInfoComponent(
          vm: vm,
          selectedImage: $selectedImage,
          isLightBoxVisible: $isLightBoxVisible,
          isPresented: $isPresented,
          author: vm.author
        )
        .offset(y: -20)
      }
    }
    .background(.customWhite)
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
    .onAppear {
      vm.fetchSinglePlaceByID(with: elementID, and: collectionName)
    }
  }
}
