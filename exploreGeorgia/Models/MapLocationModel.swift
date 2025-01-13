//
//  MapLocationModel.swift
//  exploreGeorgia
//
//  Created by Despo on 13.01.25.
//

import Foundation
import MapKit

struct Location: Identifiable {
  let id = UUID()
  let coordinate: CLLocationCoordinate2D
}
