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
  @State private var pageSize = 5
  
  var body: some View {
    ZStack {
      Color.primaryWhite
        .ignoresSafeArea()
      
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
        
        if vm.bookmarkedPlaces.isEmpty {
          Text("Your Bucket List Awaits...")
            .styledText(.customBlue, 16, .semibold)
            .padding(.bottom, 40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
          
          Text("Explore More, Bookmark More!")
            .styledText(.customBlue, 20, .bold)
            .padding(.top, 10)
          
          List {
            ForEach(Array(vm.bookmarkedPlaces.enumerated()), id: \.element) { index, place in
              ZStack {
                NavigationLink(destination: PlaceDetailsView(
                  elementID: place.id ?? ""
                ).navigationBarHidden(true))
                {
                  EmptyView()
                }.opacity(0.0)
                
                SightSeenReusableView(place: place, maxWidth: UIScreen.main.bounds.width - 40, height: 180)
                  .overlay {
                    ZStack(alignment: .topTrailing) {
                      Button {
                        let indexSet = IndexSet(integer: index)
                        withAnimation {
                          vm.removeBookmark(index: indexSet)
                        }
                      } label: {
                        Circle()
                          .fill(.white.opacity(0.001))
                      }
                      .frame(width: 34, height: 34)
                      .offset(x:-24, y: 24)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                  }
                
                if index == vm.bookmarkedPlaces.count - 1 {
                  Color.white.opacity(0)
                    .frame(width: 1, height: 0)
                    .onAppear {
                      pageSize += 5
                    }
                }
              }
              .buttonStyle(PlainButtonStyle())
              .listStyle(PlainListStyle())
              .listRowSeparator(.hidden)
              .listRowBackground(Color.clear)
            }
            .onDelete(perform: vm.removeBookmark)
            .id(vm.bookmarkedPlaces)
          }
          .listStyle(PlainListStyle())
          .scrollContentBackground(.hidden)
          .scrollIndicators(.hidden)
          .background(Color.clear)
        }
      }
    }
    .overlay{
      if vm.isLoaded {
        ZStack {
          Color.primaryWhite.ignoresSafeArea()
          
          ProgressView()
            .scaleEffect(1.5)
            .tint(.customBlue)
        }
      }
      
      if alertManager.isShown {
        CustomAlert(
          alertManager: alertManager,
          alertMessage: alertBoxMessage,
          errorType: .error
        )
      }
    }
    .onAppear {
      vm.fetchData(pageLimit: pageSize)
    }
    .onChange(of: pageSize) { _ in
      vm.fetchData(pageLimit: pageSize)
    }
    .onReceive(vm.$errorMessages) { message in
      if !message.isEmpty {
        alertBoxMessage = message
        alertManager.showAlert()
      }
    }
  }
}

//
//#Preview {
//  AllBookmarkView()
//}
