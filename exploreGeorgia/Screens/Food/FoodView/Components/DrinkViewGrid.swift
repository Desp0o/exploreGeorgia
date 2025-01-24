//
//  DrinkViewGrid.swift
//  exploreGeorgia
//
//  Created by Despo on 24.01.25.
//

import SwiftUI

struct DrinkViewGrid: View {
  let data: [ResturantModel]
  
    var body: some View {
      VStack(spacing: 20) {
        HStack {
          Text("Drinks")
            .styledText(.customBlack, 20, .bold)
          
          Spacer()
          
          NavigationLink {
            
          } label: {
            Text("View more")
              .styledText(.customVine, 14)
          }
          
        }
        
        
        ForEach(data.indices, id: \.self) { index in
          let resturant = data[index]
          
          NavigationLink {
            ResturantView(place: resturant, collection: .drinks).navigationBarHidden(true)
          } label: {
            FoodViewSingleComponent(
              cover: resturant.cover,
              name: resturant.name,
              type: resturant.type,
              elementWidth: .infinity
            )
          }
        }
      }
    }
}
