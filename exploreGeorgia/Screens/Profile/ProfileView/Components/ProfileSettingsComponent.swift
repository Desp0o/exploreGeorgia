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
              .defaultOptions()
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
          vm.isPrivacyPresented = true
        }) {
          HStack(spacing: 14) {
            Image(systemName: "lock")
              .resizable()
              .renderingMode(.template)
              .foregroundStyle(.customGray)
              .frame(width: 16, height: 24)
            
            Text("privacy")
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
            Image(systemName: "sun.min")
              .resizable()
              .renderingMode(.template)
              .foregroundStyle(.customGray)
              .frame(width: 16, height: 16)
            
            Text("Appereance")
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
              Image(systemName: "creditcard")
                .defaultOptions()
                .frame(width: 22, height: 16)
                .tint(.customGray)
              
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
              Image(systemName: "purchased")
                .defaultOptions()
                .frame(width: 14, height: 14)
                .tint(.customGray)
              
              Text("  Purchased tours")
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
              .defaultOptions()
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
            Image("trip")
              .defaultOptions()
              .frame(width: 24, height: 24)
            
            Text("My Explored")
              .styledText(.customBlack, 16, .semibold)
            
            Spacer()
            
            Image("arrowRight")
          }
          .frame(height: 56)
        }
      }
      .frame(height: CGFloat(7) * 56)
      .padding(.leading, 16)
      .padding(.trailing, 10)
    }
  }
}






