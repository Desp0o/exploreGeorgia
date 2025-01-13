//
//  MapViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 13.01.25.
//

import UIKit
import MapKit
import SwiftUI

final class MapViewModel: ObservableObject {
  
  func getActionSheet(latitude: Double, longitude: Double) -> ActionSheet {
      let buttonGoogle: ActionSheet.Button = .default(Text("Google Maps")) { [weak self] in
          self?.openGoogleMaps(latitude: latitude, longitude: longitude)
      }
      
      let buttonApple: ActionSheet.Button = .default(Text("Apple Maps")) { [weak self] in
          self?.openAppleMaps(latitude: latitude, longitude: longitude)
      }
      
      let cancelButton: ActionSheet.Button = .destructive(Text("Cancel"))
      
      return ActionSheet(
          title: Text("Choose Map"),
          buttons: [buttonGoogle, buttonApple, cancelButton]
      )
  }

  func openGoogleMaps(latitude: Double, longitude: Double) {
    let googleMapsURL = "comgooglemaps://?q=\(latitude),\(longitude)"
    
    if let url = URL(string: googleMapsURL), UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
      let fallbackURL = "https://www.google.com/maps?q=\(latitude),\(longitude)"
      if let fallbackUrl = URL(string: fallbackURL) {
        UIApplication.shared.open(fallbackUrl, options: [:], completionHandler: nil)
      }
    }
  }
  
  func openAppleMaps(latitude: Double, longitude: Double, placeName: String = "Location") {
    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    let placemark = MKPlacemark(coordinate: coordinate)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = placeName
    mapItem.openInMaps(launchOptions: [
      MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
    ])
  }
}
