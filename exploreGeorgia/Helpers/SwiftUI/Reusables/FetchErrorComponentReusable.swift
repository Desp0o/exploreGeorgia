//
//  FetchErrorComponentReusable.swift
//  exploreGeorgia
//
//  Created by Despo on 23.01.25.
//

import SwiftUI

struct FetchErrorComponentReusable: View {
  @Environment(\.dismiss) var dismiss
  var body: some View {
    VStack {
      Text(CustomErrorsMessage.fetchError.rawValue)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.primaryWhite)
    .padding(.top, (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets.top ?? 0)
  }
}

#Preview {
  FetchErrorComponentReusable()
}
