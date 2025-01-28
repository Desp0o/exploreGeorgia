//
//  TourBookingComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 19.01.25.
//

import SwiftUI

struct TourBookingComponent: View {
  @EnvironmentObject var vm: TourViewModel
  @State var isBounced = false
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      DatePicker(
        "Booking Date",
        selection: $vm.selectedDate,
        in: vm.startingDate...,
        displayedComponents: [.date]
      )
      .accentColor(.customGreen)
      .datePickerStyle(GraphicalDatePickerStyle())
      .padding(.horizontal, 20)
      .background(.customWhite)
      .roundedCorners(12)
      
      HStack {
        HStack(spacing: 0) {
          Text("Tickets: ")
            .styledText(isBounced ? .red : .customBlack, 18, .bold)
          
          Image(systemName: "figure.stand")
            .renderingMode(.template)
            .foregroundStyle(isBounced ? .red : .customBlack)
          
          Text(" x ")
            .styledText(isBounced ? .red : .customBlack, 18, .bold)
          
          Text("\(vm.pickedPlaces)")
            .styledText(isBounced ? .red : .customBlack, 18, .bold)
        }
        .scaleEffect(isBounced ? 1.1 : 1.0)
        .animation(.bouncy, value: isBounced)
        
        Stepper("") {
          if vm.pickedPlaces <= 11 {
            vm.pickedPlaces += 1
            vm.totalAmount += vm.tour?.price ?? 0
          }
        } onDecrement: {
          if vm.pickedPlaces > 0 {
            vm.pickedPlaces -= 1
            vm.totalAmount -= vm.tour?.price ?? 0
          }
        }
      }
      
      HStack {
        Text("Total: \((vm.tour?.price ?? 0) * vm.pickedPlaces)")
          .styledText(.customBlack, 18, .bold)
        
        Spacer()
        
        Button {
          if vm.totalAmount == 0 {
            isBounced = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
              isBounced = false
            }
          } else {
            withAnimation {
              vm.isPaymentOpened = true
            }
          }
        } label: {
          Text("Pay")
            .styledText(.buttonPrimary, 20, .semibold)
            .frame(width: 95, height: 32)
            .background(.customGreen)
            .roundedCorners(10)
        }
      }
    }
    .padding(.horizontal, 20)
  }
}
