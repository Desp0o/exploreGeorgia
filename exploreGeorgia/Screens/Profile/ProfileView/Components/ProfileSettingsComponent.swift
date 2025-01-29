import SwiftUI

struct ProfileSettingsComponent: View {
  @EnvironmentObject var vm: ProfileViewModel
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 12)
        .fill(Color.customWhite)
        .shadow(color: .black.opacity(0.25), radius: 3, y: 2)
      
      VStack(spacing: 0) {
        //profile edit
        Button(action: {
          vm.isPresented = true
        }) {
          HStack(spacing: 14) {
            Image("profile")
              .defaultOptions(color: .customGray)
              .frame(width: 24, height: 24)
            
            Text("Edit Profile")
              .styledText(.customBlack, 16, .semibold)
            
            Spacer()
            
            Image("arrowRight")
          }
          .frame(height: 56)
        }
        
        // privacy
        Button(action: {
          vm.isSecurotyPresented = true
        }) {
          HStack(spacing: 14) {
            Image("password")
              .defaultOptions(color: .customGray)
              .frame(width: 24, height: 24)
            
            Text("Change password")
              .styledText(.customBlack, 16, .semibold)
            
            Spacer()
            
            Image("arrowRight")
          }
          .frame(height: 56)
        }
        
        //appereance
        Button(action: {
          vm.isAppereancePresented = true
        }) {
          HStack(spacing: 14) {
            Image("moon")
              .defaultOptions(color: .customGray)
              .frame(width: 24, height: 24)
            
            Text("Aappearance")
              .styledText(.customBlack, 16, .semibold)
            
            Spacer()
            
            Image("arrowRight")
          }
          .frame(height: 56)
        }
        
        //payment
        NavigationLink(destination: PaymentViewWrapper()
          .ignoresSafeArea()
          .navigationBarHidden(true)) {
            HStack(spacing: 14) {
              Image("creditcard")
                .defaultOptions(color: .customGray)
                .frame(width: 24, height: 24)
              
              Text("Payment methods")
                .styledText(.customBlack, 16, .semibold)
              
              Spacer()
              
              Image("arrowRight")
            }
            .frame(height: 56)
          }
        
        //purchased tours
        NavigationLink(destination: PurchaseHistoryView()
          .navigationBarHidden(true)) {
            HStack(spacing: 14) {
              Image("ticket")
                .defaultOptions(color: .customGray)
                .frame(width: 24, height: 24)
              
              Text("Purchased tours")
                .styledText(.customBlack, 16, .semibold)
              
              Spacer()
              
              Image("arrowRight")
            }
            .frame(height: 56)
          }
        
        //bookmarks
        NavigationLink(destination: AllBookmarkView().navigationBarHidden(true)) {
          HStack(spacing: 14) {
            Image("bookmark")
              .defaultOptions(color: .customGray)
              .frame(width: 24, height: 24)
            
            Text("Bookmarked")
              .styledText(.customBlack, 16, .semibold)
            
            Spacer()
            
            Image("arrowRight")
          }
          .frame(height: 56)
        }
        
        // my explores
        NavigationLink(
          destination: MyExploresViewControllerWrapper()
            .navigationBarHidden(true)
            .ignoresSafeArea()
        ) {
          HStack(spacing: 14) {
            Image("location")
              .defaultOptions(color: .customGray)
              .frame(width: 24, height: 24)
            
            Text("My Explored")
              .styledText(.customBlack, 16, .semibold)
            
            Spacer()
            
            Image("arrowRight")
          }
          .frame(height: 56)
        }
        
        // delete acc
        Button(action: {
          vm.isDeleteAccPresented = true
        }) {
          HStack(spacing: 14) {
            Image("privacy")
              .defaultOptions(color: .customGray)
              .frame(width: 24, height: 24)
            
            Text("Delete account")
              .styledText(.customBlack, 16, .semibold)
            
            Spacer()
            
            Image("arrowRight")
          }
          .frame(height: 56)
        }
      }
      .frame(height: CGFloat(8) * 56)
      .padding(.leading, 16)
      .padding(.trailing, 10)
    }
  }
}






