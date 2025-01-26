//
//  ProfileStatisticComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import SwiftUI

struct ProfileStatisticComponent: View {
  @EnvironmentObject var vm: ProfileViewModel
  
  var body: some View {
    VStack() {
      CachedAsyncImage(url: URL(string: vm.user?.avatar ?? ""))
        .clipShape(Circle())
        .frame(width: 96, height: 96)
      
      VStack {
        Text(vm.user?.firstName ?? "")
          .styledText(.customBlack, 24, .semibold)
        
        Text(vm.user?.email ?? "")
          .styledText(.customGray, 14)
      }
      
      ZStack {
        RoundedRectangle(cornerRadius: 12)
          .fill(Color.customWhite)
          .shadow(color: .black.opacity(0.25), radius: 3, y: 2)
        
        HStack {
          ForEach(0..<vm.profileStatistic.count, id: \.self) { index in
            Spacer()
            
            VStack(spacing: 10) {
              Text(vm.profileStatistic[index].title)
                .styledText(.customBlack, 16, .semibold)
              
              Text("\(vm.profileStatistic[index].count)")
                .styledText(.customBlue, 14, .semibold)
            }
            
            Spacer()
            
            if index != vm.profileStatistic.count - 1 {
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
