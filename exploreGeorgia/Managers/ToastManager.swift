//
//  ToastManager.swift
//  exploreGeorgia
//
//  Created by Despo on 10.01.25.
//

import SwiftUI

final class ToastManager: ObservableObject {
    @Published var isShown: Bool = false
    
    func showToast(duration: Double = 2.0) {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.isShown = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.isShown = false
            }
        }
    }
}
