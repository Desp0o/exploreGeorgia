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
  @State private var lastScale: CGFloat = 1.0
  @State private var dragOffset: CGSize = .zero
  @State private var lastDragOffset: CGSize = .zero
  var album: [String]
  @State private var currentIndex: Int = 0
  
  var body: some View {
    ZStack {
      Color.black.opacity(0.7)
        .ignoresSafeArea()
      
      VStack {
        AsyncImage(url: URL(string: selectedImage)) { image in
          image
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: UIScreen.main.bounds.width - 20)
            .transition(.opacity)
        } placeholder: {
          ProgressView()
            .scaleEffect(1.5)
            .tint(.customGreen)
            .frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: .infinity)
            .background(Color.clear)
        }
        .id(selectedImage)
        .scaleEffect(scale)
        .offset(dragOffset)
        .gesture(
          SimultaneousGesture(
            MagnificationGesture()
              .onChanged { value in
                let newScale = lastScale * value
                scale = min(max(1.0, newScale), 6.0)
              }
              .onEnded { value in
                lastScale = scale
              },
            SimultaneousGesture(
              DragGesture()
                .onChanged { value in
                  if scale > 1.0 {
                    dragOffset = CGSize(
                      width: lastDragOffset.width + value.translation.width,
                      height: lastDragOffset.height + value.translation.height
                    )
                  }
                }
                .onEnded { value in
                  if scale > 1.0 {
                    lastDragOffset = dragOffset
                  } else {
                    withAnimation {
                      resetImagePosition()
                    }
                  }
                },
              SimultaneousGesture(
                DragGesture()
                  .onEnded { value in
                    if scale == 1.0 {
                      withAnimation {
                        if value.translation.width < -50 {
                          goToNextImage()
                        } else if value.translation.width > 50 {
                          goToPreviousImage()
                        }
                      }
                    }
                  },
                TapGesture(count: 1)
                  .onEnded { _ in
                    withAnimation(.easeIn) {
                      resetImagePosition()
                      scale = 1.0
                      lastScale = 1.0
                    }
                  }
              )
            )
          )
        )
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .zIndex(4)
    .onTapGesture {
      selectedImage = ""
      isLightBoxVisible = false
    }
    .animation(.easeInOut(duration: 0.3), value: currentIndex)
  }
  
  private func goToNextImage() {
    if !album.isEmpty {
      withAnimation {
        currentIndex = (currentIndex + 1) % album.count
        selectedImage = album[currentIndex]
        resetImagePosition()
      }
    }
  }
  
  private func goToPreviousImage() {
    if !album.isEmpty {
      withAnimation {
        currentIndex = (currentIndex - 1 + album.count) % album.count
        selectedImage = album[currentIndex]
        resetImagePosition()
      }
    }
  }
  
  private func resetImagePosition() {
    dragOffset = .zero
    lastDragOffset = .zero
  }
}
