//
//  ToastEnum.swift
//  exploreGeorgia
//
//  Created by Despo on 10.01.25.
//

import SwiftUICore

enum ToastTypes {
    case successfully
    case warning
    case error
    
    var backgroundColor: Color {
        switch self {
        case .successfully:
            return Color(.systemGreen)
        case .warning:
            return Color(.systemYellow)
        case .error:
            return Color(.systemRed)
        }
    }
}
