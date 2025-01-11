//
//  VocabularyViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 11.01.25.
//

import FirebaseFirestore

protocol VocabularyFetchDelegate: AnyObject {
  func didPhrasesFetched()
}

protocol VocabularyLoadingDelegate: AnyObject {
  func didVocabularyLoaded()
}

protocol VocabularyErrorMessageDelegate: AnyObject {
  func didVocabularyFailed()
}

final class VocabularyViewModel {
  weak var delegate: VocabularyFetchDelegate?
  weak var vocabularyLoadingDelegate: VocabularyLoadingDelegate?
  weak var didVocabularyFailed: VocabularyErrorMessageDelegate?
  var isLoading = false
  var errorMessage = ""
  var phrases: [String: [String]] = [:]
  var sortedPhrases: [(String, [String])] = []
  var filteredPhrases: [(String, [String])] = []
  var searchTerm: String = "" {
    didSet {
      filterPhrases()
    }
  }
  
  init() {
    useVocabularyData()
  }
  
  func useVocabularyData() {
    Task {
      do {
        await MainActor.run {
          isLoading = true
          vocabularyLoadingDelegate?.didVocabularyLoaded()
        }
        
        try await fetchVocabulary()
        
        await MainActor.run {
          sortedPhrases = phrases.sorted { $0.key < $1.key }
          filterPhrases()
          
          delegate?.didPhrasesFetched()
          
          isLoading = false
          vocabularyLoadingDelegate?.didVocabularyLoaded()
        }
      } catch {
        await MainActor.run {
          errorMessage = error.localizedDescription
          didVocabularyFailed?.didVocabularyFailed()
          
          isLoading = false
          vocabularyLoadingDelegate?.didVocabularyLoaded()
        }
      }
    }
  }
  
  func fetchVocabulary() async throws {
    let db = Firestore.firestore()
    
    do {
      let snapshot = try await db.collection("greetingVocabulary").getDocuments()
      
      for document in snapshot.documents {
        let data = document.data()
        
        guard let category = data["category"] as? String,
              let words = data["words"] as? [String] else {
          print("Error: Data format is incorrect for document \(document.documentID)")
          continue
        }
        phrases[category] = words
      }
    } catch {
      print("Error fetching vocabulary: \(error.localizedDescription)")
      throw error
    }
  }
  
  func filterPhrases() {
    let normalizedSearchTerm = searchTerm.trimmingCharacters(in: .whitespaces).lowercased()
    
    if normalizedSearchTerm.isEmpty {
      filteredPhrases = sortedPhrases
    } else {
      filteredPhrases = sortedPhrases.compactMap { category, words in
        let matchedWords = words.filter { word in
          word.lowercased().contains(normalizedSearchTerm)
        }
        
        return matchedWords.isEmpty ? nil : (category, matchedWords)
      }
    }
    
    delegate?.didPhrasesFetched()
  }
}
