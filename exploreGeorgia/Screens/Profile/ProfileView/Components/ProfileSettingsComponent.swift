import SwiftUI

struct ProfileSettingsComponent: View {
  @EnvironmentObject var vm: ProfileViewModel
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 12)
        .fill(Color.customWhite)
        .shadow(color: .black.opacity(0.25), radius: 3, y: 2)
      
      VStack(spacing: 0) {
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
        
        Button(action: {
          
        }) {
          HStack(spacing: 14) {
            Image("support")
              .defaultOptions()
              .frame(width: 24, height: 24)
            
            Text("Contact")
              .styledText(.customBlack, 16, .semibold)
            
            Spacer()
            
            Image("arrowRight")
          }
          .frame(height: 56)
        }
      }
      .frame(height: CGFloat(6) * 56)
      .padding(.leading, 16)
      .padding(.trailing, 10)
    }
  }
}






