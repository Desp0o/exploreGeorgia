//
//  MainView.swift
//  exploreGeorgia
//
//  Created by Despo on 05.01.25.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
  let vm  = AuthManager()
  
    var body: some View {
      VStack{
        Text("Hello World")
        Button {
          Task {
            try await vm.userLogOut()
          }
        } label: {
          Text("Log Out")
        }
      }
    }
}

#Preview {
    MainView()
}
