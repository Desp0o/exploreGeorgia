//
//  ToutView.swift
//  exploreGeorgia
//
//  Created by Despo on 18.01.25.
//

import SwiftUI

struct TourView: View {
  @StateObject var vm = TourViewModel()
  let tourId: String
  
  var body: some View {
    ZStack(alignment: .top) {
      Color.primaryWhite.ignoresSafeArea()
      
      ScrollViewReader { proxy in
        ScrollView {
          VStack(spacing: 24) {
            TourCoverComponent()
            TourAlbumComponent()
            TourSummaryComponent()
            
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
                vm.fetchCreditCards()
                withAnimation(.easeInOut(duration: 0.2)) {
                  vm.isCalendarShown.toggle()
                }
                
                Task { @MainActor in
                  try? await Task.sleep(for: .seconds(0.1))
                  if vm.isCalendarShown {
                    withAnimation(.easeInOut) {
                      proxy.scrollTo("calendar", anchor: .bottom)
                    }
                  }
                }
              } label: {
                Text("Book now")
                  .styledText(.buttonPrimary, 20, .semibold)
                  .frame(width: 170, height: 42)
                  .background(.customGreen)
                  .roundedCorners(12)
              }
            }
           }
          .padding(.bottom, 30)
          
          if vm.isCalendarShown {
            TourBookingComponent()
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
        PlaceDetailsShimmer()
          .padding(.top, (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets.top ?? 0)
      }
      
      if vm.isLightBoxVisible {
        LightBoxViewReusable(
          selectedImage: $vm.selectedImage,
          isLightBoxVisible: $vm.isLightBoxVisible,
          album: vm.tour?.album ?? [""]
        )
        .ignoresSafeArea(.all)
      }
      
      if vm.isPaymentOpened {
        TourPurchaseComponent()
      }
      
      if vm.isSuccessfullyPurchased {
        TourSuccessComponent()
      }
    }
    .ignoresSafeArea()
    .onAppear {
      vm.fetchSingleTour(with: tourId, and: .tours)
    }
    .environmentObject(vm)
  }
}
