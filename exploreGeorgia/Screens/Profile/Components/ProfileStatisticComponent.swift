//
//  ProfileStatisticComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import SwiftUI

struct ProfileStatisticComponent: View {
  var user: UserModel?
  var statisticArray: [ProfileStatModel]
  
  var body: some View {
    VStack() {
      CachedAsyncImage(url: URL(string: user?.avatar ?? ""))
        .clipShape(Circle())
        .frame(width: 96, height: 96)
      
      VStack {
        Text(user?.firstName ?? "")
          .styledText(
            .customBlack,
            24,
            .semibold
          )
        
        Text(user?.email ?? "")
          .styledText(
            .customGray,
            14
          )
      }
      
      ZStack {
        RoundedRectangle(cornerRadius: 12)
          .fill(Color.customWhite)
          .shadow(color: .black.opacity(0.25), radius: 3, y: 2)
        
        HStack {
          ForEach(0..<statisticArray.count, id: \.self) { index in
            Spacer()
            
            VStack(spacing: 10) {
              Text(statisticArray[index].title)
                .styledText(
                  .customBlack,
                  16,
                  .semibold
                )
              
              Text("\(statisticArray[index].count)")
                .styledText(
                  .customVine,
                  14,
                  .semibold
                )
            }
            
            Spacer()
            
            if index != statisticArray.count - 1 {
              Divider()
            }
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 12))
      }
      .padding(.top, 20)
      .frame(maxWidth: .infinity)
      .frame(height: 78)
    }
  }
}

#Preview {
  let user = UserModel(avatar: "", firstName: "", lastName: "", email: "", gender: "Male", points: 0, explored: [""], bucketList: [""], achievement: [""], createdAt: nil)
  ProfileStatisticComponent(user: user, statisticArray: [])
}
