//
//  FoodViewGrid.swift
//  exploreGeorgia
//
//  Created by Despo on 24.01.25.
//

import SwiftUI

struct FoodViewGrid: View {
  let data: [ResturantModel]
  let elementWidth: CGFloat
  let collection: FirebaseCollectionEnum
  
  var body: some View {
    VStack {
      LazyVGrid(
        columns: [
          GridItem(spacing: 20),
          GridItem()
        ],
        spacing: 20
      ) {
        ForEach(data.indices, id: \.self) { index in
          let resturant = data[index]
          
          NavigationLink {
            ResturantView(place: resturant, collection: collection).navigationBarHidden(true)
          } label: {
            FoodViewSingleComponent(
              cover: resturant.cover,
              name: resturant.name,
              type: resturant.type,
              elementWidth: elementWidth
            )
          }
        }
      }
    }
  }
}
