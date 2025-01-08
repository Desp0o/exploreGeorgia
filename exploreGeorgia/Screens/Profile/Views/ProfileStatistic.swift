//
//  ProfileStatistic.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import SwiftUI

struct ProfileStatistic: View {
  let stat = [
    ProfileStatModel(title: "Points", count: 20),
    ProfileStatModel(title: "Explore", count: 200),
    ProfileStatModel(title: "Bucket List", count: 550)
  ]
  
  var body: some View {
    VStack() {
      AsyncImage(url: URL(string: "https://media.licdn.com/dms/image/v2/D4D22AQHDnjTqx5MhgA/feedshare-shrink_2048_1536/feedshare-shrink_2048_1536/0/1693334918018?e=2147483647&v=beta&t=ZvaqKgq3DLz-wcZutuTsxDUeKf5atvqaQHgI53CUAf8")) { image in
        image
          .defaultOptions()
          .clipShape(Circle())
        
      } placeholder: {
        ProgressView()
      }
      .frame(width: 96, height: 96)
      
      VStack {
        Text("Leonardo")
          .styledText(
            .customBlack,
            24,
            .semibold
          )
        
        Text("email")
          .styledText(
            .customGray,
            14
          )
      }
      
      ZStack {
        RoundedRectangle(cornerRadius: 12)
          .fill(Color.customWhite)
          .shadow(color: .customBlack.opacity(0.15), radius: 3, y: 2)
        
        HStack {
          ForEach(0..<stat.count, id: \.self) { index in
            Spacer()
            
            VStack(spacing: 10) {
              Text(stat[index].title)
                .styledText(
                  .customBlack,
                  16,
                  .semibold
                )
              
              Text("\(stat[index].count)")
                .styledText(
                  .customVine,
                  14,
                  .semibold
                )
            }
            
            Spacer()
            
            if index != stat.count - 1 {
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
  ProfileStatistic()
}
