//
//  IntrestingFacts.swift
//  exploreGeorgia
//
//  Created by Despo on 15.01.25.
//

import SwiftUI

struct IntrestingFacts: View {
  @EnvironmentObject var vm: MainViewModel
  @State private var currentFatc = 0
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        HStack {
          Text("Did you know")
            .styledText(.customBlue, 20, .semibold)
          Image(systemName: "lightbulb.max.fill")
            .foregroundStyle(.yellow)
        }
        
        Spacer()
        
        Button {
          if currentFatc == vm.intrestingFacts.count - 1 {
            currentFatc = 0
          } else {
            currentFatc += 1
          }
        } label: {
          Text("Next fact")
            .styledText(.customBlue, 16, .semibold)
        }
      }
      if !vm.intrestingFacts.isEmpty {
        Text(vm.intrestingFacts[currentFatc].fact)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.all, 12)
    .background(.customWhite)
    .roundedCorners(12)
    .id(currentFatc)
    .shadow(color: .black.opacity(0.25), radius: 4, y: 2)
  }
}
