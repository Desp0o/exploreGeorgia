//
//  ResturantViewInfoComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 22.01.25.
//

import SwiftUI

struct ResturantViewInfoComponent: View {
  @ObservedObject var vm: ResturantViewModel
  @Binding var isPresent: Bool
  @State private var showMoreReviews = 2
  @State private var showMoreButtonName = "Show more"
  @Binding var isReviewVisible: Bool
  
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
            isPresent.toggle()
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
          Text("Reviews")
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
          Button {
            withAnimation(.easeInOut(duration: 0.2)) {
              if showMoreReviews == vm.reviews.count {
                showMoreButtonName = "Show more"
                showMoreReviews = 5
              } else if showMoreReviews + 5 >= vm.reviews.count {
                showMoreButtonName = "Show less"
                showMoreReviews = vm.reviews.count
              } else {
                showMoreButtonName = "Show more"
                showMoreReviews += 5
              }
            }
            
          } label: {
            Text(showMoreButtonName)
              .styledText(.customBlue, 16, .semibold)
          }
          
          Spacer()
          
          Button {
            withAnimation(.easeInOut(duration: 0.2)) {
              isReviewVisible.toggle()
            }
          } label: {
            Text(isReviewVisible ? "Cancel review" : "Add review")
              .styledText(.customBlue, 16, .semibold)
          }
        }
        
        if isReviewVisible {
          VStack {
            TextEditorComponent(textForEditor: $vm.usersReviweText, placeholder: "Write your review")
            
            Button {
              vm.addUserReview()
              if showMoreReviews >= vm.reviews.count {
                showMoreButtonName = "Show less"
              } else {
                showMoreButtonName = "Show more"
              }
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
  }
}

