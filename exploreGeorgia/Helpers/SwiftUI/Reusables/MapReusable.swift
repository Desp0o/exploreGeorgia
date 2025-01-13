import SwiftUI
import MapKit

struct Location: Identifiable {
  let id = UUID()
  let coordinate: CLLocationCoordinate2D
}

struct MapViewReusable: View {
  @Environment(\.presentationMode) var presentationMode
  let latitudeProp: Double
  let longitudeProp: Double
  let isEditable: Bool
  
  @State private var myLocation: Location
  @State private var region: MKCoordinateRegion
  @State var locationName: String
  
  init(
    latitudeProp: Double,
    longitudeProp: Double,
    locationName: String,
    isEditable: Bool
  ) {
    self.latitudeProp = latitudeProp
    self.longitudeProp = longitudeProp
    self.locationName = locationName
    self.isEditable = isEditable
    
    _myLocation = State(initialValue: Location(coordinate: CLLocationCoordinate2D(latitude: latitudeProp, longitude: longitudeProp)))
    _region = State(initialValue: MKCoordinateRegion(
      center: CLLocationCoordinate2D(latitude: latitudeProp, longitude: longitudeProp),
      span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    ))
  }
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      HStack {
        Button {
          presentationMode.wrappedValue.dismiss()
        } label: {
          Image(systemName: "xmark")
            .renderingMode(.template)
            .resizable()
            .frame(width: 18, height: 18)
            .foregroundStyle(.white)
        }
      }
      .padding(.all, 12)
      .background(.customBlue.opacity(0.7))
      .clipShape(Circle())
      .zIndex(2)
      .offset(x: 16, y: 16)
      
      VStack {
        MapViewWrapper(region: $region, location: $myLocation, locationName: $locationName, isEditable: isEditable)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      .ignoresSafeArea()
    }
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
}

struct MapViewWrapper: UIViewRepresentable {
  @Binding var region: MKCoordinateRegion
  @Binding var location: Location
  @Binding var locationName: String
  let isEditable: Bool
  
  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.mapType = .standard
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
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
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
}

#Preview {
  MapViewReusable(latitudeProp: 41.69332927114288, longitudeProp: 44.801423578748604 , locationName: "Liberty Square", isEditable: true)
}
