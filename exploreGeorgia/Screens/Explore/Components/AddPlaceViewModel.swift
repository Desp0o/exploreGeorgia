//
//  AddPlaceViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 16.01.25.
//

import Combine
import FirebaseFirestore
import _PhotosUI_SwiftUI

final class AddPlaceViewModel: ObservableObject {
  private let firebasePhotoManager: FirebasePhotoUrlGeneratorProtocol
  let db = Firestore.firestore()
  @Published var placeName = ""
  @Published var placeAdress = ""
  @Published var placePrice = ""
  @Published var placeDescription = ""
  @Published var selectedPlace = "Sightseen"
  @Published var choosenCover: UIImage? = nil
  @Published var selectedCoverFromPicker: PhotosPickerItem? = nil {
    didSet {
      addCover(from: selectedCoverFromPicker)
    }
  }
  
  init(firebasePhotoManager: FirebasePhotoUrlGeneratorProtocol = FirebaseFetchingService()) {
    self.firebasePhotoManager = firebasePhotoManager
  }
  
  var placeType = ["Sightseen", "Food place"]
  
  func addPlace() {
    let place = SightSeenModel(
      cover: "",
      name: placeName,
      region: "",
      album: [""],
      description: placeDescription,
      rating: "",
      price: Int(placePrice) ?? 0,
      adress: placeAdress,
      ratingCount: 0,
      latitude: 0.0,
      longitude: 0.0
    )
    
    Task {
      do {
        try await addSightSeenToFirestore(sightSeen: place)
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  func addSightSeenToFirestore(sightSeen: SightSeenModel) async throws {
    let collectionRef = db.collection("usersPlaces")
    
    var sightSeenWithID = sightSeen
    sightSeenWithID.id = sightSeen.id ?? collectionRef.document().documentID
    
    if let image = choosenCover {
      let placeCover = try await firebasePhotoManager.generateFirebasePhotoURL(image: image, dbName: "covers", Id: collectionRef.document().documentID)
      
      sightSeenWithID.cover = placeCover
    }
    
    let data = try Firestore.Encoder().encode(sightSeenWithID)
    
    try await collectionRef.document(sightSeenWithID.id!).setData(data)
  }
  
  func addCover(from selection: PhotosPickerItem?) {
    guard let selection else {
      return
    }
    
    Task {
      if let data = try await selection.loadTransferable(type: Data.self) {
        if let uiImage = UIImage(data: data) {
          await MainActor.run {
            choosenCover = uiImage
          }
        }
      }
    }
  }
}
