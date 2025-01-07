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
  
  var body: some Scene {
    WindowGroup {
      if vm.isUserAuthenticated {
        NavigationStack {
          MainView()
            .ignoresSafeArea(edges: .all)
        }
      } else {
        NavigationStack {
          LoginViewControllerWrapper()
            .ignoresSafeArea(edges: .all)
        }
      }
    }
  }
}
