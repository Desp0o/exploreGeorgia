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
  @State private var isSomethingChanged = false
  @State private var startingOpacity: CGFloat = 0
  @State private var lastSelectedID: String?
  @State private var pageSize = 10
  
  var body: some View {
    ZStack {
      Color.primaryWhite.ignoresSafeArea()
      
      ScrollViewReader { proxy in
        ScrollView {
          HStack {
            Button {
              dismiss.wrappedValue.dismiss()
            } label: {
              OverlayActionButtonIcon(iconName: IconsEnum.backButton.rawValue, tint: .white)
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
                  collectionName: .appPlace
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
                }
              }
              .onTapGesture {
                lastSelectedID = place.id
              }
              if index == vm.fetchedData.count - 1 {
                Color.clear
                  .onAppear {
                    pageSize += 10
                  }
              }
            }
          }
          .padding(.horizontal, 20)
          .padding(.bottom, 20)
          .id(vm.fetchedData)
          .id(isSomethingChanged)
        }
        .scrollIndicators(.hidden)
        .onAppear {
          if let id = lastSelectedID {
            proxy.scrollTo(id, anchor: .leading)
          }
        }
      }
    }
    .frame(maxWidth: .infinity)
    .overlay {
      if vm.isLoading {
        ZStack {
          Color.primaryWhite.ignoresSafeArea()
          
          ProgressView()
            .scaleEffect(1.5)
            .tint(.customBlue)
        }
      }
    }
    .onAppear {
      isSomethingChanged.toggle()
      vm.fetchData(pageSize: pageSize)
    }
    .onChange(of: pageSize) { _ in
      vm.fetchData(pageSize: pageSize)
    }
  }
}

#Preview {
  AllPopularPlaces()
}
