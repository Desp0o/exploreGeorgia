import FirebaseFirestore
import Combine

class SightSeenRepository: ObservableObject {
  private let db = Firestore.firestore()
  private let collectionName = "placesFromApp"
  
  init() {
    // Empty initializer - we don't want to add data here
  }
  
  func addSight(sight: SightSeenModel) async throws -> String {
    // Create a new document reference with auto-generated ID
    let docRef = db.collection(collectionName).document()
    
    // Create a mutable copy of the sight with the auto-generated ID
    var newSight = sight
    newSight.id = docRef.documentID
    
    // Set default value for isBookmarked if it's nil
    if newSight.isBookmarked == nil {
      newSight.isBookmarked = false
    }
    
    // Convert the model to dictionary
    guard let data = try? Firestore.Encoder().encode(newSight) else {
      throw NSError(domain: "SightSeenRepository",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to encode sight"])
    }
    
    // Save to Firestore
    try await docRef.setData(data)
    
    return docRef.documentID
  }
  
  
  func pushRsturantToDB() {
    let sampleFoodItem = FoodItem(
      foodCover: "https://glovo.dhmedia.io/image/stores-glovo/stores/510dd4360abcaf007ca551f9664e1cb338f85ad687c08e1fc39bcaefac9b86cf?t=W3siYXV0byI6eyJxIjoibG93In19LHsicmVzaXplIjp7Im1vZGUiOiJmaWxsIiwiYmciOiJ0cmFuc3BhcmVudCIsIndpZHRoIjo1ODgsImhlaWdodCI6MzIwfX1d",
      foodIngredients: "Chicken katsu in Japanese barbecue sauce, rice, red and white cabbage, green onions, sesame seeds, teriyaki sauce",
      foodName: "Ukve Chicken",
      foodPrice: 20
    )
    
    let restaurant = ResturantModel(
      id: nil,
      name: "Puroba",
      cover: "https://glovo.dhmedia.io/image/stores-glovo/stores/31c0369c9a423391aa6b3883131a3908fab8ae70519cd303ac4a87703585becc?t=W3siYXV0byI6eyJxIjoibG93In19LHsicmVzaXplIjp7Im1vZGUiOiJmaWxsIiwiYmciOiJ0cmFuc3BhcmVudCIsIndpZHRoIjo1ODgsImhlaWdodCI6MzIwfX1d",
      workingHours: "8:00 AM - 10:00 PM",
      minCost: 25.0,
      latitude: 41,
      longitude: 44,
      isBookmarked: nil,
      isGlutein: false,
      isVegan: true,
      isVegetarian: true,
      about: "t is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English.",
      reviews: [],
      menu: ["Caprese Salad": sampleFoodItem],
      type: "National"
    )
    
    
    Task{
      do {
        try await addRestaurantToFirestore(restaurant)
      }
    }
  }
  
  func addRestaurantToFirestore(_ restaurant: ResturantModel) async throws {
    let db = Firestore.firestore()
    var restaurantToSave = restaurant
    
    // Ensure the ID is set, otherwise Firestore will generate one
    if restaurantToSave.id == nil {
      restaurantToSave.id = db.collection("resturant").document().documentID
    }
    
    do {
      // Save the document to Firestore
      try db.collection("bakery").document(restaurantToSave.id!).setData(from: restaurantToSave)
    } catch {
      // Propagate the error to the caller
      throw error
    }
  }
  
  
  
}
class YourViewModel: ObservableObject {
  private let repository = SightSeenRepository()
  
  func addNewSight() {
    let newSight = SightSeenModel(
      id: nil,
      cover: "https://cdn.georgiantravelguide.com/storage/files/petras-tsikhe-achara-petra-castle-adjara-1.jpg",
      name: "Petra Fortress",
      region: "Adjara",
      album: [
          "https://cdn.georgiantravelguide.com/storage/files/petras-tsikhe-achara-petra-castle-adjara.jpg",
          "https://cdn.georgiantravelguide.com/storage/files/petras-tsikhe-kalaki-achara-petra-fortess-adjara-1.jpg",
          "https://cdn.georgiantravelguide.com/storage/files/petras-tsikhe-kalaki-achara-petra-fortess-adjara-2.jpg",
          "https://cdn.georgiantravelguide.com/storage/files/petras-tsikhe-achara-petra-castle-adjara-3.jpg",
          "https://cdn.georgiantravelguide.com/storage/files/petras-tsikhe-achara-petra-castle-adjara-7.jpg",
          "https://cdn.georgiantravelguide.com/storage/files/petras-tsikhe-achara-petra-castle-adjara-6.jpg",
          "https://cdn.georgiantravelguide.com/storage/files/petras-tsikhe-achara-petra-castle-adjara-8.jpg"
      ],
      description: "Petra Fortress, located in the Adjara region, is a historic site that dates back to the 6th century. Built by the Byzantine Empire, this fortress served as a strategic point on the Silk Road, offering stunning views of the Black Sea. The ruins of Petra Fortress include remnants of ancient walls, towers, and a small chapel, which reveal the site’s rich history and architectural significance. Visitors can explore its captivating landscapes and imagine the fortress’s role as a vital defensive stronghold in Georgia's past. Petra Fortress is a must-visit for history enthusiasts and nature lovers alike.",
      rating: "4.6",
      price: 0,
      adress: "Petra, Adjara",
      ratingCount: 1200,
      latitude: 41.9474,
      longitude: 41.7739,
      isBookmarked: nil,
      isSightseen: true,
      isFood: false,
      createdAt: Date()
  )
    
    Task {
      do {
        let newId = try await repository.addSight(sight: newSight)
        print("Successfully added sight with ID: \(newId)")
      } catch {
        print("Error adding sight: \(error)")
      }
    }
  }
}


//id: nil,
//cover: "",
//name: "",
//region: "",
//album: [
//  
//],
//description: "",
//rating: "",
//price: 0,
//adress: "",
//ratingCount: 0,
//latitude: 41.594215,
//longitude: 44.124291,
//isBookmarked: nil,
//isSightseen: false,
//isFood: false,
//createdAt: Date()
