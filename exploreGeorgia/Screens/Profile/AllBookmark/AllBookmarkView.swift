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
  @State private var alertBoxMessage = ""
  
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
                OverlayActionButtonIcon(
                  iconName: .backButton,
                  tint: .white,
                  scale: 0.9,
                  bgColor: .customBlue,
                  opacity: 1
                )
              }
              Spacer()
            }
          }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.horizontal, 20)
        
        if vm.isLoading {
          VStack {
            ProgressView()
              .scaleEffect(1.5)
              .tint(.customBlue)
          }
          .frame(maxHeight: .infinity)
        } else {
          ScrollView {
            HStack(spacing: 20) {
              ForEach(vm.buttonsArray.indices, id: \.self) { index in
                let currentButton = vm.buttonsArray[index]
                
                Button {
                  withAnimation {
                    vm.dataIndex = index
                  }
                } label: {
                  Text(currentButton)
                    .styledText(.customBlack, 16, .semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.customBlue.opacity(index == vm.dataIndex ? 1 : 0.3))
                    .roundedCorners(12)
                }
              }
            }
            
            Spacer()
              .frame(height: 20)
            
            VStack(spacing: 12) {
              switch vm.dataIndex {
              case 0:
                PlacesBookmarkViewComponent(collectionName: .appPlace)
              case 1:
                PlacesBookmarkViewComponent(collectionName: .usersPlace)
              case 2:
                ToursBookmarkViewComponent()
              default:
                NoBookmarksComponent()
              }
            }
          }
          .scrollBounceBehavior(.basedOnSize)
          .scrollIndicators(.hidden)
        }
      }
    }
    .onAppear {
      vm.requestData()
    }
    .onChange(of: vm.dataIndex) { _ in
      vm.requestData()
    }
    .environmentObject(vm)
  }
}
