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
  let isNavigationDisabled: Bool
  
  var body: some View {
    VStack(spacing: 0) {
      PlaceDetailsBGComponent(cover: vm.currentPlace?.cover ?? "")
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.50)
        .clipped()
      Spacer()
    }
    .background(.customWhite)
    .ignoresSafeArea(.all)
    .overlay {
      VStack {
        if vm.isError {
          FetchErrorComponentReusable()
            .ignoresSafeArea()
        } else {
          Spacer()
          PlaceDetailsInfoComponent(isNavigationDisabled: isNavigationDisabled)
            .frame(maxWidth: .infinity)
            .frame(height: UIScreen.main.bounds.height * 0.55)
        }
      }
    }
    .overlay {
      VStack {
        PlaceDetailsNavigationBar(
          isBookMarked: $vm.isBookmarked,
          placeID: vm.currentPlace?.id ?? ""
        )
        
        Spacer()
      }
      .padding(.top, 10)
      .ignoresSafeArea()
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
    .overlay {
      if vm.isLoading {
          PlaceDetailsShimmer()
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
