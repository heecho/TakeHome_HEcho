//
//  RecipeDataViewModelTests.swift
//  FetchRecipes_HEcho
//
//  Created by Hannah Echo on 3/2/25.
//

import Testing
import UIKit
@testable import FetchRecipes_HEcho

@MainActor
final class RecipeDataViewModelTests {
    var viewModel: RecipeDataViewModel!
    var mockApiClient: MockApiClient!
    
    init() {
        mockApiClient = MockApiClient()
        viewModel = RecipeDataViewModel(apiClient: mockApiClient)
    }

    func setUp() {
        mockApiClient = MockApiClient()
        viewModel = RecipeDataViewModel(apiClient: mockApiClient)
    }

    func tearDown() {
        mockApiClient = nil
        viewModel = nil
    }

    // Test fetching recipes successfully
    @Test func testFetchRecipesSuccess() async {
        let mockRecipes = [DataMocks.recipeMock]
        
        mockApiClient.fetchRecipeDataResult = mockRecipes
        
        try? await viewModel.fetchAllRecipes()
        
        #expect(viewModel.viewState == .loaded, "The view state should be loaded after fetching recipes.")
        #expect(viewModel.filteredRecipes == mockRecipes, "The filtered recipes should match the mock recipes.")
    }

    // Test fetching recipes failure
    @Test func testFetchRecipesFailure() async {
        mockApiClient.fetchRecipeDataError = APIClientError.dataFetchFailed
        
        try? await viewModel.fetchAllRecipes()
        
        #expect(viewModel.viewState == .error("Data fetch failed", "We encountered an issue fetching data. Please try again later."), "The view state should be error on failure.")
    }

    // Test search functionality
    @Test func testSearchRecipes() async {
        let recipe1 = DataMocks.recipeMock
        let recipe2 = Recipe(cuisine: "Italian", name: "Pizza", photoUrlLarge: nil, photoUrlSmall: nil, id: "2", sourceUrl: nil, youtubeUrl: nil)
        
        mockApiClient.fetchRecipeDataResult = [recipe1, recipe2]
        
        try? await viewModel.fetchAllRecipes()
        
        // Simulate search query
        viewModel.searchQuery = "pizza"
        
        #expect(viewModel.filteredRecipes.count == 1, "There should be only one recipe matching the search query.")
        #expect(viewModel.filteredRecipes.first?.name == "Pizza", "The filtered recipe should be the one matching the search query.")
    }

    // Test changing cuisine filter
    @Test func testCuisineFilter() async {
        let recipe1 = DataMocks.recipeMock
        let recipe2 = Recipe(cuisine: "Italian", name: "Pizza", photoUrlLarge: nil, photoUrlSmall: nil, id: "2", sourceUrl: nil, youtubeUrl: nil)
        
        mockApiClient.fetchRecipeDataResult = [recipe1, recipe2]
        
        try? await viewModel.fetchAllRecipes()
        
        // Simulate selecting a cuisine
        viewModel.selectedCuisine = .cuisine("Italian")
        
        #expect(viewModel.filteredRecipes.count == 1, "There should be only one recipe matching the selected cuisine.")
        #expect(viewModel.filteredRecipes.first?.cuisine == "Italian", "The filtered recipe should match the selected cuisine.")
    }
}
