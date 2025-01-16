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
      VStack {
        Text("add favorite page")
          .styledText(
            .customBlue,
            16,
            .semibold
          )
        
        HStack {
          
          if let image = vm.choosenCover {
            Image(uiImage: image)
              .defaultOptions()
              .clipShape(RoundedRectangle(cornerRadius: 12))
              .frame(width: 40, height: 40)
          } else {
            Image("imagePlaceholder")
              .defaultOptions()
              .clipShape(RoundedRectangle(cornerRadius: 12))
              .frame(width: 40, height: 40)
          }
          
          PhotosPicker(selection: $vm.selectedCoverFromPicker) {
            Text("Tap to upload profile photo")
              .styledText(
                .customVine,
                18,
                .bold
              )
          }
        }
        
        
        
        // inputs
        VStack(spacing: 20) {
          TextField("Place Title", text: $vm.placeName)
            .styledTextField()
          
          TextField("Place adress", text: $vm.placeAdress)
            .styledTextField()
          
          TextField("Price or leave it blank", text: $vm.placePrice)
            .styledTextField()
            .keyboardType(.numberPad)
          
          VStack(alignment: .leading) {
            Text("Add place description")
              .styledText(
                .customBlack,
                15
              )
            
            ZStack {
              Color.customWhite
              
              TextEditor(text: $vm.placeDescription)
                .scrollContentBackground(.hidden)
                .frame(maxWidth: .infinity)
                .frame(height: 100).roundedCorners(12)
                .padding(.leading, 10)
                .overlay(
                  RoundedRectangle(cornerRadius: 12)
                    .stroke(.customBlue, lineWidth: 1)
                )
            }
          }
          
          
        }
        
        //მაპზე დამატება
        Button {
          isPresented.toggle()
        } label: {
          Text("Add place on map")
            .styledText(
              .customBlack,
              16
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.customWhite)
            .roundedCorners(12)
        }
        .customBorderedButton(borderColor: .customBlue)
        
        //ტიპი
        Picker("placeType", selection: $vm.selectedPlace) {
          ForEach(vm.placeType, id: \.self) { gender in
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
        
        
        //დამატების ღილაკი
        Button {
          vm.addPlace()
        } label: {
          Text("Add place")
            .styledText(
              .buttonPrimary,
              16,
              .bold
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .customStyledButton()
        
        
        //album
        VStack {
          PhotosPicker(selection: $vm.selectedAlbum, maxSelectionCount: 5) {
            Text("Tap to upload profile photo")
              .styledText(
                .customVine,
                18,
                .bold
              )
          }
          
          HStack {
            ForEach(Array(vm.choosenAlbum.enumerated()), id: \.offset) { index, image in
              Image(uiImage: image)
                          .resizable()
                          .scaledToFit()
                          .clipShape(RoundedRectangle(cornerRadius: 12))
                          .frame(width: 40, height: 40)
            }
          }
        }
        
        
        
      }
    }
    .scrollBounceBehavior(.basedOnSize)
    .padding(.horizontal, 20)
    .padding(.vertical, 30)
    .onDisappear {
      isAppeared.toggle()
    }
    .sheet(isPresented: $isPresented) {
      Text("hello world")
    }
  }
}
