//
//  ToutView.swift
//  exploreGeorgia
//
//  Created by Despo on 18.01.25.
//

import SwiftUI

public var album = [
  "https://passportandstamps.com/wp-content/uploads/2023/10/Kelingking-Beach-Drone-View-from-Above-1024x768.jpg",
  "https://www.createtravel.tv/wp-content/uploads/2024/03/Balis-Nusa-Penida.webp",
  "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/f5/3e/e5/nusa-penida-island.jpg?w=900&h=500&s=1",
  "https://passportandstamps.com/wp-content/uploads/2023/10/Kelingking-Beach-Drone-View-from-Above-1024x768.jpg",
  "https://www.createtravel.tv/wp-content/uploads/2024/03/Balis-Nusa-Penida.webp",
  "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/f5/3e/e5/nusa-penida-island.jpg?w=900&h=500&s=1",
  "https://passportandstamps.com/wp-content/uploads/2023/10/Kelingking-Beach-Drone-View-from-Above-1024x768.jpg",
  "https://www.createtravel.tv/wp-content/uploads/2024/03/Balis-Nusa-Penida.webp",
  "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/f5/3e/e5/nusa-penida-island.jpg?w=900&h=500&s=1"
]

struct ToutView: View {
  @State var satestobOokmarki = false
  @State var selectedImage = ""
  @State var isLightBoxVisible = false
  
  var body: some View {
    ZStack(alignment: .top) {
      Color.primaryWhite.ignoresSafeArea()
      
      VStack {
        //MARK: header
        ZStack(alignment: .bottomLeading) {
          CachedAsyncImage(url: URL(string: "https://www.thetimes.com/imageserver/image/%2Fmethode%2Ftimes%2Fprod%2Fweb%2Fbin%2F46844835-f865-4f0b-87f5-9dc764fdff19.jpg?crop=1564%2C880%2C318%2C0"))
            .frame(width: UIScreen.main.bounds.width, height: 315)
            .roundedCorners(12)
          
          VStack(alignment: .leading, spacing: 0) {
            Text("Nussa Peddina")
              .styledText(.white, 24, .semibold)
            
            HStack {
              Image("locationPin")
                .renderingMode(.template)
                .foregroundStyle(.white)
              
              Text("Bali")
                .styledText(.white, 18)
              
              Spacer()
            }
          }
          .padding(.leading, 20)
          .padding(.bottom, 20)
        }
        .overlay {
          ZStack() {
            PlaceDetailsNavigationBar(isBookMarked: $satestobOokmarki, placeID: "")
          }
          .frame(maxHeight: .infinity, alignment: .top)
        }
        
        //MARK: Scroll
        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack(spacing: 12) {
            ForEach(album.indices, id: \.self) { index in
              let image = album[index]
              
              CachedAsyncImage(url: URL(string: image))
                .frame(width: 52, height: 52)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .onTapGesture {
                  selectedImage = image
                  isLightBoxVisible = true
                }
            }
          }
          .padding(.horizontal, 10)
        }
        .background(
          RoundedRectangle(cornerRadius: 12)
            .fill(Color.customWhite)
        )
        .padding(.horizontal, 20)
        .frame(height: 76)
        .frame(maxWidth: .infinity)
      }
      
    }
    .overlay {
      if isLightBoxVisible {
        LightBoxViewReusable(
          selectedImage: $selectedImage,
          isLightBoxVisible: $isLightBoxVisible,
          album: album
        )
        .ignoresSafeArea(.all)
      }
    }
    .ignoresSafeArea()
  }
}

#Preview {
  ToutView()
    .preferredColorScheme(.dark)
}

#Preview {
  ToutView()
    .preferredColorScheme(.light)
}
