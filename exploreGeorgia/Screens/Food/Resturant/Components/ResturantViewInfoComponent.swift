//
//  ResturantViewInfoComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 22.01.25.
//

import SwiftUI

struct ResturantViewInfoComponent: View {
  @EnvironmentObject var vm: ResturantViewModel
  @State private var showMoreReviews = 2
  @State private var showMoreButtonName = "Show more"
  @State private var keyboardHeight: CGFloat = 0
  let collection: FirebaseCollectionEnum
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 40) {
        VStack {
          HStack {
            Text(vm.singleResturant?.workingHours ?? "")
              .styledText(.customBlack, 14)
            
            Spacer()
            
            HStack {
              Image("bill")
                .renderingMode(.template)
                .foregroundStyle(.customBlack)
                .scaleEffect(0.7)
              
              Text("\(String(format: "%.2f", vm.singleResturant?.minCost ?? 0)) min Cost")
                .styledText(.customBlack, 14)
            }
          }
          
          HStack {
            Image("locationPin")
              .renderingMode(.template)
              .foregroundStyle(.customGreen)
              .scaleEffect(1.2)
            
            Button {
              vm.isPresent.toggle()
            } label: {
              Text("Show Location")
                .styledText(.customGreen, 16, .bold)
            }
            
            Spacer()
          }
        }
        .padding(16)
        .background(.customWhite)
        .roundedCorners(12)
        
        VStack {
          HStack {
            Text("About")
              .styledText(.customGreen, 18, .bold)
            
            Spacer()
          }
          
          Text(vm.singleResturant?.about ?? "")
        }
        
        VStack {
          HStack {
            Text(vm.reviews.isEmpty ? "No reviews" : "Reviews")
              .styledText(.customGreen, 19, .bold)
            
            Spacer()
          }
          
          VStack(alignment: .leading) {
            ForEach((vm.reviews.prefix(showMoreReviews).reversed()).indices, id: \.self) { index in
              let review = vm.reviews[index]
              
              Text(review)
                .styledText(.customBlack, 15)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.customWhite)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .id(vm.reviews)
          }
          
          HStack {
            if vm.reviews.count > 10 {
              Button {
                vm.commentLoaderTrigger.toggle()
                withAnimation(.easeInOut(duration: 0.2)) {
                  vm.infoHeight = 0.85
                  if showMoreReviews > vm.reviews.count {
                    showMoreReviews = 10
                  } else {
                    showMoreReviews += 5
                  }
                }
              } label: {
                Text(showMoreButtonName)
                  .styledText(.customGreen, 16, .semibold)
              }
            }
            
            Spacer()
            
            Button {
              withAnimation(.easeInOut(duration: 0.2)) {
                vm.isReviewVisible.toggle()
                if vm.isReviewVisible {
                  vm.infoHeight = 0.85
                }
              }
            } label: {
              Text(vm.isReviewVisible ? "Cancel review" : "Add review")
                .styledText(.customGreen, 16, .bold)
            }
          }
          
          if vm.isReviewVisible {
            VStack {
              TextEditorComponent(textForEditor: $vm.usersReviweText, placeholder: "Write your review")
                .frame(height: 200)
              
              Button {
                vm.addUserReview(collection: collection)
              } label: {
                Text("Send review")
                  .styledText(.customGreen, 16, .semibold)
                  .frame(maxWidth: .infinity)
                  .frame(height: 30)
                  .overlay(
                    RoundedRectangle(cornerRadius: 12)
                      .stroke(.customGreen, lineWidth: 1)
                  )
              }
            }
            .padding(.top, 20)
            .transition(.move(edge: .bottom).combined(with: .move(edge: .bottom)))
          }
        }
      }
      .padding(.vertical, 20)
      .padding(.bottom, keyboardHeight)
    }
    .ignoresSafeArea(.keyboard)
    .onAppear {
      NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        keyboardHeight = keyboardFrame.height
      }
      
      NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
        keyboardHeight = 0
      }
    }
  }
}
