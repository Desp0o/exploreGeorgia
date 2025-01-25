//
//  ResturantView.swift
//  exploreGeorgia
//
//  Created by Despo on 23.01.25.
//

import SwiftUI

struct ResturantView: View {
  @StateObject var vm = ResturantViewModel()
  @StateObject var toastManager = ToastManager()
  @State private var isInfo = true
  @State private var infoOpacity: CGFloat = 1
  @State private var menuOpacity: CGFloat = 0
  @State private var isPresent = false
  @State var isReviewVisible = false
  @State var isError = false
  let place: ResturantModel
  let collection: FirebaseCollectionEnum
  
  var body: some View {
    ZStack {
      VStack {
        if toastManager.isShown {
          if isError {
            ToastView(message: vm.errorMessage?.rawValue ?? "", bgColor: .error)
          } else {
            ToastView(message: vm.successMessage, bgColor: .successfully)
          }
        }
        
        Spacer()
      }
      .padding(.horizontal, 20)
      .zIndex(4)
      
      VStack {
        PlaceDetailsBGComponent(cover: vm.singleResturant?.cover ?? "")
          .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.40)
          .clipped()
          .overlay {
            VStack {
              PlaceDetailsNavigationBar(
                isBookMarked: $vm.isBookMarked,
                placeID: vm.singleResturant?.id ?? ""
              )
              
              Spacer()
            }
          }
        
        Spacer()
      }
      .overlay {
        if vm.errorMessage == .fetchError {
          FetchErrorComponentReusable()
        } else {
          GeometryReader { geometry in
            VStack {
              Spacer()
              
              VStack {
                ScrollViewReader { proxy in
                  ScrollView {
                    VStack {
                      HStack(spacing: 40) {
                        Text("Info")
                          .styledText(isInfo ? .customBlue : .customBlack, 18, .semibold)
                          .onTapGesture {
                            isInfo = true
                            withAnimation {
                              infoOpacity = 1
                              menuOpacity = 0
                            }
                          }
                        
                        Text("Menu")
                          .styledText(!isInfo ? .customBlue : .customBlack, 18, .semibold)
                          .onTapGesture {
                            isInfo = false
                            withAnimation {
                              infoOpacity = 0
                              menuOpacity = 1
                            }
                          }
                      }
                      
                      if isInfo {
                        ResturantViewInfoComponent(vm: vm, isPresent: $isPresent, isReviewVisible: $isReviewVisible)
                          .opacity(infoOpacity)
                        
                        Spacer()
                          .frame(width: 0, height: 00)
                          .background(.red)
                          .id("scrollToDown")
                      } else {
                        ResturantMenuComponent(vm: vm)
                          .opacity(menuOpacity)
                      }
                    }
                    .padding(20)
                    .padding(.bottom, 10)
                    .onChange(of: isReviewVisible) { _ in
                      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                          proxy.scrollTo("scrollToDown", anchor: .center)
                        }
                      }
                    }
                  }
                  .scrollBounceBehavior(.basedOnSize)
                  .scrollIndicators(.hidden)
                }
              }
              .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.60)
              .background(
                Image("foodBG")
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
              )
              .background(.primaryWhite)
              .clipShape(
                .rect(
                  topLeadingRadius: 20,
                  bottomLeadingRadius: 0,
                  bottomTrailingRadius: 0,
                  topTrailingRadius: 20
                )
              )
            }
          }
        }
      }
      .overlay {
        if vm.isLoading {
          VStack {
            ProgressView()
              .scaleEffect(1.5)
              .tint(.customBlue)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(.primaryWhite)
        }
      }
      .ignoresSafeArea()
      .onReceive(vm.$successMessage, perform: { message in
        if message != "" {
          isError = false
          toastManager.showToast()
        }
      })
      .onReceive(vm.$errorMessage, perform: { message in
        if message == .feedbackError {
          isError = true
          toastManager.showToast()
        }
      })
      .sheet(isPresented: $isPresent) {
        MapViewReusable(
          latitudeProp: Double(vm.singleResturant?.latitude ?? 0),
          longitudeProp: Double(vm.singleResturant?.longitude ?? 0),
          locationName: vm.singleResturant?.name ?? "",
          isEditable: false
        )
      }
    }
    .background(.primaryWhite)
    .onAppear {
      vm.fetchData(id: place.id ?? "", collection: collection)
    }
  }
}




