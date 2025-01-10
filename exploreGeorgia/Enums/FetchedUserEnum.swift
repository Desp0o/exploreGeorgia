//
//  FetchedUserEnum.swift
//  exploreGeorgia
//
//  Created by Despo on 10.01.25.
//

enum FetchedUserErrors: Error {
  case noUserLogged(message: String)
  case userDoesntExist(message: String)
  case unknownError(message: String)
}
