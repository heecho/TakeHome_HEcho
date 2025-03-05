//
//  CachedAsyncImage.swift
//  FetchRecipes_HEcho
//
//  Created by Hannah Echo on 3/2/25.
//

import Foundation
import UIKit
import SwiftUI


class ImageLoader: ObservableObject {
    @Published var viewState: ViewState = .loading
    
    private let apiClient: ApiClientProtocol
    private let imageCache: RecipeImageCacheProtocol
    
    init(apiClient: ApiClientProtocol = ApiClient.shared, imageCache: RecipeImageCacheProtocol = RecipeImageCache.shared) {
        self.apiClient = apiClient
        self.imageCache = imageCache
    }
    
    @MainActor
    func fetchRecipeImage(_ recipe: Recipe, size: ImageSizeClass) async throws -> UIImage? {
        viewState = .loading
        
        guard let imageUrl = imageUrlForSize(recipe, size: size) else {
            viewState = .error(APIClientError.invalidURL.description, APIClientError.invalidURL.informationalMessage)
            throw APIClientError.invalidURL
        }
        
        // Attempt to retrieve image from cache before downloading
        if let cachedImage = await imageCache.getImageFromCache(for: recipe, imageSize: size) {
            viewState = .loaded
            return cachedImage
        } else {
            do {
                let image = try await apiClient.fetchRecipeImage(recipe, size: size, url: imageUrl)
                viewState = image != nil ? .loaded : .empty
                return image
            } catch let error as APIClientError {
                viewState = .error(error.description, error.informationalMessage)
            }
        }
        return nil
    }
    
    /// Helper method to create produce url for recipe + image size
    private func imageUrlForSize(_ recipe: Recipe, size: ImageSizeClass) -> URL? {
        switch size {
        case .small:
            if let url = recipe.photoUrlSmall {
                return URL(string: url)
            }
        case .large:
            if let url = recipe.photoUrlLarge {
                return URL(string: url)
            }
        }
        
        return nil
    }
}
