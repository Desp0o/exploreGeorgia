//
//  TourSummaryComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 18.01.25.
//

import SwiftUI

struct TourSummaryComponent: View {
  @EnvironmentObject var vm: TourViewModel
  
  var body: some View {
    VStack(spacing: 12) {
      HStack {
        Text("Tour Summary")
          .styledText(.customBlack, 20, .semibold)
        
        Spacer()
      }
      
      HStack(spacing: 25) {
        ForEach(vm.tourDetailArray.indices, id: \.self) { index in
          let element = vm.tourDetailArray[index]
          
          HStack {
            ZStack {
              Image(element.icon)
                .renderingMode(.template)
                .foregroundStyle(.customGreen)
                .onTapGesture {
                  print(index)
                }
            }
            .frame(width: 40, height: 40)
            .background(.customWhite)
            .roundedCorners(12)
            
            VStack(alignment: .leading) {
              Text(element.title)
                .styledText(.customGray, 12)
              
              Text(element.titleValie)
                .styledText(.customBlack, 12)
            } 
          }
        }
      }
      
      VStack {
        HStack {
          Text("Description")
            .styledText(.customBlack, 20, .semibold)
          
          Spacer()
        }
        
        Text(vm.tour?.description ?? "")
          .styledText(.customBlack, 14)
      }
    }
    .padding(.horizontal, 20)
  }
}
