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
              .defaultOptions(color: .customGreen)
              .frame(width: 18, height: 18)
            
            Text("\(String(format: "%.2f", vm.singleResturant?.minCost ?? 0)) min Cost")
              .styledText(.customBlack, 14)
          }
        }
        
        HStack {
          Image("location")
            .defaultOptions(color: .customGreen)
            .frame(width: 18, height: 18)
          
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
            
            HStack {
              Text(review)
                .styledText(.customBlack, 15)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.customWhite)
                .clipShape(RoundedRectangle(cornerRadius: 12))
              
              Spacer()
            }
          }
          .id(vm.reviews)
        }
        
        HStack {
          if vm.reviews.count > 10 {
            Button {
              vm.commentLoaderTrigger.toggle()
              withAnimation(.easeInOut(duration: 0.2)) {
                vm.infoHeight = 0.85
                if showMoreReviews >= vm.reviews.count {
                  showMoreReviews = 2
                } else {
                  showMoreReviews += 5
                }
              }
            } label: {
              Text(showMoreReviews >= vm.reviews.count ? "show less" : "show more")
                .styledText(.customGreen, 16, .semibold)
            }
          }
          
          Spacer()
        }
        
        VStack {
          TextEditorComponent(textForEditor: $vm.usersReviweText, placeholder: "Write your review")
            .frame(minHeight: 60)
          
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
      }
    }
  }
}

