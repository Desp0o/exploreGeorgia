import SwiftUI

struct ProfileSettingsComponent: View {
  @Binding var isPresented: Bool
  @ObservedObject var vm = ProfileViewModel()
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 12)
        .fill(Color.customWhite)
        .shadow(color: .black.opacity(0.25), radius: 3, y: 2)
      
      VStack(spacing: 0) {
        //edit profile
        Button(action: {
          isPresented = true
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
        
        //bookmarked
        Button(action: {
          
        }) {
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
        
        //trip
        Button(action: {
          
        }) {
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
        
        //contact
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
      .frame(height: CGFloat(4) * 56)
      .padding(.leading, 16)
      .padding(.trailing, 10)
    }
  }
}
