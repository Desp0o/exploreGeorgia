//
//  TextEditorComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 17.01.25.
//

import SwiftUI

struct TextEditorComponent: View {
  @Binding var textForEditor: String
  
  var body: some View {
    ZStack {
      Color.customWhite.roundedCorners(12)
      
      TextEditor(text: $textForEditor)
        .scrollContentBackground(.hidden)
        .frame(height: 200)
        .frame(maxWidth: .infinity, maxHeight: 300)
        .roundedCorners(12)
        .padding(10)
        .background(
          ZStack {
            Text(!textForEditor.isEmpty ? "" : "Add place description...")
              .foregroundStyle(.gray.opacity(0.6))
          }
            .padding(.horizontal, 15)
            .padding(.vertical, 18)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        )
        .overlay(
          RoundedRectangle(cornerRadius: 12)
            .stroke(Color.customBlue, lineWidth: 1)
        )
    }
  }
}
