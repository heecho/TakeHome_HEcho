//
//  ApiClient.swift
//  FetchRecipes_HEcho
//
//  Created by Hannah Echo on 3/2/25.
//

import Foundation
import UIKit

actor APIClient {
    static let shared = APIClient()
    private let urlSession = URLSession.shared
    
    
    func fetchAllRecipeData() async throws -> [Recipe]{
        do {
            // Fetch and decode a specific type
            let url = URL(string: APIConstants.recipeUrl)!
            let recipes = try await urlSession.decode(Recipes.self,
                                                            from: url)
            return recipes.recipes
        } catch {
            //TODO Add error handling
            return []
        }
    }
    
    func fetchRecipeImage(_ recipe: Recipe, size: ImageSizeClass) async throws -> UIImage? {
        guard let imageUrlString = imageUrlForSize(recipe, size: size) else {
            return nil
        }
        
        if let cachedImage = await RecipeImageCache.shared.getImageFromCache(for: recipe, imageSize: size) {
            return cachedImage
        }
        
        let (data, _) = try await urlSession.data(from: URL(string: imageUrlString)!)
        
        guard let image = UIImage(data: data) else {
            return nil
            //throw DownloadError.dataCannotBeConvertedToImage
        }
        
        await RecipeImageCache.shared.addImageToCache(image, imageSize: size, for: recipe)
        
        return image
    }
    
    private func imageUrlForSize(_ recipe: Recipe, size: ImageSizeClass) -> String? {
        switch size {
        case .small:
            return recipe.photoUrlSmall
        case .large:
            return recipe.photoUrlLarge
        }
    }
}

extension URLSession {
    func decode<T: Decodable>(_ type: T.Type = T.self,
                              from url: URL,
                              keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) async throws -> T {
        let (data, _) = try await data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        let decoded = try decoder.decode(T.self, from: data)
        return decoded
    }
}
