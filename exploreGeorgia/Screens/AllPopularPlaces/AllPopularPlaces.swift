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
  @State private var scale: CGFloat = 0.0
  @State private var lastSelectedID: String?
  @State private var pageSize = 10
  
  var body: some View {
    ZStack {
      Color.primaryWhite.ignoresSafeArea()
      
      VStack {
        HStack {
          Button {
            dismiss.wrappedValue.dismiss()
          } label: {
            ZStack {
              Circle()
                .fill(.customWhite.opacity(0.5))
                .frame(width: 40, height: 40)
              
              Image("backArrow")
                .renderingMode(.template)
                .foregroundStyle(.white)
            }
          }
          
          Spacer()
        }
        .padding(.horizontal, 20)
        
        ScrollViewReader { proxy in
          ScrollView {
            ScreenMainTitle(
              mainTitle: "Popular Destinations",
              subTitle: "Ready for travel?"
            )
            .padding(.top, 10)
            .padding(.bottom, 20)
            
            LazyVGrid(columns:[GridItem(), GridItem()]) {
              ForEach(vm.fetchedData.indices, id: \.self) { index in
                let place = vm.fetchedData[index]
                
                NavigationLink(
                  destination: PlaceDetailsView(
                    elementID: place.id ?? "",
                    collectionName: "placesFromApp"
                  ).navigationBarHidden(
                    true
                  )
                ) {
                  SightSeenReusableView(
                    place: place,
                    maxWidth: UIScreen.main.bounds.width / 2 - 30,
                    height: UIScreen.main.bounds.width / 2
                  )
                  .scaleEffect(scale)
                  .onAppear {
                    withAnimation(.easeOut(duration: 0.3)) {
                      scale = 1
                    }
                  }
                }
                .onTapGesture {
                  lastSelectedID = place.id
                }
                if index == vm.fetchedData.count {
                  Color.clear
                    .onAppear {
                      pageSize += 10
                    }
                }
              }
            }
            .padding(.horizontal, 20)
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
