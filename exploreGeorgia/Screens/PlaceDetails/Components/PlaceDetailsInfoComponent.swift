//
//  PlaceDetailsInfoComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import SwiftUI

struct PlaceDetailsInfoComponent: View {
  @EnvironmentObject var vm: PlaceDetailsViewModel
  let isNavigationDisabled: Bool
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        HStack {
          VStack(alignment: .leading, spacing: 0) {
            Text(vm.currentPlace?.name ?? "")
              .styledText(.customBlack, 24, .semibold)
            
            Text(vm.currentPlace?.adress ?? "")
              .styledText(.customGray, 15)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          
          Spacer()
          
          if vm.author?.id != nil {
            NavigationLink {
              SIngleUserProfileWrapper(singleUserId: vm.author?.id ?? "")
                .toolbar(.hidden)
                .ignoresSafeArea()
            } label: {
              VStack {
                CachedAsyncImage(url: URL(string: vm.author?.avatar ?? ""))
                  .frame(width: 30, height: 30)
                  .clipShape(Circle())
                
                Text(vm.author?.firstName ?? "")
                  .styledText(.customBlack, 12)
              }
            }
            .disabled(isNavigationDisabled)
          }
        }
        
        HStack {
          HStack {
            Image("locationPin")
              .renderingMode(.template)
              .resizable()
              .scaledToFill()
              .foregroundColor(.customGray)
              .frame(width: 16, height: 16)
            
            Text(vm.currentPlace?.region ?? "")
              .styledText(.customGray, 15)
          }
          
          Spacer()
          
          if vm.currentPlace?.user == nil {
            HStack {
              Image(systemName: IconsEnum.ratingStar.rawValue)
                .renderingMode(.template)
                .foregroundStyle(.yellow)
                .frame(width: 12, height: 12)
              
              Text(vm.currentPlace?.rating ?? "")
                .styledText(.customBlack, 15)
              
              Text(String("(\(vm.currentPlace?.ratingCount ?? 0))"))
                .styledText(.customGray, 14)
            }
          }
          
          Spacer()
          
          Text(
            vm.currentPlace?.price ?? 0 > 0 ? "₾\(vm.currentPlace?.price ?? 0)" : "Free"
          )
          .styledText(.customBlue, 15)
        }
        
        LazyVGrid(columns: vm.gridItems, alignment: .leading, spacing: 20) {
          ForEach(vm.currentPlace?.album ?? [""], id: \.self) { imageUrl in
            CachedAsyncImage(url: URL(string: imageUrl))
              .frame(width: 50, height: 50)
              .roundedCorners(12)
              .onTapGesture {
                vm.selectedImage = imageUrl
                vm.isLightBoxVisible = true
              }
          }
        }
        
        VStack(alignment: .leading) {
          Text("About Destination")
            .styledText(.customBlack, 20, .semibold)
          
          Text(vm.currentPlace?.description ?? "")
            .styledText(.customGray, 14)
        }
        
        Button {
          vm.isPresented.toggle()
        } label: {
          Text("Show on map")
            .styledText(.buttonPrimary, 16, .bold)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(.customBlue)
            .roundedCorners(12)
        }
      }
      .padding(.bottom , 20)
    }
    .scrollIndicators(.hidden)
    .scrollBounceBehavior(.basedOnSize)
    .padding(.top, 20)
    .padding(.horizontal, 20)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.customWhite)
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



