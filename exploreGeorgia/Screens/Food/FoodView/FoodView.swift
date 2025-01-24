//
//  FoodView.swift
//  exploreGeorgia
//
//  Created by Despo on 24.01.25.
//

import SwiftUI

struct FoodView: View {
  @StateObject var vm = FoodViewModel()
  @ObservedObject var pushVM = SightSeenRepository()
  
  var body: some View {
    VStack {
      Button {
        pushVM.pushRsturantToDB()
      } label: {
        Text("Add from here")
      }
      
      GeometryReader {geometry in
        ScrollView {
          VStack(spacing: 50) {
            Text("Food & Drinks")
              .styledText(.customBlue, 26, .bold)
            
            VStack {
              HStack {
                Text("Traditional Kitchen")
                  .styledText(.customBlack, 20, .bold)
                
                Spacer()
                
                NavigationLink {
                  
                } label: {
                  Text("View more")
                    .styledText(.customVine, 14)
                }
                
              }
              FoodViewGrid(data: vm.resturantsData, elementWidth: geometry.size.width / 2 - 40, collection: .resturant)
            }
            
            DrinkViewGrid(data: vm.drinksData)
            
            VStack {
              HStack {
                Text("Bakery")
                  .styledText(.customBlack, 20, .bold)
                
                Spacer()
                
                NavigationLink {
                  
                } label: {
                  Text("View more")
                    .styledText(.customVine, 14)
                }
                
              }
              FoodViewGrid(data: vm.bakeryData, elementWidth: geometry.size.width / 2 - 40, collection: .bakery)
            }
          }
          .padding(.horizontal, 20)
          .padding(.bottom, 30)
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    
    .background(
      Image("foodBG")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .opacity(1)
    )
    .background(Color.primaryWhite)
  }
}
