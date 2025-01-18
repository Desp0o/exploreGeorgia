//
//  exploreGeorgiaApp.swift
//  exploreGeorgia
//
//  Created by Despo on 26.12.24.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    
    return true
  }
}

struct LoginViewControllerWrapper: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> LoginVC {
    return LoginVC()
  }
  
  func updateUIViewController(_ uiViewController: LoginVC, context: Context) {}
}

@main
struct YourApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject private var vm = RouterManager()
  @AppStorage("isDarkTheme") private var isDarkTheme = UITraitCollection.current.userInterfaceStyle == .dark

  var body: some Scene {
    WindowGroup {
      
      if vm.isUserAuthenticated {
        NavigationStack {
          ToutView()
            .preferredColorScheme(isDarkTheme ? .dark : .light)
            .ignoresSafeArea(edges: .all)
        }
      } else {
        NavigationStack {
          LoginViewControllerWrapper()
            .preferredColorScheme(isDarkTheme ? .dark : .light)
            .ignoresSafeArea(edges: .all)
        }
      }
    }
  }
}
