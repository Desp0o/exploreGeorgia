//
//  AllBookmarkView.swift
//  exploreGeorgia
//
//  Created by Despo on 14.01.25.
//

import SwiftUI

struct AllBookmarkView: View {
  @Environment(\.presentationMode) var dismiss
  @StateObject private var viewModel = AllBookmarkViewModel()
  @State private var isSomethingChanged = false
  @State private var currentPlace: SightSeenModel? = nil
  
  var body: some View {
    ZStack {
      Color.primaryWhite
        .ignoresSafeArea()
      
      VStack {
        
        HStack {
          Button {
            dismiss.wrappedValue.dismiss()
          } label: {
            ZStack {
              Circle()
                .fill(.customWhite.opacity(0.5))
                .frame(width: 40, height: 40)
              
              Image("backArrow")
                .renderingMode(.template)
                .foregroundStyle(.white)
            }
            
            
          }
          
          Spacer()
        }
        .padding(.horizontal, 20)
        
        if viewModel.bookmarkedPlaces.isEmpty {
          Text("Your Bucket List Awaits...")
            .styledText(.customBlue, 16, .semibold)
            .padding(.bottom, 40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
          
          Text("Explore More, Bookmark More!")
            .styledText(.customBlue, 20, .bold)
            .padding(.top, 10)
          
          List {
            ForEach(Array(viewModel.bookmarkedPlaces.enumerated()), id: \.element) { index, place in
              ZStack {
                NavigationLink(destination: PlaceDetailsView(
                  elementID: place.id ?? ""
                ).navigationBarHidden(true))
                {
                  EmptyView()
                }.opacity(0.0)
                
                SightSeenReusableView(place: place, maxWidth: UIScreen.main.bounds.width - 40, height: 180)
                  .overlay {
                    ZStack(alignment: .topTrailing) {
                      Button {
                        let indexSet = IndexSet(integer: index)
                        withAnimation {
                          viewModel.removeBookmark(index: indexSet)
                        }
                      } label: {
                        Circle()
                          .fill(.white.opacity(0.001))
                      }
                      .frame(width: 34, height: 34)
                      .offset(x:-24, y: 24)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                  }
              }
              .onAppear {
                if index == viewModel.bookmarkedPlaces.count - 1 {
                  viewModel.loadMoreIfNeeded()
                }
              }
              .buttonStyle(PlainButtonStyle())
              .listStyle(PlainListStyle())
              .listRowSeparator(.hidden)
              .listRowBackground(Color.clear)
            }
            .onDelete(perform: viewModel.removeBookmark)
            .id(isSomethingChanged)
            .id(viewModel.bookmarkedPlaces)
          }
          .listStyle(PlainListStyle())
          .scrollContentBackground(.hidden)
          .scrollIndicators(.hidden)
          .background(Color.clear)
        }
      }
    }
    .overlay{
      if viewModel.isLoaded {
        ZStack {
          Color.primaryWhite.ignoresSafeArea()
          
          ProgressView()
            .scaleEffect(1.5)
            .tint(.customBlue)
        }
      }
      
      if viewModel.isFetching && !viewModel.isLoaded{
        ZStack(alignment: .bottom) {
          ProgressView()
            .tint(.customBlue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
      }
    }
  }
}

//
//#Preview {
//  AllBookmarkView()
//}
