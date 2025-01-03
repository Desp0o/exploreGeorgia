//
//  Validations.swift
//  exploreGeorgia
//
//  Created by Despo on 04.01.25.
//

import Foundation

public func isValidNames(_ name: String) -> Bool {
    let regex = "^[a-zA-Z]+$"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    return predicate.evaluate(with: name)
}

public func isValidEmail(_ email: String) -> Bool {
    let regex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    return predicate.evaluate(with: email)
}

public func isValidPassword(_ password: String) -> Bool {
    let regex = "^(?=.*[A-Z])(?=.*\\d)(?=.*[.!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>/?]).{8,}$"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    return predicate.evaluate(with: password)
}
