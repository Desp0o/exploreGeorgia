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
  @State private var isPresented = false
  @State private var addButtonScale: CGFloat = 0

  var body: some View {
    VStack {
      GeometryReader {geometry in
        ScrollView {
          VStack(spacing: 30) {
            Text("Food & Drinks")
              .styledText(.customBlue, 26, .bold)
            
            VStack {
              HStack {
                Text("Traditional Kitchen")
                  .styledText(.customBlack, 20, .bold)
                
                Spacer()
                
                NavigationLink {
                  FoodCategoryWrapper(titleText: "Traditional Kitchen", collectionName: .resturant)
                    .navigationBarHidden(true)
                    .ignoresSafeArea()
                } label: {
                  Text("View more")
                    .styledText(.customBlue, 14)
                }
                
              }
              FoodViewGrid(
                data: vm.resturantsData,
                elementWidth: geometry.size.width / 2 - 40,
                collection: .resturant
              )
            }
            
            DrinkViewGrid(data: vm.drinksData)
            
            VStack {
              HStack {
                Text("Bakery")
                  .styledText(.customBlack, 20, .bold)
                
                Spacer()
                
                NavigationLink {
                  FoodCategoryWrapper(titleText: "Bakery", collectionName: .bakery)
                    .navigationBarHidden(true)
                    .ignoresSafeArea()
                } label: {
                  Text("View more")
                    .styledText(.customBlue, 14)
                }
                
              }
              FoodViewGrid(
                data: vm.bakeryData,
                elementWidth: geometry.size.width / 2 - 40,
                collection: .bakery
              )
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
    )
    .background(Color.primaryWhite)
    .overlay {
      ZStack(alignment: .bottomTrailing) {
        AddButtonComponent(addButtonScale: $addButtonScale, isPresented: $isPresented, icon: .aiIcon)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    }
    .overlay {
      if vm.isLoading {
        FoodViewShimmer()
      }
    }
    .sheet(isPresented: $isPresented) {
      AIView()
    }
  }
}
