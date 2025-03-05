//
//  ImageLoaderTests.swift
//  FetchRecipes_HEcho
//
//  Created by Hannah Echo on 3/3/25.
//

import Testing
import UIKit
@testable import FetchRecipes_HEcho

@MainActor
final class ImageLoaderTests {
    var imageLoader: ImageLoader!
    var mockApiClient: MockApiClient!
    var mockImageCache: MockRecipeImageCache!

    init() {
        mockApiClient = MockApiClient()
        mockImageCache = MockRecipeImageCache()
        imageLoader = ImageLoader(apiClient: mockApiClient, imageCache: mockImageCache)
    }

    func setUp() {
        mockApiClient = MockApiClient()
        mockImageCache = MockRecipeImageCache()
        imageLoader = ImageLoader(apiClient: mockApiClient, imageCache: mockImageCache)
    }

    func tearDown() {
        imageLoader = nil
        mockApiClient = nil
        mockImageCache = nil
    }

    // Test fetch image failure from network
    @Test func testFetchRecipeImageNetworkFailure() async {
        let mockError = APIClientError.imageDownloadFailed
        
        // Mock network failure
        mockApiClient.fetchRecipeImageError = mockError
        
        // Fetch image
        let image = try? await imageLoader.fetchRecipeImage(DataMocks.recipeMock, size: .small)

        // Verify error state
        #expect(image == nil, "The image should be nil due to network failure.")
        #expect(imageLoader.viewState == .error(APIClientError.imageDownloadFailed.description, APIClientError.imageDownloadFailed.informationalMessage), "The viewState should reflect the network error.")
    }
    
    // Test fetching image from cache
    @Test
    func testFetchRecipeCachedImage_Success() async {
        let mockImage = UIImage(systemName: "star")!
        // Simulating a cached image
        mockImageCache.cachedImage = mockImage

        let result = try? await imageLoader.fetchRecipeImage(DataMocks.recipeMock, size: .small)
        
        #expect(result == mockImage)
        #expect(imageLoader.viewState == .loaded)
    }
    
    // Test fetching image from network
    @Test func testFetchRecipeImageFromNetwork() async {
        let mockImage = UIImage(systemName: "star")!

        // Mock successful image response
        mockApiClient.fetchRecipeImageResult = mockImage

        // Fetch image
        let image = try? await imageLoader.fetchRecipeImage(DataMocks.recipeMock, size: .large)

        // Verify the image fetched from network is returned
        #expect(image == mockImage, "The fetched image should be from the network.")
        #expect(imageLoader.viewState == .loaded, "The viewState should be loaded.")
    }
}
