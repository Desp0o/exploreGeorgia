//
//  IntrestingFacts.swift
//  exploreGeorgia
//
//  Created by Despo on 15.01.25.
//

import SwiftUI

struct IntrestingFacts: View {
  @ObservedObject var vm: MainViewModel
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Text("Did you know")
          .styledText(
            .customBlue,
            20,
            .semibold
          )
        Image(systemName: "lightbulb.max.fill")
          .foregroundStyle(.yellow)
      }
      Text(vm.randomFact)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.all, 12)
    .background(.customWhite)
    .roundedCorners(12)
    .id(vm.randomFact)
  }
}
