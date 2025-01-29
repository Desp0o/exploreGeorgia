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
      Image(icon.rawValue)
        .defaultOptions(color: .white)
        .frame(width: 32, height: 32)
        .padding(8)
        .background(.customGreen)
        .clipShape(Circle())
    }
    .frame(width: 40, height: 40)
    .offset(x: -20, y: -20)
    .zIndex(3)
    .scaleEffect(addButtonScale)
    .onAppear {
      Task { @MainActor in
        try? await Task.sleep(for: .seconds(0.5))
        withAnimation(.bouncy) {
          addButtonScale = 1
        }
      }
    }
  }
}
