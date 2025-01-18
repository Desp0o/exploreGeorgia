//
//  TourBookingComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 19.01.25.
//

import SwiftUI

struct TourBookingComponent: View {
  @ObservedObject var vm: TourViewModel
  @Binding var selectedDate: Date
  @Binding var pickedPlaces: Int
  let startingDate: Date
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      DatePicker(
        "Booking Date",
        selection: $selectedDate,
        in: startingDate...,
        displayedComponents: [.date]
      )
      .accentColor(.customBlue)
      .datePickerStyle(GraphicalDatePickerStyle())
      .padding(.horizontal, 20)
      .background(.customWhite)
      .roundedCorners(12)
      
      HStack {
        HStack(spacing: 0) {
          Text("Tickets: ")
            .styledText(.customBlack, 18, .bold)
          
          Image(systemName: "figure.stand")
            .renderingMode(.template)
            .foregroundStyle(.customBlack)
          
          Text(" x ")
            .styledText(.customBlack, 18, .bold)
          
          Text("\(pickedPlaces)")
            .styledText(.customBlack, 18, .bold)
        }
        
        
        Stepper("") {
          if pickedPlaces <= 11 {
            pickedPlaces += 1
          }
        } onDecrement: {
          if pickedPlaces > 0 {
            pickedPlaces -= 1
          }
        }
      }
      
      
      HStack {
        Text("Total: \((vm.tour?.price ?? 0) * pickedPlaces)")
          .styledText(.customBlack, 18, .bold)
        
        Spacer()
        
        Button {
          
        } label: {
          Text("Pay")
            .styledText(.buttonPrimary, 20, .semibold)
            .frame(width: 95, height: 32)
            .background(.customBlue)
            .roundedCorners(10)
        }
        
      }
      
    }
    .padding(.horizontal, 20)
  }
}
