//
//  PlaceDetailsInfoComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import SwiftUI

struct PlaceDetailsInfoComponent: View {
  @ObservedObject var vm: PlaceDetailsViewModel
  @Binding var selectedImage: String
  @Binding var isLightBoxVisible: Bool
  @Binding var isPresented: Bool
  let author: UserModel?
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        HStack {
          VStack(alignment: .leading, spacing: 0) {
            Text(vm.currentPlace?.name ?? "")
              .styledText(
                .customBlack,
                24,
                .semibold
              )
            
            Text(vm.currentPlace?.adress ?? "")
              .styledText(
                .customGray,
                15
              )
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          
          Spacer()
          
          if author != nil {
            VStack {
              CachedAsyncImage(url: URL(string: author?.avatar ?? ""))
                .frame(width: 30, height: 30)
                .clipShape(Circle())
              
              Text(author?.firstName ?? "")
                .styledText(
                  .customBlack,
                  12
                )
            }
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
              .styledText(
                .customGray,
                15
              )
          }
          
          Spacer()
          
          if vm.currentPlace?.user == nil {
            HStack {
              Image(systemName: "star.fill")
                .renderingMode(.template)
                .foregroundStyle(.yellow)
                .frame(width: 12, height: 12)
              
              Text(vm.currentPlace?.rating ?? "")
                .styledText(
                  .customBlack,
                  15
                )
              
              Text(String("(\(vm.currentPlace?.ratingCount ?? 0))"))
                .styledText(
                  .customGray,
                  14
                )
            }
          }
          
          Spacer()
          
          Text(
            vm.currentPlace?.price ?? 0 > 0 ? "₾\(vm.currentPlace?.price ?? 0)" : "Free"
          )
          .styledText(
            .customVine,
            15
          )
        }
        
        LazyVGrid(columns: vm.gridItems, alignment: .leading, spacing: 20) {
          ForEach(vm.currentPlace?.album ?? [""], id: \.self) { imageUrl in
            CachedAsyncImage(url: URL(string: imageUrl))
              .frame(width: 50, height: 50)
              .roundedCorners(12)
              .onTapGesture {
                selectedImage = imageUrl
                isLightBoxVisible = true
              }
          }
        }
        
        VStack(alignment: .leading) {
          Text("About Destination")
            .styledText(
              .customBlack,
              20,
              .semibold
            )
          
          Text(vm.currentPlace?.description.prefix(1000) ?? "")
            .styledText(
              .customGray,
              14
            )
        }
        
        Button {
          isPresented.toggle()
        } label: {
          Text("Show on map")
            .styledText(
              .buttonPrimary,
              16,
              .bold
            )
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(.customBlue)
            .roundedCorners(12)
        }
      }
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



