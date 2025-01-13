//
//  CachedAsyncImage.swift
//  exploreGeorgia
//
//  Created by Despo on 13.01.25.
//

import UIKit
import SwiftUI

class ImageCache {
  static let shared = NSCache<NSString, UIImage>()
}

struct CachedAsyncImage: View {
  let url: URL?
  
  @State private var image: UIImage? = nil
  
  var body: some View {
    Group {
      if let uiImage = image {
        Image(uiImage: uiImage)
          .resizable()
          .scaledToFill()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else {
        if let url = url {
          ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .task {
              await loadImage(from: url)
            }
        }
      }
    }
  }
  
  private func loadImage(from url: URL) async {
    let cacheKey = url.absoluteString as NSString
    
    if let cachedImage = ImageCache.shared.object(forKey: cacheKey) {
      self.image = cachedImage
      return
    }
    
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      if let downloadedImage = UIImage(data: data) {
        
        ImageCache.shared.setObject(downloadedImage, forKey: cacheKey)
        
        self.image = downloadedImage
      }
    } catch {
      print("Image loading failed: \(error)")
    }
  }
}
