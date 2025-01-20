//
//  ToutView.swift
//  exploreGeorgia
//
//  Created by Despo on 18.01.25.
//

import SwiftUI

struct TourView: View {
  @StateObject var vm = TourViewModel()
  @State var selectedImage = ""
  @State var isLightBoxVisible = false
  @State var isCalendarShown = false
  @State var selectedDate: Date = Date()
  @State private var pickedPlaces = 0
  let startingDate: Date = Date()
  let tourId: String
  
  var body: some View {
    ZStack(alignment: .top) {
      Color.primaryWhite.ignoresSafeArea()
      
      ScrollViewReader { proxy in
        ScrollView {
          VStack(spacing: 24) {
            TourCoverComponent(vm: vm, isBookMarked: $vm.isBookMarked)
            
            TourAlbumComponent(
              vm: vm,
              isLightBoxVisible: $isLightBoxVisible,
              selectedImage: $selectedImage
            )
            
            TourSummaryComponent(vm: vm)
            
            Spacer()
              .frame(minHeight: 50)
            
            HStack {
              HStack(spacing: 0) {
                Text("₾\(vm.tour?.price ?? 0)")
                  .styledText(.customBlack, 24, .semibold)
                Text(" /day")
                  .styledText(.customGray, 14)
              }
              
              Spacer()
              
              Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                  isCalendarShown.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                  if isCalendarShown {
                    withAnimation {
                      proxy.scrollTo("calendar", anchor: .bottom)
                    }
                  }
                }
              } label: {
                Text("Book now")
                  .styledText(.buttonPrimary, 20, .semibold)
                  .frame(width: 170, height: 42)
                  .background(.customBlue)
                  .roundedCorners(12)
              }
            }
            .padding(.horizontal, 20)
          }
          .padding(.bottom, 30)
          
          if isCalendarShown {
            TourBookingComponent(
              vm: vm,
              selectedDate: $selectedDate,
              pickedPlaces: $pickedPlaces,
              startingDate: startingDate
            )
          }
          
          Spacer()
            .frame(height: 50)
            .id("calendar")
          
        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
      }
    }
    .overlay {
      if vm.isLoading {
        ZStack {
          Color.primaryWhite.ignoresSafeArea()
          
          ProgressView()
            .scaleEffect(1.5)
            .tint(.customBlue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      
      if isLightBoxVisible {
        LightBoxViewReusable(
          selectedImage: $selectedImage,
          isLightBoxVisible: $isLightBoxVisible,
          album: vm.tour?.album ?? [""]
        )
        .ignoresSafeArea(.all)
      }
    }
    .ignoresSafeArea()
    .onAppear {
      vm.fetchSingleTour(with: tourId, and: "tours")
    }
  }
}
