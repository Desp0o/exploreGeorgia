//
//  EditProfile.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import SwiftUI
import PhotosUI

struct EditProfile: View {
  @Environment(\.colorScheme) var colorScheme  // Add this
  @StateObject private var vm = EditProfileViewModel()
  @ObservedObject private var toastManager = ToastManager()
  @ObservedObject private var alertManager = CustomAlertManager()
  @State private var showInput = false
  @State private var toastMessage = ""
  @State private var alertBoxMessage = ""
  @AppStorage("isDarkTheme") private var isDarkTheme = UITraitCollection.current.userInterfaceStyle == .dark
  
  var body: some View {
    ZStack(alignment: .top) {
      Color.primaryWhite.ignoresSafeArea()
      
      Button {
        isDarkTheme.toggle()
      } label: {
        Text("click mode")
      }
      
      if toastManager.isShown {
        ToastView(
          message: toastMessage,
          bgColor: .green
        )
      }
      
      if alertManager.isShown {
        CustomAlert(
          alertManager: alertManager,
          alertMessage: "alert message",
          errorType: .error
        )
        .zIndex(999)
      }
      
      VStack{
        if vm.isUpdatignInfo {
          ProgressView()
            .scaleEffect(2.0)
            .tint(.customVine)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .zIndex(99)
      
      ScrollView {
        Button {
          alertManager.showAlert()
        } label: {
          Text("show alert")
        }
        
        
        if vm.isLoading {
          VStack {
            ProgressView()
              .scaleEffect(2.0)
              .tint(.customBlue)
          }
          .frame(maxWidth: .infinity)
        } else {
          VStack(spacing: 50) {
            
            VStack(spacing: 20) {
              
              if let image = vm.choosenAvatar {
                Image(uiImage: image)
                  .defaultOptions()
                  .clipShape(Circle())
                  .frame(width: 96, height: 96)
              } else {
                AsyncImage(url: URL(string: vm.currentAvatar)) { image in
                  image
                    .defaultOptions()
                    .clipShape(Circle())
                } placeholder: {
                  ProgressView()
                }
                .frame(width: 96, height: 96)
              }
              
              PhotosPicker(selection: $vm.selectedAvatarFromPicker) {
                Text("Change profile photo")
                  .styledText(
                    .customVine,
                    16,
                    .semibold
                  )
              }
            }
            
            VStack(spacing: 20) {
              TextField("First name", text: $vm.firstName)
                .styledTextField()
              
              TextField("Last name", text: $vm.lastName)
                .styledTextField()
              
              Picker("Gender", selection: $vm.gender) {
                ForEach(vm.genderOptions, id: \.self) { gender in
                  Text(gender)
                }
              }
              .pickerStyle(.segmented)
              .onAppear {
                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.customBlue)
                let attributes: [NSAttributedString.Key: Any] = [
                  .foregroundColor: UIColor.white
                ]
                UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
                UISegmentedControl.appearance().isSpringLoaded = true
                
                UISegmentedControl.appearance().backgroundColor = .customWhite
              }
              
              Button {
                vm.updateUser()
              } label: {
                Text("Update personal info")
                  .styledText(.customWhite, 16, .bold)
              }
              .customStyledButton()
            }
            
            if !vm.isUserFromGoogle {
              VStack(spacing: 20) {
                SecureField("Enter your password", text: $vm.password)
                  .styledSecureFIeld()
                
                SecureField("Repeat password", text: $vm.rePassword)
                  .styledSecureFIeld()
                
                Button {
                  vm.updatePassword()
                } label: {
                  Text("Update password")
                    .styledText(.customWhite, 16, .bold)
                }
                .customStyledButton()
              }
            }
            
            VStack(spacing: 20) {
              if showInput && !vm.isUserFromGoogle {
                SecureField("Enter password for delete account", text: $vm.passwordForDelete)
                  .styledSecureFIeld()
              }
              
              HStack(spacing: 20) {
                Button {
                  withAnimation(.linear(duration: 0.2)) {
                    if !showInput {
                      showInput = true
                    } else {
                      vm.userAccountDelete()
                    }
                  }
                } label: {
                  Text("Delete account")
                    .styledText(.customWhite)
                }
                .customStyledButton(bg: showInput ? .red : .customBlue)
                
                if showInput {
                  Button {
                    withAnimation(.linear(duration: 0.2)) {
                      showInput.toggle()
                    }
                  } label: {
                    Text("Cancel")
                      .styledText(
                        .customWhite,
                        18,
                        .bold
                      )
                  }
                  .customStyledButton()
                }
              }
            }
          }
          .padding(.horizontal, 20)
        }
      }
      .padding(.vertical, 50)
      .scrollBounceBehavior(.basedOnSize)
      .scrollIndicators(.hidden)
    }
    .preferredColorScheme(isDarkTheme ? .dark : .light)
    .onReceive(vm.$completionMessage) { message in
      if !message.isEmpty {
        toastMessage = message
        toastManager.showToast()
      }
    }
    .onReceive(vm.$errorMessage) { error in
      if !error.isEmpty {
        alertBoxMessage = error
        alertManager.showAlert()
      }
    }
  }
  
}


#Preview {
  EditProfile()
}
