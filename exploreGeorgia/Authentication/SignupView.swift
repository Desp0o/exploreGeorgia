//
//  SignupView.swift
//  exploreGeorgia
//
//  Created by Despo on 26.12.24.
//

import SwiftUI

struct SignupView: View {
  @StateObject private var vm = SignupViewModel()
  
  var body: some View {
    Text("singu")
    TextField("შეიყვანე იმეილი", text: $vm.email)
    
    SecureField("შეიყვანე parol", text: $vm.password)
    
    Button {
      vm.signUpUser()
    } label: {
      Text("auth me")
    }
    
  }
}


#Preview {
  SignupView()
}
