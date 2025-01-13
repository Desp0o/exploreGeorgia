//
//  MapViewWrapper.swift
//  exploreGeorgia
//
//  Created by Despo on 13.01.25.
//

import SwiftUI
import MapKit

struct MapViewWrapper: UIViewRepresentable {
  @Binding var region: MKCoordinateRegion
  @Binding var location: Location
  @Binding var locationName: String
  var mapType: MKMapType

  let isEditable: Bool
  
  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.mapType = mapType
    mapView.delegate = context.coordinator
    
    if isEditable {
      let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleMapTap(_:)))
      mapView.addGestureRecognizer(tapGesture)
    }
    return mapView
  }
  
  func updateUIView(_ uiView: MKMapView, context: Context) {
    let center = region.center
    let span = region.span
    uiView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
    
    uiView.removeAnnotations(uiView.annotations)
    
    let annotation = MKPointAnnotation()
    annotation.title = locationName
    annotation.coordinate = location.coordinate
    uiView.addAnnotation(annotation)
    
    uiView.mapType = mapType
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
}

class Coordinator: NSObject, MKMapViewDelegate {
  var parent: MapViewWrapper
  
  init(_ parent: MapViewWrapper) {
    self.parent = parent
  }
  
  @objc func handleMapTap(_ gesture: UITapGestureRecognizer) {
    guard let mapView = gesture.view as? MKMapView else { return }
    
    let tappedPoint = gesture.location(in: mapView)
    let coordinate = mapView.convert(tappedPoint, toCoordinateFrom: mapView)
    
    DispatchQueue.main.async {
      withAnimation(.easeIn) {
        self.parent.location = Location(coordinate: coordinate)
        self.parent.region.center = coordinate
        
        print(coordinate)
      }
    }
  }
}
