//
//  PurchaseHistoryView.swift
//  exploreGeorgia
//
//  Created by Despo on 20.01.25.
//

import SwiftUI

struct PurchaseHistoryView: View {
  @Environment(\.presentationMode) var dismiss
  @StateObject var vm = PurchaseHistoryViewModel()
  @State var startingOpacity: CGFloat = 0
  @State var pageSize = 10
  
  var body: some View {
    VStack {
      if vm.isLoading {
        AllToursShimmer()
      } else {
        ScrollView {
          HStack {
            Spacer()
            
            ScreenMainTitle(
              mainTitle: "Purchase History",
              subTitle: "Adventures You've Chosen"
            )
            
            Spacer()
          }
          .padding(.vertical, 20)
          .overlay {
            HStack {
              Button {
                dismiss.wrappedValue.dismiss()
              } label: {
                ZStack {
                  OverlayActionButtonIcon(iconName: .backButton, tint: .white)
                }
              }
              Spacer()
            }
          }
          
          LazyVStack(spacing: 20) {
            ForEach(vm.historyData, id: \.self) { tour in
              SinglePurchaseComponent(tour: tour)
                .opacity(startingOpacity)
                .onAppear {
                  if tour == vm.historyData.last {
                    pageSize += 10
                  }
                }
            }
          }
          .padding(.bottom, 20)
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
        .padding(.horizontal, 20)
        .onAppear {
          withAnimation(.easeOut(duration: 0.3)) {
            startingOpacity = 1
          }
        }
      }
    }
    .background(.primaryWhite)
    .frame(maxWidth: .infinity)
    .onAppear {
      vm.fetchUserPurchases(pageSize: pageSize)
    }
    .onChange(of: pageSize) { _ in
      vm.fetchUserPurchases(pageSize: pageSize)
    }
  }
}

