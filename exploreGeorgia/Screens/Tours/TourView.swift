//
//  ToutView.swift
//  exploreGeorgia
//
//  Created by Despo on 18.01.25.
//

import SwiftUI

struct TourView: View {
  @StateObject var vm = TourViewModel()
  @State var selectedImage = ""
  @State var isLightBoxVisible = false
  
  var body: some View {
    ZStack(alignment: .top) {
      Color.primaryWhite.ignoresSafeArea()
      
      ScrollView {
        
        VStack(spacing: 24) {
          //MARK: header
          ZStack(alignment: .bottomLeading) {
            CachedAsyncImage(url: URL(string: vm.tour?.cover ?? ""))
              .frame(width: UIScreen.main.bounds.width, height: 315)
              .roundedCorners(12)
            
            VStack(alignment: .leading, spacing: 0) {
              Text(vm.tour?.name ?? "")
                .styledText(.white, 24, .semibold)
              
              HStack {
                Image("locationPin")
                  .renderingMode(.template)
                  .foregroundStyle(.white)
                
                Text(vm.tour?.adress ?? "")
                  .styledText(.white, 18)
                
                Spacer()
              }
            }
            .padding(.leading, 20)
            .padding(.bottom, 20)
          }
          .overlay {
            ZStack() {
              PlaceDetailsNavigationBar(isBookMarked: $vm.isBookMarked, placeID: vm.tour?.id ?? "")
            }
            .frame(maxHeight: .infinity, alignment: .top)
          }
          
          //MARK: Scroll
          ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
              ForEach(vm.tour?.album ?? [""], id: \.self) { index in
                
                CachedAsyncImage(url: URL(string: index))
                  .frame(width: 52, height: 52)
                  .clipShape(RoundedRectangle(cornerRadius: 12))
                  .onTapGesture {
                    selectedImage = index
                    isLightBoxVisible = true
                  }
              }
            }
            .padding(.horizontal, 10)
          }
          .background(
            RoundedRectangle(cornerRadius: 12)
              .fill(Color.customWhite)
          )
          .padding(.horizontal, 20)
          .frame(height: 76)
          .frame(maxWidth: .infinity)
          
          //MARK: total summary
          VStack(spacing: 12) {
            HStack {
              Text("Tour Summary")
                .styledText(.customBlack, 20, .semibold)
              
              Spacer()
            }
            
            HStack(spacing: 30) {
              ForEach(vm.tourDetailArray.indices, id: \.self) { index in
                let element = vm.tourDetailArray[index]
                
                HStack {
                  ZStack {
                    Image(element.icon)
                      .renderingMode(.template)
                      .foregroundStyle(.customBlue)
                      .onTapGesture {
                        print(index)
                      }
                  }
                  .frame(width: 40, height: 40)
                  .background(.customWhite)
                  .roundedCorners(12)
                  
                  VStack(alignment: .leading) {
                    Text(element.title)
                      .styledText(.customGray, 12)
                    
                    Text(element.titleValie)
                      .styledText(.customBlack, 12)
                  }
                  
                  
                }
                
              }
            }
            
            VStack {
              HStack {
                Text("Description")
                  .styledText(.customBlack, 20, .semibold)
                
                Spacer()
              }
              
              Text(vm.tour?.description ?? "")
                .styledText(.customBlack, 14)
              
            }
          }
          .padding(.horizontal, 20)
          
          //MARK: button
          
          Spacer()
          
          HStack {
            HStack(spacing: 0) {
              Text("₾\(vm.tour?.price ?? 0)")
                .styledText(.customBlack, 24, .semibold)
              Text(" /day")
                .styledText(.customGray, 14)
            }
            
            Spacer()
            
            Button {
              print("test")
            } label: {
              Text("Book now")
                .styledText(.buttonPrimary, 20, .semibold)
                .frame(width: 170, height: 42)
                .background(.customBlue)
                .roundedCorners(12)
            }
          }
          .padding(.horizontal, 20)

        }
        .padding(.bottom, 30)
      }
      .scrollIndicators(.hidden)
      .scrollBounceBehavior(.basedOnSize)
      
    }
    .overlay {
      if vm.isLoading {
        ZStack {
          Color.primaryWhite.ignoresSafeArea()
          
          ProgressView()
            .scaleEffect(1.5)
            .tint(.customBlue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      
      if isLightBoxVisible {
        LightBoxViewReusable(
          selectedImage: $selectedImage,
          isLightBoxVisible: $isLightBoxVisible,
          album: vm.tour?.album ?? [""]
        )
        .ignoresSafeArea(.all)
      }
    }
    .ignoresSafeArea()
  }
}

#Preview {
  TourView()
    .preferredColorScheme(.dark)
}

#Preview {
  TourView()
    .preferredColorScheme(.light)
}

#Preview {
  TourView()
    .preferredColorScheme(.dark)
}



