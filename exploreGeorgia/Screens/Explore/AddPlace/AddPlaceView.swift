//
//  AddPlaceView.swift
//  exploreGeorgia
//
//  Created by Despo on 16.01.25.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct AddPlaceView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject private var locationManager = LocationManager()
  @ObservedObject var vm = AddPlaceViewModel()
  @ObservedObject var alertManager = CustomAlertManager()
  @ObservedObject private var toastManager = ToastManager()
  @State var isPresented = false
  @State var currentLocationForUse: Location?
  @State private var alertBoxMessage = ""
  @Binding var isNewPlaceAdded: Bool
  
  var body: some View {
    ZStack(alignment: .top) {
      if toastManager.isShown {
        ToastView(
          message: "Your travel memory has been successfully added!",
          bgColor: .successfully
        )
      }
      
      if vm.isLoading {
        AddPlaceLoadingComponent()
      }
      
      if alertManager.isShown {
        CustomAlert(
          alertManager: alertManager,
          alertMessage: alertBoxMessage,
          errorType: .error
        )
        .zIndex(999)
      }
      
      ScrollView {
        ZStack(alignment: .leading) {
          Button {
            dismiss()
          } label: {
            OverlayActionButtonIcon(iconName: .xmark)
          }
          .padding(.horizontal, 20)
          
          VStack {
            Text("Map Your Adventures")
              .styledText(.customGreen, 22, .bold)
              .frame(maxWidth: .infinity, alignment: .center)
          }
        }
        .padding(.top, 20)
        
        VStack(spacing: 20) {
          CoverUploadComponent(vm: vm)
          
          VStack(spacing: 20) {
            TextField("Place name", text: $vm.placeName)
              .styledTextField()
            
            TextField("City", text: $vm.placeCity)
              .styledTextField()
            
            TextField("Address", text: $vm.placeAdress)
              .styledTextField()
            
            TextField("Price (optional)", text: $vm.placePrice)
              .styledTextField()
              .keyboardType(.numberPad)
            
            TextEditorComponent(textForEditor: $vm.placeDescription, placeholder: "Write place description...")
              .frame(minHeight: 50)
          }
          
          Button {
            isPresented.toggle()
          } label: {
            Text("Add Place on Map")
              .styledText(.customGreen, 16, .semibold)
              .frame(maxWidth: .infinity)
              .frame(height: 40)
              .background(.customWhite)
              .roundedCorners(12)
          }
          .customBorderedButton(height: 40, borderColor: .customGreen)
          
          PlaceTypePicker(vm: vm)
          
          AlbumAddComponent(vm: vm)
          
          Button {
            vm.latitude = currentLocationForUse?.coordinate.latitude ?? 0
            vm.longitude = currentLocationForUse?.coordinate.longitude ?? 0
            hideKeyboard()
            vm.addPlace()
          } label: {
            Text("Add Place")
              .styledText(.buttonPrimary, 18, .bold)
              .frame(maxWidth: .infinity)
              .padding()
              .background(Color.customGreen)
              .roundedCorners(12)
          }
          .customStyledButton()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 50)
      }
      .scrollBounceBehavior(.basedOnSize)
      .scrollIndicators(.hidden)
    }
    .onTapGesture {
      hideKeyboard()
    }
    .onReceive(vm.$errorMessage) { error in
      if !error.isEmpty {
        alertBoxMessage = error
        alertManager.showAlert()
      }
    }
    .onReceive(vm.$isSuccessfullyAdded) { isSuccessed in
      if isSuccessed {
        toastManager.showToast()
        isNewPlaceAdded = true
      }
    }
    .sheet(isPresented: $isPresented) {
      if let coordinate = locationManager.lastKnownLocation {
        MapViewReusable(
          latitudeProp: coordinate.latitude,
          longitudeProp: coordinate.longitude,
          locationName: "",
          isEditable: true,
          currentLocationForUse: $currentLocationForUse
        )
      } else {
        Text("Turn on location to continue")
      }
    }
  }
}
