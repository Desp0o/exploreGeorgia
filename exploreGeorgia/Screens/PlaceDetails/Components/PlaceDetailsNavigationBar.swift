//
//  PlaceDetailsNavigationBar.swift
//  exploreGeorgia
//
//  Created by Despo on 13.01.25.
//

import SwiftUI

struct PlaceDetailsNavigationBar: View {
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var bookmarkManager = BookMarkManager()
  @Binding var isBookMarked: Bool
  let placeID: String
  
  var body: some View {
    HStack {
      Button {
        presentationMode.wrappedValue.dismiss()
      } label: {
        ZStack {
          OverlayActionButtonIcon(iconName: .backButton, tint: .white, scale: 0.9)
        }
      }
      
      Spacer()
      
      Button {
        bookmarkManager.savePlaceInBookmark(placeId: placeID, isBookmarked: isBookMarked)
        isBookMarked.toggle()
      } label: {
        OverlayActionButtonIcon(
          iconName: isBookMarked ? .bookmarkActive : .bookmarkInactive,
          tint: .white,
          scale: 0.9
        )
      }
    }
    .padding(.top, (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets.top ?? 0)
    .frame(width: UIScreen.main.bounds.width - 20)
    .zIndex(2)
  }
}
