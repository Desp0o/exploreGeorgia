//
//  AllToursView.swift
//  exploreGeorgia
//
//  Created by Despo on 20.01.25.
//

import SwiftUI

struct AllToursView: View {
  @Environment(\.presentationMode) var dismiss
  @StateObject var vm = AllToursViewModel()
  
  var body: some View {
    ScrollView {
      HStack {
        Spacer()
        
        ScreenMainTitle(
          mainTitle: "Popular Tours",
          subTitle: "Your adventure awaits"
        )
        
        Spacer()
      }
      .padding(.vertical, 20)
      .overlay {
        HStack {
          Button {
            dismiss.wrappedValue.dismiss()
          } label: {
            ZStack {
              OverlayActionButtonIcon(iconName: .backButton)
            }
          }
          
          Spacer()
        }
      }
      
      LazyVStack(spacing: 20) {
        ForEach(vm.fetchedData.indices, id: \.self) { index in
          let currentTour = vm.fetchedData[index]
          
          NavigationLink {
            TourView(tourId: currentTour.id ?? "").navigationBarHidden(true)
          } label: {
            SingleTourFeedView(tour: currentTour, tourMaxWidth: .infinity, isBookButtonVisible: true)
              .onAppear {
                if index == vm.fetchedData.count - 2 {
                  vm.fetchTours()
                }
              }
          }
        }
      }
    }
    .padding(.horizontal, 20)
    .background(.primaryWhite)
    .overlay {
      if vm.isLoading {
        AllToursShimmer()
      }
    }
  }
}
