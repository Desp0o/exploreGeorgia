//
//  CustomTabBar.swift
//  exploreGeorgia
//
//  Created by Despo on 07.01.25.
//

import SwiftUI

struct CustomTabBar: View {
  @StateObject private var vm = CustomTabBarViewModel()
  @State private var currentIdenx = 0
  
  var body: some View {
    NavigationStack {
      VStack {
        ZStack {
          switch currentIdenx {
          case 0:
            MainView()
          case 1:
            VStack {
              Text("Explore")
                .background(.blue)
            }
          case 2:
            VStack {
              Text("Notifications")
                .background(.green)
            }
          case 3:
            VStack {
              Text("Messages")
                .background(.yellow)
            }
          case 4:
            ProfileView()
          default:
            VStack {
              Text("Default Tab")
            }
          }
        }
        
        Spacer()
        
        VStack {
          HStack {
            ForEach(0..<vm.tabItems.count, id: \.self) { index in
              let item = vm.tabItems[index]
              Spacer()
              
              VStack(alignment: .center) {
                Button {
                  currentIdenx = index
                } label: {
                  Image(currentIdenx == index ? item.activeIcon : item.inactiveIcon)
                    .resizable()
                    .scaledToFill()
                    .frame(
                      width: 24,
                      height: 24
                    )
                }
                
                Text(item.title)
                  .styledText(
                    currentIdenx == index ? Color.customVine : Color.customGray,
                    12)
              }
              
              Spacer()
            }
          }
          .padding(.horizontal, 20)
          .frame(maxWidth: .infinity)
        }
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity)
        .frame(height: 70)
        .background(.customWhite)
        .clipShape(
          .rect(
            topLeadingRadius: 12,
            bottomLeadingRadius: 0,
            bottomTrailingRadius: 0,
            topTrailingRadius: 12
          )
        )
        .shadow(color: .customBlack.opacity(0.1), radius: 2, x: 0, y: -2)
      }
      .ignoresSafeArea(.container, edges: .bottom)
    }
    .background(.primaryWhite)
    .toolbar(.hidden, for: .navigationBar)
    .padding(.top, (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets.top ?? 0)
  }
}

#Preview {
  CustomTabBar()
}
