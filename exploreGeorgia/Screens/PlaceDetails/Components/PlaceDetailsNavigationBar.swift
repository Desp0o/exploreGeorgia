//
//  PlaceDetailsNavigationBar.swift
//  exploreGeorgia
//
//  Created by Despo on 13.01.25.
//

import SwiftUI

struct PlaceDetailsNavigationBar: View {
  @Environment(\.dismiss) var dismiss
  @ObservedObject var bookmarkManager = BookMarkManager()
  @Binding var isBookMarked: Bool
  let placeID: String
  
  var body: some View {
    HStack {
      Button {
        dismiss()
      } label: {
        ZStack {
          Circle()
            .fill(.customWhite.opacity(0.5))
            .frame(width: 40, height: 40)
          
          Image("backArrow")
            .renderingMode(.template)
            .foregroundStyle(.white)
        }
      }
      
      Spacer()
      
      Button {
        bookmarkManager.savePlaceInBookmark(placeId: placeID, isBookmarked: isBookMarked)
        isBookMarked.toggle()
      } label: {
        ZStack {
          Circle()
            .fill(.customWhite.opacity(0.5))
            .frame(width: 40, height: 40)
          
          Image(systemName: isBookMarked ? "bookmark.fill" : "bookmark")
            .renderingMode(.template)
            .foregroundStyle(.white)
        }
      }
    }
    .padding(.top, (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets.top ?? 0)
    .frame(width: UIScreen.main.bounds.width - 20)
    .zIndex(2)
  }
}
//
//#Preview {
//  NavigationBarReusable()
//}
