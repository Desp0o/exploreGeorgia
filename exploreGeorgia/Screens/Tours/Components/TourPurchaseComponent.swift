//
//  TourPurchaseComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 20.01.25.
//

import SwiftUI

struct TourPurchaseComponent: View {
  @ObservedObject var vm: TourViewModel
  @State var selectedCardIndex = 0
  @Binding var totalAmount: Int
  @Binding var isPaymentOpened: Bool
  let tourId: String
  
  var body: some View {
    ZStack {
      Color.black.opacity(0.5).ignoresSafeArea()
      
      VStack {
        VStack {
          Text("Select card")
            .styledText(.customBlack, 15, .bold)
          
          ScrollView(.horizontal) {
            HStack(spacing: 20) {
              ForEach(vm.cardData.indices, id: \.self) { index in
                let card = vm.cardData[index]
                let cardfirstNum = card.number.prefix(1)
                let cardImage = {
                  switch cardfirstNum {
                  case "5", "2": return "mastercard"
                  case "4": return "visa"
                  case "3": return "amex"
                  default: return "defaultCreditCard"
                  }
                }()
                
                Image(cardImage)
                  .resizable()
                  .scaledToFill()
                  .frame(width: 40, height: 30)
                  .padding(5)
                  .background(.customBlue.opacity(selectedCardIndex == index ? 1 : 0.3))
                  .clipShape(RoundedRectangle(cornerRadius: 8))
                  .onTapGesture {
                    withAnimation {
                      selectedCardIndex = index
                    }
                  }
              }
            }
            .padding(.horizontal)
          }
          .scrollBounceBehavior(.basedOnSize)
          .scrollIndicators(.hidden)
        }
        
        Spacer()
        
        HStack {
          Text("\(totalAmount) ₾")
            .styledText(.customBlue, 18, .bold)
          
          Button {
            
          } label: {
            Text("Pay")
              .styledText(.buttonPrimary, 20, .semibold)
              .frame(width: 75, height: 32)
              .background(.customBlue)
              .roundedCorners(10)
          }
        }
      }
      .padding(.vertical, 20)
      .frame(height: 170)
      .background(.primaryWhite)
      .roundedCorners(12)
      .padding(.horizontal, 30)
      .onTapGesture {
        withAnimation {
          isPaymentOpened = true
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .onTapGesture {
      withAnimation {
        isPaymentOpened = false
      }
    }
  }
}
