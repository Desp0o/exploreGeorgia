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
  @Published var placeCity = ""
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
  @Published var isLoading = false
  @Published var errorMessage = ""
  @Published var isSuccessfullyAdded = false
  
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
      name: placeName.capitalized,
      region: placeCity.capitalized,
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
    
    guard choosenCover != nil else {
      errorMessage = SightseenAddErrors.noCover.rawValue
      return
    }
    
    guard !placeName.isEmpty else {
      errorMessage = SightseenAddErrors.noName.rawValue
      return
    }
    
    guard !placeAdress.isEmpty else {
      errorMessage = SightseenAddErrors.noAdress.rawValue
      return
    }
    
    guard !placeDescription.isEmpty else {
      errorMessage = SightseenAddErrors.noDexcription.rawValue
      return
    }
    
    guard longitude != 0 || latitude != 0 else {
      errorMessage = SightseenAddErrors.noMap.rawValue
      return
    }
    
    guard choosenAlbum.count != 0 else {
      errorMessage = SightseenAddErrors.noAlbum.rawValue
      return
    }
    
    Task {
      await MainActor.run {
        isSuccessfullyAdded = false
        isLoading = true
      }
      
      do {
        try await addSightSeenToFirestore(sightSeen: place)
        
        await MainActor.run {
          isLoading = false
          isSuccessfullyAdded = true
          placeName = ""
          placeDescription = ""
          placeAdress = ""
          placeCity = ""
          choosenCover = nil
          choosenAlbum = []
          placePrice = ""
        }
      } catch {
        await MainActor.run {
          isLoading = false
          isSuccessfullyAdded = false
        }
        await MainActor.run {
          errorMessage = error.localizedDescription
        }
      }
    }
  }
  
  private func addSightSeenToFirestore(sightSeen: SightSeenModel) async throws {
    let collectionRef = db.collection("usersPlaces")
    let usersRef = db.collection("users")
    
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
    
    let batch = db.batch()
    
    let sightSeenRef = collectionRef.document(sightSeenWithID.id!)
    batch.setData(data, forDocument: sightSeenRef)
    
    if let currentUserID = Auth.auth().currentUser?.uid {
      let userRef = usersRef.document(currentUserID)
      batch.updateData([
        "explored": FieldValue.arrayUnion([sightSeenWithID.id!])
      ], forDocument: userRef)
    }
    
    try await batch.commit()
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
