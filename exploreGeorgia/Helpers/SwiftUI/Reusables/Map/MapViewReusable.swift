import SwiftUI
import MapKit

struct MapViewReusable: View {
  @Environment(\.presentationMode) var presentationMode
  @StateObject var vm = MapViewModel()
  let latitudeProp: Double
  let longitudeProp: Double
  let isEditable: Bool
  @Binding var currentLocationForUse: Location?
  @State private var isActionSheetOpen: Bool = false
  @State private var myLocation: Location
  @State private var region: MKCoordinateRegion
  @State var locationName: String
  @State var selectedMapStyle: MapStyleEnum = .standard
  
  init(
    latitudeProp: Double,
    longitudeProp: Double,
    locationName: String,
    isEditable: Bool,
    currentLocationForUse: Binding<Location?> = .constant(nil) 
  ) {
    self.latitudeProp = latitudeProp
    self.longitudeProp = longitudeProp
    self.locationName = locationName
    self.isEditable = isEditable
    _currentLocationForUse = currentLocationForUse

    _myLocation = State(initialValue: Location(coordinate: CLLocationCoordinate2D(latitude: latitudeProp, longitude: longitudeProp)))
    _region = State(initialValue: MKCoordinateRegion(
      center: CLLocationCoordinate2D(latitude: latitudeProp, longitude: longitudeProp),
      span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    ))
  }
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      HStack(alignment: .center) {
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
        
        Spacer()
        
        Picker("Map Style", selection: $selectedMapStyle) {
          ForEach(MapStyleEnum.allCases, id: \.self) { style in
            Text(style.rawValue.capitalized)
              .styledText(.white, 10)
          }
        }
        .pickerStyle(.segmented)
        .onAppear {
          UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.customBlue)
          let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
          ]
          UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
          UISegmentedControl.appearance().isSpringLoaded = true
          
          UISegmentedControl.appearance().backgroundColor = .customWhite
        }
        .frame(width: 200)
      }
      .zIndex(40)
      .padding(.horizontal, 20)
      .padding(.top, 10)
      
      VStack {
        MapViewWrapper(region: $region, location: $myLocation, locationName: $locationName, mapType: selectedMapStyle.mapType, isEditable: isEditable)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      .ignoresSafeArea()
      
      if !isEditable {
        VStack {
          Spacer()
          Button {
            isActionSheetOpen.toggle()
          } label: {
            Text("Open in maps")
              .styledText(
                .buttonPrimary,
                16,
                .bold
              )
              .frame(maxWidth: .infinity)
              .frame(height: 50)
              .background(.customBlue)
              .roundedCorners(12)
              .padding(.horizontal, 20)
          }
        }
      }
    }
    .actionSheet(
      isPresented: $isActionSheetOpen,
      content: {
        vm.getActionSheet(
          latitude: latitudeProp,
          longitude: longitudeProp
        )
      }
    )
    .onDisappear {
      currentLocationForUse = myLocation
    }
  }
}

#Preview {
  MapViewReusable(latitudeProp: 41.69332927114288, longitudeProp: 44.801423578748604 , locationName: "Liberty Square", isEditable: true)
}
