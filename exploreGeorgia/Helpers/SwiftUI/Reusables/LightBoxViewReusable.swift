//
//  LightBoxViewReusable.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import SwiftUI

struct LightBoxViewReusable: View {
  @Binding var selectedImage: String
  @Binding var isLightBoxVisible: Bool
  @State private var scale: CGFloat = 1.0
  @State private var imageScale: CGFloat = 0.5
  let wid: CGFloat = 40
  var album: [String]
  @State private var currentIndex: Int = 0
  
  var body: some View {
    ZStack{
      Color.black.opacity(0.7)
      
      VStack {
        AsyncImage(url: URL(string: selectedImage)) { image in
          image
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: .infinity)
            .transition(.opacity)
        } placeholder: {
          ProgressView()
            .scaleEffect(1.5)
            .foregroundStyle(.customBlue)
        }
        .animation(.easeInOut(duration: 0.3), value: selectedImage)
        .scaleEffect(scale)
        .gesture(
          SimultaneousGesture (
            MagnificationGesture()
              .onChanged { value in
                scale = min(max(1.0, value), 4.0)
              }
              .onEnded { _ in
                withAnimation(.easeOut(duration: 0.3)) {
                  scale = 1.0
                }
              },
            
            DragGesture()
              .onEnded { value in
                withAnimation {
                  if value.translation.width < -50 {
                    goToNextImage()
                  } else if value.translation.width > 50 {
                    goToPreviousImage()
                  }
                }
              }
          )
        )
      }
      .scaleEffect(imageScale)
      .onAppear {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 1.0)) {
          imageScale = 1.0
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .zIndex(4)
    .onAppear {
      if let index = album.firstIndex(of: selectedImage) {
        currentIndex = index
      }
    }
    .onTapGesture {
      selectedImage = ""
      isLightBoxVisible = false
    }
  }
  
  private func goToNextImage() {
    if !album.isEmpty {
      withAnimation {
        currentIndex = (currentIndex + 1) % album.count
        selectedImage = album[currentIndex]
      }
    }
  }
  
  private func goToPreviousImage() {
    if !album.isEmpty {
      withAnimation {
        currentIndex = (currentIndex - 1 + album.count) % album.count
        selectedImage = album[currentIndex]
      }
    }
  }
}
