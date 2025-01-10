//
//  AuthEnum.swift
//  exploreGeorgia
//
//  Created by Despo on 10.01.25.
//

enum AuthenticationError: Error {
  case tokenError(message: String)
  case configurationError(message: String)
  case networkError(message: String)
  case unknownError(message: String)
}
