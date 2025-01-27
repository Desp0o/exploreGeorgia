//
//  CustomTabBar.swift
//  exploreGeorgia
//
//  Created by Despo on 07.01.25.
//

import SwiftUI

struct VocabularyViewControllerWrapper: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> VocabularyVC {
    return VocabularyVC()
  }
  
  func updateUIViewController(_ uiViewController: VocabularyVC, context: Context) {}
}

struct CustomTabBar: View {
  @StateObject private var vm = CustomTabBarViewModel()
  @State private var currentIdenx = 0
  
  var body: some View {
    VStack(spacing: 0) {
      ZStack {
        switch currentIdenx {
        case 0:
          NavigationStack {
            MainView(tabIndex: $currentIdenx)
          }
        case 1:
          NavigationStack {
            ExploreView()
          }
        case 2:
          NavigationStack {
            FoodView()
          }
        case 3:
          VocabularyViewControllerWrapper()
        case 4:
          NavigationStack {
            ProfileView()
          }
        default:
          VStack {
            Text("Default Tab")
          }
        }
      }
      
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
                .frame(width: 24, height: 24)
            }
            
            Text(item.title)
              .styledText(currentIdenx == index ? Color.customBlue : Color.customGray, 12)
          }
          
          Spacer()
        }
      }
      .padding(.bottom, 10)
      .padding(.horizontal, 20)
      .frame(maxWidth: .infinity)
      .frame(height: 70)
      .background(.primaryWhite)
      .clipShape(
        .rect(
          topLeadingRadius: 12,
          bottomLeadingRadius: 0,
          bottomTrailingRadius: 0,
          topTrailingRadius: 12
        )
      )
      .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: -2)
    }
    .ignoresSafeArea(.container, edges: .bottom)
    .background(.primaryWhite)
    .toolbar(.hidden, for: .navigationBar)
    .padding(.top, (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets.top ?? 0)
  }
}
