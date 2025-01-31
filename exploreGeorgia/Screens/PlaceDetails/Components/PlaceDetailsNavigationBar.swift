//
//  PlaceDetailsNavigationBar.swift
//  exploreGeorgia
//
//  Created by Despo on 13.01.25.
//

import SwiftUI

struct PlaceDetailsNavigationBar: View {
  @Environment(\.presentationMode) var presentationMode
  @StateObject var bookmarkManager = BookMarkManager()
  @ObservedObject var toastManager = ToastManager()
  @Binding var isBookMarked: Bool
  let placeID: String
  
  var body: some View {
    HStack {
      Button {
        presentationMode.wrappedValue.dismiss()
      } label: {
        ZStack {
          OverlayActionButtonIcon(iconName: .backButton, scale: 0.9)
        }
      }
      
      Spacer()
      
      Button {
        bookmarkManager.savePlaceInBookmark(placeId: placeID, isBookmarked: isBookMarked)
        isBookMarked.toggle()
      } label: {
        OverlayActionButtonIcon(
          iconName: isBookMarked ? .bookmarkActive : .bookmarkInactive,
          scale: 0.9
        )
      }
    }
    .padding(.top, (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets.top ?? 0)
    .frame(width: UIScreen.main.bounds.width - 20)
    .zIndex(10)
    .onReceive(bookmarkManager.$isError) { isError in
      if isError {
        toastManager.showToast()
      }
    }
    .overlay {
      if toastManager.isShown {
        VStack {
          ToastView(message: "Please try again later.", bgColor: .error)
        }
        .offset(y: 15)
      }
    }
  }
}
