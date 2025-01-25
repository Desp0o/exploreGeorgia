//
//  ResturantMenuComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 23.01.25.
//

import SwiftUI

struct ResturantMenuComponent: View {
  @ObservedObject var vm: ResturantViewModel
  
  var body: some View {
    LazyVStack(spacing: 20) {
      ForEach(vm.singleResturant?.menu.keys.sorted() ?? [], id: \.self) { key in
        let foodItem = vm.singleResturant?.menu[key]
        
        MenuItem(
          foodCover: foodItem?.foodCover ?? "",
          foodName: foodItem?.foodName ?? "",
          ingredients: foodItem?.foodIngredients ?? "",
          price: foodItem?.foodPrice ?? 0
        )
      }
      
    }
    .padding(.vertical, 20)
  }
}
