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
      cover: "https://picsum.photos/200/300?random=1",
      name: "Eiffel Tower",
      region: "Paris",
      album: ["https://picsum.photos/200/300?random=2",
              "https://picsum.photos/200/300?random=4"],
      description: "Famous iron tower",
      rating: "4.8",
      price: 20,
      adress: "Champ de Mars, Paris",
      ratingCount: 1000,
      latitude: 48.8584,
      longitude: 2.2945,
      isBookmarked: nil,
      isSightseen: false,
      isFood: false
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
