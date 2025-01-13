//
//  MapStyleEnum.swift
//  exploreGeorgia
//
//  Created by Despo on 13.01.25.
//

import MapKit

enum MapStyleEnum: String, CaseIterable {
  case standard
  case hybrid
  case satellite
  
  var mapType: MKMapType {
    switch self {
    case .standard: return .standard
    case .hybrid: return .hybrid
    case .satellite: return .satellite
    }
  }
}
