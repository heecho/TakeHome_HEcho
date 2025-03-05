//
//  RecipeImageCacheTests.swift
//  FetchRecipes_HEchoTests
//
//  Created by Hannah Echo on 3/2/25.
//

import Testing
import UIKit
@testable import FetchRecipes_HEcho

struct RecipeImageCacheTests {
    let cache = RecipeImageCache.shared
    let testImage = UIImage(systemName: "fork.knife")! // Mock image
    let mockRecipe = DataMocks.recipeMock
    
    // Test add image to cache and retrieve
    @Test func testAddImageToCacheAndRetrieve() async {
        await cache.addImageToCache(testImage, imageSize: .small, for: mockRecipe)
        let cachedImage = await cache.getImageFromCache(for: mockRecipe, imageSize: .small)
        
        #expect(cachedImage != nil, "Image should be present in cache")
        #expect(cachedImage == testImage, "Retrieved image should match stored image")
    }
    
    // Test retrieve image not in cache
    @Test func testRetrieveImage_NotInCache() async {
        let cachedImage = await cache.getImageFromCache(for: mockRecipe, imageSize: .large)
        
        #expect(cachedImage == nil, "Cache should return nil for an image that was never added")
    }
}
