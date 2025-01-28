//
//  AllBookmarkViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 14.01.25.
//

import FirebaseFirestore
import FirebaseAuth

final class AllBookmarkViewModel: ObservableObject {
  @Published var bookmarkedPlaces: [SightSeenModel] = []
  @Published var bookmarkedTours: [TourModel] = []
  @Published var bookmarkedFoods: [ResturantModel] = []
  @Published var isFetching = false
  @Published var isLoading = true
  @Published var errorMessages = ""
  @Published var pageSize = 10
  @Published var dataIndex = 0
  private let bookmarkManager: BookmarkActivityProtocol
  private let fetchBookmarksManager: GetDocumetnsFromBucketListProtocol
  private var user: UserModel? = nil
  var buttonsArray = ["Sightseens", "User's Explored", "Tours", "Resturants", "Drinks", "Bakery"]
  
  init(
    bookmarkManager: BookmarkActivityProtocol = BookMarkManager(),
    fetchBookmarksManager: GetDocumetnsFromBucketListProtocol = BookMarkManager()
  ) {
    self.bookmarkManager = bookmarkManager
    self.fetchBookmarksManager = fetchBookmarksManager
    
    fetchData(pageLimit: pageSize, collectionName: .appPlace)
  }
  
  func fetchData(pageLimit: Int, collectionName: FirebaseCollectionEnum) {
    Task {
      do {
        let userID = Auth.auth().currentUser?.uid
        guard let id = userID else { return }
        
        let result: [SightSeenModel] = try await fetchBookmarksManager.getDocumentsFromBucketList(
          userId: id,
          pageLimit: pageLimit,
          collectionName: collectionName
        )
        await MainActor.run {
          bookmarkedPlaces = result
          
          isLoading = false
        }
      } catch {
        await MainActor.run {
          isLoading = false
          errorMessages = error.localizedDescription
        }
      }
    }
  }
  
  func fetchToursData(pageLimit: Int) {
    Task {
      do {
        let userID = Auth.auth().currentUser?.uid
        guard let id = userID else { return }
        
        let result: [TourModel] = try await fetchBookmarksManager.getDocumentsFromBucketList(
          userId: id,
          pageLimit: pageLimit,
          collectionName: .tours
        )
        await MainActor.run {
          bookmarkedTours = result
          isLoading = false
        }
      } catch {
        await MainActor.run {
          isLoading = false
          errorMessages = error.localizedDescription
        }
      }
    }
  }
  
  func fetchFoods(pageLimit: Int, collectionName: FirebaseCollectionEnum) {
    Task {
      do {
        let userID = Auth.auth().currentUser?.uid
        guard let id = userID else { return }
        
        let result: [ResturantModel] = try await fetchBookmarksManager.getDocumentsFromBucketList(
          userId: id,
          pageLimit: pageLimit,
          collectionName: collectionName
        )
        await MainActor.run {
          bookmarkedFoods = result
          
          isLoading = false
        }
      } catch {
        await MainActor.run {
          isLoading = false
          errorMessages = error.localizedDescription
        }
      }
    }
  }
  
  func removeBookmark(index: IndexSet) {
    guard let firstIndex = index.first else { return }
    let place = bookmarkedPlaces[firstIndex]
    bookmarkedPlaces.remove(atOffsets: index)
    
    Task {
      do {
        try await bookmarkManager.toggleBookmark(placeId: place.id ?? "", isBookmarked: true)
      } catch {
        await MainActor.run {
          errorMessages = error.localizedDescription
        }
      }
    }
  }
  
  func removeTourBookmark(index: IndexSet) {
    guard let firstIndex = index.first else { return }
    let place = bookmarkedTours[firstIndex]
    bookmarkedTours.remove(atOffsets: index)
    
    Task {
      do {
        try await bookmarkManager.toggleBookmark(placeId: place.id ?? "", isBookmarked: true)
      } catch {
        await MainActor.run {
          errorMessages = error.localizedDescription
        }
      }
    }
  }
  
  func removeFoodBookmark(index: IndexSet) {
    guard let firstIndex = index.first else { return }
    let place = bookmarkedFoods[firstIndex]
    bookmarkedFoods.remove(atOffsets: index)
    
    Task {
      do {
        try await bookmarkManager.toggleBookmark(placeId: place.id ?? "", isBookmarked: true)
      } catch {
        await MainActor.run {
          errorMessages = error.localizedDescription
        }
      }
    }
  }
  
  func requestData() {
    switch dataIndex {
    case 0:
      isLoading = true
      fetchData(pageLimit: pageSize, collectionName: .appPlace)
    case 1:
      isLoading = true
      fetchData(pageLimit: pageSize, collectionName: .usersPlace)
    case 2:
      isLoading = true
      fetchToursData(pageLimit: pageSize)
    case 3:
      isLoading = true
      fetchFoods(pageLimit: pageSize, collectionName: .resturant)
    case 4:
      isLoading = true
      fetchFoods(pageLimit: pageSize, collectionName: .drinks)
    case 5:
      isLoading = true
      fetchFoods(pageLimit: pageSize, collectionName: .bakery)
    default:
      isLoading = true
      fetchData(pageLimit: pageSize, collectionName: .appPlace)
    }
  }
}

