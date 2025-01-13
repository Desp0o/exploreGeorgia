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
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
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
            
            Text("(2389)")
              .styledText(
                .customGray,
                15
              )
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
            AsyncImage(url: URL(string: imageUrl)) { image in
              image
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .roundedCorners(12)
            } placeholder: {
              ProgressView()
                .tint(.customBlue)
            }
            .frame(width: 50, height: 50)
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
    .padding(.top, 20)
    .padding(.horizontal, 20)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.customWhite)
    .clipShape(
      .rect(
        topLeadingRadius: 12,
        bottomLeadingRadius: 0,
        bottomTrailingRadius: 0,
        topTrailingRadius: 12
      )
    )
  }
}



