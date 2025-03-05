//
//  MockRecipeImageCache.swift
//  FetchRecipes_HEcho
//
//  Created by Hannah Echo on 3/3/25.
//

import Foundation
import UIKit
@testable import FetchRecipes_HEcho

class MockRecipeImageCache: RecipeImageCacheProtocol, @unchecked Sendable {
    var cachedImage: UIImage?
    
    func getImageFromCache(for recipe: Recipe, imageSize: ImageSizeClass) async -> UIImage? {
        return cachedImage
    }
    
    func addImageToCache(_ image: UIImage, imageSize: ImageSizeClass, for recipe: Recipe) async {
        cachedImage = image
    }
}
