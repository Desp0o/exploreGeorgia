//
//  AddButtonComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 16.01.25.
//

import SwiftUI

struct AddButtonComponent: View {
  @Binding var addButtonScale: CGFloat
  @Binding var isPresented: Bool
  let icon: IconsEnum
  
  var body: some View {
    Button {
      isPresented.toggle()
    } label: {
      Image(systemName: icon.rawValue)
        .resizable()
        .scaledToFit()
        .tint(.gold)
    }
    .frame(width: 40, height: 40)
    .offset(x: -20, y: -20)
    .zIndex(3)
    .scaleEffect(addButtonScale)
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        withAnimation(.bouncy) {
          addButtonScale = 1
        }
      }
    }
  }
}
