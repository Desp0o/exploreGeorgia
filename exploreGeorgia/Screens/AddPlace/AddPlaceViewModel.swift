//
//  AddPlaceViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 16.01.25.
//

import Combine
import FirebaseFirestore
import _PhotosUI_SwiftUI
import FirebaseAuth

final class AddPlaceViewModel: ObservableObject {
  private let firebasePhotoManager: FirebasePhotoUrlGeneratorProtocol
  private let db = Firestore.firestore()
  let placeType: [AddPlaceTypes] = [.sightSeen, .food]
  @Published var placeName = ""
  @Published var placeAdress = ""
  @Published var placePrice = ""
  @Published var placeDescription = ""
  @Published var latitude: Double = 0
  @Published var longitude: Double = 0
  @Published var selectedPlace: AddPlaceTypes = .sightSeen
  @Published var choosenCover: UIImage? = nil
  @Published var selectedCoverFromPicker: PhotosPickerItem? = nil {
    didSet {
      addCover(from: selectedCoverFromPicker)
    }
  }
  @Published var selectedAlbum: [PhotosPickerItem] = [] {
    didSet {
      choosenAlbum.removeAll()
      addAlbum(from: selectedAlbum)
    }
  }
  @Published var choosenAlbum: [UIImage] = []

  init(
    firebasePhotoManager: FirebasePhotoUrlGeneratorProtocol = FirebaseFetchingService(),
    locationManager: LocationManager = LocationManager()
  ) {
    self.firebasePhotoManager = firebasePhotoManager    
  }
    
  func addPlace() {
    let userID = Auth.auth().currentUser?.uid
    
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
      latitude: latitude,
      longitude: longitude,
      user: userID,
      isSightseen: selectedPlace == .sightSeen ? true : false,
      isFood: selectedPlace == .food ? true : false
    )
    
    Task {
      do {
        try await addSightSeenToFirestore(sightSeen: place)
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  private func addSightSeenToFirestore(sightSeen: SightSeenModel) async throws {
      let collectionRef = db.collection("usersPlaces")
      
      var sightSeenWithID = sightSeen
      sightSeenWithID.id = sightSeen.id ?? collectionRef.document().documentID
      
      if let image = choosenCover {
          let placeCover = try await firebasePhotoManager.generateFirebasePhotoURL(
              image: image,
              dbName: "covers",
              Id: collectionRef.document().documentID
          )
          sightSeenWithID.cover = placeCover
      }
      
      var albumUrls: [String] = []
      for (index, image) in choosenAlbum.enumerated() {
          let albumPhotoURL = try await firebasePhotoManager.generateFirebasePhotoURL(
              image: image,
              dbName: "albums",
              Id: "\(collectionRef.document().documentID)-album-\(index)"
          )
          albumUrls.append(albumPhotoURL)
      }
      sightSeenWithID.album = albumUrls
      
      let data = try Firestore.Encoder().encode(sightSeenWithID)
      try await collectionRef.document(sightSeenWithID.id!).setData(data)
  }
  
  private func addCover(from selection: PhotosPickerItem?) {
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
  
  private func addAlbum(from selection: [PhotosPickerItem]?) {
    guard let selection else {
      return
    }
    
    Task {
      for image in selection {
        if let data = try await image.loadTransferable(type: Data.self) {
          if let uiImage = UIImage(data: data) {
            await MainActor.run {
              choosenAlbum.append(uiImage)
            }
          }
        }
      }
    }
  }
}
