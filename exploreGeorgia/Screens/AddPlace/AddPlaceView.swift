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
  @Binding var isAppeared: Bool
  @State var currentLocationForUse: Location?
  @State private var alertBoxMessage = ""
  
  var body: some View {
    ZStack(alignment: .top) {
      if toastManager.isShown {
        ToastView(
          message: "Your travel memory has been successfully added!",
          bgColor: .green
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
        HStack {
          Button {
            dismiss()
          } label: {
            Image(systemName: "xmark.circle.fill")
              .resizable()
              .scaledToFill()
              .foregroundStyle(.customBlue)
              .frame(width: 40, height: 40)
          }
          .padding(.horizontal, 20)
          
          Spacer()
        }
        
        VStack(spacing: 20) {
          Text("Map Your Adventures")
            .styledText(.customBlue, 22, .bold)
          
          Spacer().frame(height: 10)
          
          CoverUploadComponent(
            choosenCover: vm.choosenCover,
            selectedCoverFromPicker: $vm.selectedCoverFromPicker
          )
          
          VStack(spacing: 20) {
            TextField("Place Title", text: $vm.placeName)
              .styledTextField()
            
            TextField("Place Address", text: $vm.placeAdress)
              .styledTextField()
            
            TextField("Price or leave it blank", text: $vm.placePrice)
              .styledTextField()
              .keyboardType(.numberPad)
            
            TextEditorComponent(textForEditor: $vm.placeDescription)
          }
          
          Button {
            isPresented.toggle()
          } label: {
            Text("Add Place on Map")
              .styledText(.customBlue, 16, .semibold)
              .frame(maxWidth: .infinity)
              .frame(height: 40)
              .background(.customWhite)
              .roundedCorners(12)
          }
          .customBorderedButton(height: 40, borderColor: .customBlue)
          
          PlaceTypePicker(selectedPlace: $vm.selectedPlace, placeTypes: vm.placeType)
          
          AlbumAddComponent(
            selectedAlbum: $vm.selectedAlbum,
            choosenAlbum: vm.choosenAlbum
          )
          
          Button {
            vm.latitude = currentLocationForUse?.coordinate.latitude ?? 0
            vm.longitude = currentLocationForUse?.coordinate.longitude ?? 0
            vm.addPlace()
          } label: {
            Text("Add Place")
              .styledText(.buttonPrimary, 18, .bold)
              .frame(maxWidth: .infinity)
              .padding()
              .background(Color.customBlue)
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
      .onDisappear {
        isAppeared.toggle()
      }
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
      }
    }
    .sheet(isPresented: $isPresented) {
      if let coordinate = locationManager.lastKnownLocation {
        MapViewReusable(
          latitudeProp: coordinate.latitude,
          longitudeProp: coordinate.longitude,
          locationName: vm.placeName,
          isEditable: true,
          currentLocationForUse: $currentLocationForUse
        )
      }
    }
  }
}
