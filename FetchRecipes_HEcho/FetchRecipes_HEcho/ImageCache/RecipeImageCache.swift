//
//  RecipeImageCache.swift
//  FetchRecipes_HEcho
//
//  Created by Hannah Echo on 3/2/25.
//

import Foundation
import UIKit

protocol RecipeImageCacheProtocol: Sendable {
    func addImageToCache(_ image: UIImage, imageSize: ImageSizeClass, for recipe: Recipe) async
    func getImageFromCache(for recipe: Recipe, imageSize: ImageSizeClass) async -> UIImage?
}
actor RecipeImageCache: RecipeImageCacheProtocol {
    static let shared = RecipeImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    init() {
        // Reference: 250 Mb cache size of Google Drive app
        cache.totalCostLimit = 250
    }
    
    /// Adds a UIImage to the cache for an associated Recipe
    func addImageToCache(_ image: UIImage, imageSize: ImageSizeClass, for recipe: Recipe) async {
        if await getImageFromCache(for: recipe, imageSize: imageSize) != nil {
            return
        }
        
        guard let pathKey = setPathKeyFor(recipe: recipe, imageSize: imageSize) else {
            return
        }
        
        if let path = pathKey as NSString? {
            cache.setObject(image, forKey: path)
        }
    }
    
    /// Returns a Cached UIImage for a given Recipe
    func getImageFromCache(for recipe: Recipe, imageSize: ImageSizeClass) async -> UIImage? {
        guard let pathKey = setPathKeyFor(recipe: recipe, imageSize: imageSize) else {
            return nil
        }
        
        if let path = pathKey as NSString? {
            return cache.object(forKey: path)
        }
        
        return nil
    }
    
    /// Helper method to generate unique cache key for recipe + image size
    private func setPathKeyFor(recipe: Recipe, imageSize: ImageSizeClass) -> String? {
        switch imageSize {
        case .small:
            return recipe.photoUrlSmall
        case .large:
            return recipe.photoUrlLarge
        }
    }
}
