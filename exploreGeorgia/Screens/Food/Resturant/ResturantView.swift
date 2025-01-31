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
  @State var isError = false
  let place: ResturantModel
  let collection: FirebaseCollectionEnum
  
  var body: some View {
    ZStack {
      
      
      VStack {
        PlaceDetailsBGComponent(cover: vm.singleResturant?.cover ?? "")
          .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.45)
          .clipped()
        
        Spacer()
      }
      
      if vm.errorMessage == .fetchError {
        FetchErrorComponentReusable()
      } else {
        GeometryReader { geometry in
          VStack {
            Spacer()
            
            VStack {
              Rectangle()
                .fill(.customGreen)
                .frame(width: 70, height: 10)
                .roundedCorners(12)
                .gesture(
                  DragGesture()
                    .onChanged { value in
                      let newHeight = vm.infoHeight - (value.translation.height / geometry.size.height)
                      vm.infoHeight = min(max(newHeight, 0.6), 0.85)
                    }
                )
              
              ScrollViewReader { proxy in
                ScrollView {
                  VStack {
                    HStack(spacing: 40) {
                      Text("Info")
                        .styledText(isInfo ? .customGreen : .customBlack, 18, .semibold)
                        .onTapGesture {
                          isInfo = true
                          withAnimation {
                            infoOpacity = 1
                            menuOpacity = 0
                          }
                        }
                      
                      Text("Menu")
                        .styledText(!isInfo ? .customGreen : .customBlack, 18, .semibold)
                        .onTapGesture {
                          isInfo = false
                          withAnimation {
                            infoOpacity = 0
                            menuOpacity = 1
                          }
                        }
                    }
                    
                    if isInfo {
                      ResturantViewInfoComponent(collection: collection)
                        .opacity(infoOpacity)
                      
                      Spacer()
                        .frame(width: 0, height: 20)
                        .background(.red)
                        .id("scrollToDown")
                    } else {
                      ResturantMenuComponent()
                        .opacity(menuOpacity)
                    }
                  }
                  .padding(.horizontal, 20)
                  .padding(.bottom, 20)
                  .onChange(of: vm.isReviewVisible) { _ in
                    Task { @MainActor in
                      try? await Task.sleep(for: .seconds(0.1))
                      withAnimation(.easeInOut(duration: 0.2)) {
                        proxy.scrollTo("scrollToDown", anchor: .center)
                      }
                    }
                  }
                  .onChange(of: vm.commentLoaderTrigger) { _ in
                    Task { @MainActor in
                      try? await Task.sleep(for: .seconds(0.1))
                      withAnimation(.easeInOut(duration: 0.2)) {
                        proxy.scrollTo("scrollToDown", anchor: .center)
                      }
                    }
                  }
                }
                .scrollBounceBehavior(.basedOnSize)
                .scrollIndicators(.hidden)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
              }
              .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: geometry.size.height * vm.infoHeight)
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
      
      VStack {
        PlaceDetailsNavigationBar(
          isBookMarked: $vm.isBookMarked,
          placeID: vm.singleResturant?.id ?? ""
        )
        
        Spacer()
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .onTapGesture {
      hideKeyboard()
    }
    .ignoresSafeArea(.container, edges: [.top, .bottom])
    .background(.primaryWhite)
    .onAppear {
      vm.fetchData(id: place.id ?? "", collection: collection)
    }
    .animation(.easeInOut, value: vm.infoHeight )
    .onReceive(vm.$successMessage, perform: { message in
      if message != "" {
        isError = false
        toastManager.showToast()
        print("🟢")
      }
    })
    .onReceive(vm.$errorMessage, perform: { message in
      if message == .feedbackError || message == .noFeedback {
        isError = true
        toastManager.showToast()
        print("🔴")
      }
    })
    .sheet(isPresented: $vm.isPresent) {
      MapViewReusable(
        latitudeProp: Double(vm.singleResturant?.latitude ?? 0),
        longitudeProp: Double(vm.singleResturant?.longitude ?? 0),
        locationName: vm.singleResturant?.name ?? "",
        isEditable: false
      )
    }
    .overlay {
      if vm.isLoading {
        PlaceDetailsShimmer()
      }
      
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
    }
    .environmentObject(vm)
    
  }
}




