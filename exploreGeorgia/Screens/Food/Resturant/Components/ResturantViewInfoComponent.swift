//
//  ResturantViewInfoComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 22.01.25.
//

import SwiftUI

struct ResturantViewInfoComponent: View {
  @EnvironmentObject var vm: ResturantViewModel
  @State private var showMoreReviews = 10
  @State private var showMoreButtonName = "Show more"
  let collection: FirebaseCollectionEnum
  
  var body: some View {
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
          
          Button {
            vm.isPresent.toggle()
          } label: {
            Text("See on map")
              .styledText(.customBlue, 14)
          }
          
          Spacer()
        }
      }
      .padding(16)
      .background(.customWhite)
      .roundedCorners(12)
      
      VStack() {
        HStack {
          Text("About")
            .styledText(.customBlue, 18, .bold)
          
          Spacer()
        }
        
        Text(vm.singleResturant?.about ?? "")
      }
      
      VStack {
        HStack {
          Text(vm.reviews.isEmpty ? "No reviews" : "Reviews")
            .styledText(.customBlue, 19, .bold)
          
          Spacer()
        }
        
        LazyVStack(alignment: .leading) {
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
              withAnimation(.easeInOut(duration: 0.2)) {
                if showMoreReviews > vm.reviews.count {
                  showMoreReviews = 10
                  print(showMoreReviews, showMoreButtonName, "🟢")
                } else {
                  showMoreReviews += 5
                  print(showMoreReviews, showMoreButtonName, "🔴")
                }
              }
            } label: {
              Text(showMoreButtonName)
                .styledText(.customBlue, 16, .semibold)
            }
          }
          
          Spacer()
          
          Button {
            withAnimation(.easeInOut(duration: 0.2)) {
              vm.isReviewVisible.toggle()
            }
          } label: {
            Text(vm.isReviewVisible ? "Cancel review" : "Add review")
              .styledText(.customBlue, 16, .semibold)
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
                .styledText(.customBlue, 16, .semibold)
                .frame(maxWidth: .infinity)
                .frame(height: 30)
                .overlay(
                  RoundedRectangle(cornerRadius: 12)
                    .stroke(.customBlue, lineWidth: 1)
                )
            }
          }
          .padding(.top, 20)
          .transition(.move(edge: .bottom))
        }
      }
    }
    .padding(.vertical, 20)
    .onChange(of: showMoreReviews) { _ in
      if showMoreReviews > vm.reviews.count {
        showMoreButtonName = "Show less"
      } else {
        showMoreButtonName = "Show more"
      }
    }
  }
}

