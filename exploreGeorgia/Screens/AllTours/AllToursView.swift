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
  @State private var pageSize = 10
  
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
              OverlayActionButtonIcon(iconName: .backButton, tint: .white)
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
          }
          
          if index == vm.fetchedData.count - 4 {
            Color.white.opacity(0)
              .frame(width: 1, height: 0)
              .onAppear {
                pageSize += 10
              }
          }
        }
      }
    }
    .padding(.horizontal, 20)
    .background(.primaryWhite)
    .onAppear {
      vm.fetchTours(pageSize: 10)
    }
    .onChange(of: pageSize) { _ in
      vm.fetchTours(pageSize: pageSize)
    }
  }
}

#Preview {
  AllToursView()
}
