//
//  ApiClientTests.swift
//  FetchRecipes_HEchoTests
//
//  Created by Hannah Echo on 3/2/25.
//

import Testing
import UIKit
@testable import FetchRecipes_HEcho

struct APIClientTests {
    let imageCache = RecipeImageCache.shared
    
    let testRecipe = DataMocks.recipeMock
    let testImage = UIImage(systemName: "photo")!
    
    // Test recipe data fetch success
    @Test func testFetchAllRecipeData_Success() async throws {
        let mockURLSession = MockURLSession(mockData: DataMocks.recipesJsonResponse)
        let apiClient = ApiClient(urlSession: mockURLSession)
        
        let recipes = try await apiClient.fetchRecipeData()
        
        #expect(recipes.count == 7, "Should return 7 recipes")
        #expect(recipes[0].id == "0c6ca6e7-e32a-4053-b824-1dbf749910d8", "First recipe ID should be 0c6ca6e7-e32a-4053-b824-1dbf749910d8")
    }
    
    // Test recipe data empty response
    @Test func testFetchAllRecipeData_EmptyResponse() async throws {
        let mockURLSession = MockURLSession(mockData: DataMocks.emptyJsonResponse)
        let apiClient = ApiClient(urlSession: mockURLSession)
        
        let recipes = try await apiClient.fetchRecipeData()
        
        #expect(recipes.isEmpty, "Should return an empty array when response is empty")
    }
    
    // Test recipe data malformed
    @Test func testFetchAllRecipeData_MalformedResponse() async throws {
        let mockURLSession = MockURLSession(mockData: DataMocks.malformedJsonResponse)
        let apiClient = ApiClient(urlSession: mockURLSession)
        
        await #expect(throws: APIClientError.decodingFailed) {
            try await apiClient.fetchRecipeData()
        }
    }
    
    // Test recipe image fetch from network, no cache
    @Test func testFetchRecipeImage_FromNetwork() async throws {
        let mockURLSession = MockURLSession(mockData: testImage.pngData()!)
        let apiClient = ApiClient(urlSession: mockURLSession)
        
        let image = try await apiClient.fetchRecipeImage(testRecipe, size: .small, url: URL(string: "www.mock-image.com")!)
        
        #expect(image != nil, "Should fetch image from network if not cached")
    }
}

