import SwiftUI

struct ProfileSettings: View {
  let settingsArray: [ProfileSettingsModel]
  @State private var selectedSetting: ProfileSettingsModel?

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 12)
        .fill(Color.customWhite)
        .shadow(color: .customBlack.opacity(0.15), radius: 3, y: 2)
      
      VStack(spacing: 0) {
        ForEach(settingsArray) { setting in
          Button(action: {
            selectedSetting = setting
          }) {
            HStack(spacing: 14) {
              Image(setting.icon)
                .defaultOptions()
                .frame(width: 24, height: 24)
              
              Text(setting.title)
                .styledText(.customBlack, 16, .semibold)
              
              Spacer()
              
              Image("arrowRight")
            }
            .frame(height: 56)
            .padding(.leading, 16)
            .padding(.trailing, 10)
            
            if setting.id != settingsArray.last?.id {
              Divider()
            }
          }
        }
      }
    }
    .frame(height: CGFloat(settingsArray.count) * 56)
    .sheet(item: $selectedSetting) { setting in
      setting.location
    }
  }
}
#Preview {
  ProfileSettings(settingsArray: [])
}
