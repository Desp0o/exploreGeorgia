//
//  SinglePurchaseComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 20.01.25.
//

import SwiftUI

struct SinglePurchaseComponent: View {
  @StateObject var vm = PurchaseHistoryViewModel()
  
    var body: some View {
      ZStack {
        
        HStack(spacing: 12) {
          CachedAsyncImage(url: URL(string: "https://static.tkt.ge/img/74559d66-a843-4dfd-8db9-00f08b832384.jpeg"))
            .frame(width: 160, height: 120)
            .roundedCorners(12)
            .grayscale(vm.isTourExpired ? 1 : 0)
          
          
          VStack(alignment: .leading, spacing: 15) {
            VStack(alignment: .leading) {
              Text("Tbilisi old city")
                .styledText(.customBlack, 16, .bold)
            }
            
            Spacer()
            
            VStack(alignment: .leading) {
              
              Text(vm.tourDate)
                .styledText(.customBlack, 14)
              
              HStack(spacing: 0) {
                Image(systemName: "figure.stand")
                
                Text(" x 12")
                  .styledText(.customBlack)
              }
              
              Text("Total: ")
                .styledText(.customBlack)
            }
            
          }


          Spacer()
          
          ZStack {
            Rectangle()
              .fill(vm.isTourExpired ? .red : .green)
              .frame(width: 30)
              .clipShape(
                .rect(
                  topLeadingRadius: 0,
                  bottomLeadingRadius: 12,
                  bottomTrailingRadius: 12,
                  topTrailingRadius: 0
                )
              )
            
            Text(vm.isTourExpired ? "Expired" : "Incoming")
              .styledText(.customWhite, 15, .semibold)
              .rotationEffect(Angle(degrees: 90))
          }
          .offset(y: -10)
        }
      }
      .padding(10)
      .frame(maxWidth: .infinity, maxHeight: 140)
      .background(.customWhite)
      .roundedCorners(12)
    }
}

#Preview {
    SinglePurchaseComponent()
    .preferredColorScheme(.dark)
}
