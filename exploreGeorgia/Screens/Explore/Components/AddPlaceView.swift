//
//  AddPlaceView.swift
//  exploreGeorgia
//
//  Created by Despo on 16.01.25.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct AddPlaceView: View {
  @ObservedObject var vm = AddPlaceViewModel()
  @State var isPresented = false
  @Binding var isAppeared: Bool
  
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        Text("Add Favorite Page")
          .styledText(.customBlue, 16, .semibold)
        
        // Avatar and Upload Button
        HStack(spacing: 20) {
          if let image = vm.choosenCover {
            Image(uiImage: image)
              .defaultOptions()
              .frame(width: 40, height: 40)
              .clipShape(RoundedRectangle(cornerRadius: 12))
          } else {
            Image("imagePlaceholder")
              .defaultOptions()
              .frame(width: 40, height: 40)
              .clipShape(RoundedRectangle(cornerRadius: 12))
          }
          
          Spacer()
          
          PhotosPicker(selection: $vm.selectedCoverFromPicker) {
            Text("Upload Cover")
              .styledText(.customBlue, 16, .semibold)
              .frame(maxWidth: .infinity)
              .frame(height: 40)
              .overlay(
                RoundedRectangle(cornerRadius: 12)
                  .stroke(.customBlue, lineWidth: 1)
              )
          }
        }
        
        // Text Inputs
        VStack(spacing: 20) {
          TextField("Place Title", text: $vm.placeName)
            .styledTextField()
          
          TextField("Place Address", text: $vm.placeAdress)
            .styledTextField()
          
          TextField("Price or leave it blank", text: $vm.placePrice)
            .styledTextField()
            .keyboardType(.numberPad)
          
          VStack(alignment: .leading) {
            Text("Add Place Description")
              .styledText(.customBlack, 15)
            
            ZStack {
              Color.customWhite
              
              TextEditor(text: $vm.placeDescription)
                .scrollContentBackground(.hidden)
                .frame(height: 200)
                .frame(maxWidth: .infinity, maxHeight: 300)
                .roundedCorners(12)
                .overlay(
                  RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.customBlue, lineWidth: 1)
                )
            }
          }
        }
        
        // Map Button
        Button {
          isPresented.toggle()
        } label: {
          Text("Add Place on Map")
            .styledText(.customBlue, 16, .semibold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.customWhite)
            .roundedCorners(12)
        }
        .customBorderedButton(height: 40, borderColor: .customBlue)
        
        // Place Type Picker
        Picker("Place Type", selection: $vm.selectedPlace) {
          ForEach(vm.placeType, id: \.self) { type in
            Text(type.rawValue)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
        .onAppear {
          UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.customBlue)
          UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor.white],
            for: .selected
          )
        }
        
        // Album Picker
        VStack(spacing: 10) {
          PhotosPicker(selection: $vm.selectedAlbum, maxSelectionCount: 5) {
            Text("Tap to Upload Photos")
              .styledText(.customBlue, 16, .semibold)
              .frame(maxWidth: .infinity)
              .frame(height: 40)
              .overlay(
                RoundedRectangle(cornerRadius: 12)
                  .stroke(.customBlue, lineWidth: 1)
              )
          }
          
          HStack(spacing: 10) {
            ForEach(Array(vm.choosenAlbum.enumerated()), id: \.offset) { _, image in
              Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
          }
        }
        .frame(height: 110, alignment: .top)
        // Add Place Button
        Button {
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
      .padding(.vertical, 50)
    }
    .scrollBounceBehavior(.basedOnSize)
    .scrollIndicators(.hidden)
    .onDisappear {
      isAppeared.toggle()
    }
    .sheet(isPresented: $isPresented) {
      Text("Hello World")
    }
  }
}
