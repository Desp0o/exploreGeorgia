//
//  AllBookmarkView.swift
//  exploreGeorgia
//
//  Created by Despo on 14.01.25.
//

import SwiftUI

struct AllBookmarkView: View {
  @Environment(\.presentationMode) var dismiss
  @StateObject private var vm = AllBookmarkViewModel()
  @ObservedObject private var alertManager = CustomAlertManager()
  @State private var currentPlace: SightSeenModel? = nil
  @State private var alertBoxMessage = ""
  @State private var dataIndex = 0
  
  var body: some View {
    ZStack {
      Color.primaryWhite
        .ignoresSafeArea()
      
      VStack(spacing: 30) {
        HStack {
          Text("Bookmarks")
            .styledText(.customBlue, 20, .bold)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .overlay {
          ZStack {
            HStack {
              Button {
                dismiss.wrappedValue.dismiss()
              } label: {
                ZStack {
                  Circle()
                    .fill(.customBlue)
                    .frame(width: 40, height: 40)
                  
                  Image("backArrow")
                    .renderingMode(.template)
                    .foregroundStyle(.white)
                }
              }
              
              Spacer()
            }
          }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.horizontal, 20)

        Spacer()
        
        if vm.isLoaded {
          ProgressView()
            .scaleEffect(1.5)
            .tint(.customBlue)
        } else {
          if vm.bookmarkedPlaces.isEmpty {
            Text("Your Bucket List Awaits...")
              .styledText(.customBlue, 16, .semibold)
              .padding(.bottom, 40)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          } else {
            ScrollView {
              HStack(spacing: 20) {
                ForEach(vm.buttonsArray.indices, id: \.self) { index in
                  let currentButton = vm.buttonsArray[index]
                  
                  Button {
                    withAnimation {
                      dataIndex = index
                    }
                  } label: {
                    Text(currentButton)
                      .styledText(.customBlack, 16, .semibold)
                      .padding(.horizontal, 10)
                      .padding(.vertical, 6)
                      .background(.customBlue.opacity(index == dataIndex ? 1 : 0.3))
                      .roundedCorners(12)
                  }
                }
              }
              
              Spacer()
                .frame(height: 20)
              
              VStack(spacing: 12) {
                switch dataIndex {
                case 0:
                  PlacesBookmarkViewComponent(
                    vm: vm,
                    data: vm.bookmarkedPlaces,
                    collectionName: "placesFromApp"
                  )
                case 1:
                  PlacesBookmarkViewComponent(
                    vm: vm,
                    data: vm.bookmarkedPlaces,
                    collectionName: "usersPlaces"
                  )
                case 2:
                  ToursBookmarkViewComponent(
                    vm: vm,
                    data: vm.bookmarkedTours
                  )
                default:
                  PlacesBookmarkViewComponent(
                    vm: vm,
                    data: vm.bookmarkedPlaces,
                    collectionName: "placesFromApp"
                  )
                }
              }
            }
            .scrollBounceBehavior(.basedOnSize)
            .scrollIndicators(.hidden)
            .padding(.horizontal, 20)
          }
        }
        
        Spacer()
      }
    }
    .onChange(of: dataIndex) { _ in
      switch dataIndex {
      case 0:
        vm.bookmarkedPlaces = []
        vm.fetchData(pageLimit: vm.pageSize, collectionName: "placesFromApp")
      case 1:
        vm.bookmarkedPlaces = []
        vm.fetchData(pageLimit: vm.pageSize, collectionName: "usersPlaces")
      case 2:
        vm.fetchToursData(pageLimit: vm.pageSize)
      default:
        vm.fetchData(pageLimit: vm.pageSize, collectionName: "placesFromApp")
      }
    }
  }
}
