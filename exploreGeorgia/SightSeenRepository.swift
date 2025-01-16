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

