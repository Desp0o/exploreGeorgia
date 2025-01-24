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
          Text("add from here")
        }
        
        ScrollView(.horizontal) {
          HStack(spacing: 20) {
            if !vm.resturantsData.isEmpty {
              ForEach(vm.resturantsData, id: \.id) { resturant in
                NavigationLink {
                  ResturantView(place: resturant)
                } label: {
                  FoodViewSingleComponent(cover: resturant.cover, name: resturant.name, type: resturant.type)
                }
              }
            }
          }
        }

      }
      .background(.primaryWhite)
    }
}

#Preview {
    FoodView()
}
