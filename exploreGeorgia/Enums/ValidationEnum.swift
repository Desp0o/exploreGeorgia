//
//  ValidationEnum.swift
//  exploreGeorgia
//
//  Created by Despo on 10.01.25.
//

enum ValidationError: String {
  case wrongFirsName = "The first name must contain only letters"
  case shortFirstName = "The first name must be at least 2 characters long"
  case wrongLastName = "The last name must contain only letters"
  case shortLastName = "The last name must be at least 2 characters long"
  case wrongEmail = "Enter correct email format"
  case wrongPassword = "The password must contain at least one uppercase letter, one number, and one special character"
  case shortPassword = "The password must be at least 8 characters long."
  case passNoMatch = "The passwords do not match"
}
