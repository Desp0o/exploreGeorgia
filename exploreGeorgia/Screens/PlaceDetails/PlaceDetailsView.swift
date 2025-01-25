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
  let collectionName: FirebaseCollectionEnum

  var body: some View {
    VStack(spacing: 0) {
      if vm.currentPlace == nil {
        VStack {
          PlaceDetailsNavigationBar(
            isBookMarked: $vm.isBookmarked,
            placeID: ""
          )
          Spacer()
          ProgressView()
            .tint(.customBlue)
          
          Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else {
        PlaceDetailsBGComponent(cover: vm.currentPlace?.cover ?? "")
          .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.50)
          .clipped()
          .overlay {
            VStack {
              PlaceDetailsNavigationBar(
                isBookMarked: $vm.isBookmarked,
                placeID: vm.currentPlace?.id ?? ""
              )
              
              Spacer()
            }
          }
        
        Spacer()
      }
    }
    .background(.customWhite)
    .ignoresSafeArea(.all)
    .overlay {
      VStack {
        Spacer()
        PlaceDetailsInfoComponent()
          .frame(maxWidth: .infinity)
          .frame(height: UIScreen.main.bounds.height * 0.50)
      }
    }
    .overlay {
      if vm.isLightBoxVisible {
        LightBoxViewReusable(
          selectedImage: $vm.selectedImage,
          isLightBoxVisible: $vm.isLightBoxVisible,
          album: vm.currentPlace?.album ?? []
        )
        .ignoresSafeArea(.all)
      }
    }
    .sheet(isPresented: $vm.isPresented) {
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
    .environmentObject(vm)
  }
}
