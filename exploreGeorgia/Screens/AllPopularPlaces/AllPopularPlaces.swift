//
//  AllPopularPlaces.swift
//  exploreGeorgia
//
//  Created by Despo on 15.01.25.
//

import SwiftUI

struct AllPopularPlaces: View {
  @Environment(\.presentationMode) var dismiss
  @ObservedObject var vm = AllPopularViewModel()
  @State private var startingOpacity: CGFloat = 0
  
  var body: some View {
    ZStack {
      Color.primaryWhite.ignoresSafeArea()
      
      ScrollView {
        HStack {
          Button {
            dismiss.wrappedValue.dismiss()
          } label: {
            OverlayActionButtonIcon(iconName: .backButton)
          }
          
          Spacer()
          
          ScreenMainTitle(
            mainTitle: "Popular Destinations",
            subTitle: "Ready for travel?"
          )
          
          Spacer()
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        
        LazyVGrid(columns:[GridItem(), GridItem()], spacing: 20) {
          ForEach(vm.fetchedData.indices, id: \.self) { index in
            let place = vm.fetchedData[index]
            
            NavigationLink(
              destination: PlaceDetailsView(
                elementID: place.id ?? "",
                collectionName: .appPlace,
                isNavigationDisabled: true
              ).navigationBarHidden(
                true
              )
            ) {
              SightSeenReusableView(
                place: place,
                maxWidth: UIScreen.main.bounds.width / 2 - 40,
                height: 140,
                isBookmarkIconHidden: false
              )
              .opacity(startingOpacity)
              .onAppear {
                withAnimation(.easeOut(duration: 0.3)) {
                  startingOpacity = 1
                }
                
                if index == vm.fetchedData.count - 2 {
                  vm.fetchData()
                }
              }
            }
          }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
      }
      .scrollIndicators(.hidden)
    }
    .frame(maxWidth: .infinity)
    .overlay {
      if vm.isLoading {
        AllPopularPlacesShimmer()
      }
    }
  }
}
