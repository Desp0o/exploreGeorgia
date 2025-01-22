//
//  ResturantView.swift
//  exploreGeorgia
//
//  Created by Despo on 23.01.25.
//

import SwiftUI

struct ResturantView: View {
  @StateObject var vm = ResturantViewModel()
  @State private var isInfo = true
  @State private var infoOpacity: CGFloat = 1
  @State private var menuOpacity: CGFloat = 0
  @State private var isPresent = false
  
  var body: some View {
    VStack {
      PlaceDetailsBGComponent(cover: vm.singleResturant?.cover ?? "")
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.40)
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
              ScrollView {
                VStack {
                  HStack(spacing: 40) {
                    Text("Info")
                      .styledText(.customBlack, 18, .semibold)
                      .onTapGesture {
                        isInfo = true
                        withAnimation {
                          infoOpacity = 1
                          menuOpacity = 0
                        }
                      }
                    
                    Text("Menu")
                      .styledText(.customBlack, 18, .semibold)
                      .onTapGesture {
                        isInfo = false
                        withAnimation {
                          infoOpacity = 0
                          menuOpacity = 1
                        }
                      }
                  }
                  
                  if isInfo {
                    ResturantViewInfoComponent(vm: vm, isPresent: $isPresent)
                      .opacity(infoOpacity)
                  } else {
                    ResturantMenuComponent(vm: vm)
                      .opacity(menuOpacity)
                  }
                }
                .padding(20)
                .padding(.bottom, 10)
              }
              .scrollBounceBehavior(.basedOnSize)
              .scrollIndicators(.hidden)
            }
            .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.60)
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
    .sheet(isPresented: $isPresent) {
      MapViewReusable(
        latitudeProp: Double(vm.singleResturant?.latitude ?? 0),
        longitudeProp: Double(vm.singleResturant?.longitude ?? 0),
        locationName: vm.singleResturant?.name ?? "",
        isEditable: false
      )
    }
  }
}

#Preview {
  ResturantView()
}



