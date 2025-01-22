//
//  ResturantViewInfoComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 22.01.25.
//

import SwiftUI

struct ResturantViewInfoComponent: View {
  @ObservedObject var vm: ResturantViewModel
  @Binding var isPresent: Bool
  
  var body: some View {
    VStack(spacing: 20) {
      VStack {
        HStack {
          Text(vm.singleResturant?.workingHours ?? "")
            .styledText(.customBlack, 14)
          
          Spacer()
          
          HStack {
            Image("bill")
              .renderingMode(.template)
              .foregroundStyle(.customBlack)
              .scaleEffect(0.7)
            
            Text("\(String(format: "%.2f", vm.singleResturant?.minCost ?? 0)) min Cost")
              .styledText(.customBlack, 14)
          }
        }
        
        HStack {
          Image("locationPin")
          
          Button {
            isPresent.toggle()
          } label: {
            Text("See on map")
              .styledText(.customVine, 14)
          }
          
          Spacer()
        }
      }
      .padding(16)
      .background(.customWhite)
      .roundedCorners(12)
      
      VStack {
        HStack {
          Text("About")
            .styledText(.customBlack, 16, .semibold)
          
          Spacer()
        }
        
        Text(vm.singleResturant?.about ?? "")
      }
      
      VStack {
        HStack {
          Text("Reviews")
            .styledText(.customBlack, 16, .semibold)
          
          Spacer()
        }
        
        LazyVStack(alignment: .leading) {
          ForEach(vm.singleResturant?.reviews ?? [""], id: \.self) { review in
            Text(review)
              .styledText(.customBlack, 15)
              .padding(.horizontal, 10)
              .padding(.vertical, 6)
              .background(.customWhite)
              .clipShape(RoundedRectangle(cornerRadius: 12))
          }
        }
      }
    }
    .padding(.vertical, 20)
  }
}

