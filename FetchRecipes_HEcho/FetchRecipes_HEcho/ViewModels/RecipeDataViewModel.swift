//
//  RecipeDataViewModel.swift
//  FetchRecipes_HEcho
//
//  Created by Hannah Echo on 3/2/25.
//

import Foundation
import UIKit

@MainActor
class RecipeDataViewModel: ObservableObject {
    private let apiClient: ApiClientProtocol
    private var recipeList: [Recipe] = []
    
    @Published var viewState: ViewState = .loading
    @Published var searchQuery: String = "" {
        didSet { updateFilteredRecipes() }
    }
    @Published var cuisineTypes: [CuisineType] = []
    @Published var selectedCuisine: CuisineType = .all {
        didSet { updateFilteredRecipes() }
    }
    @Published private(set) var filteredRecipes: [Recipe] = []
    
    init(apiClient: ApiClientProtocol = ApiClient.shared) {
        self.apiClient = apiClient
    }
    
    func refresh() async {
        try? await fetchAllRecipes()
    }
    
    /// Loads the initial unfiltered recipe data set
    func fetchAllRecipes() async throws {
        do {
            self.recipeList = try await apiClient.fetchRecipeData(for: ApiConstants.recipeUrl)
            getCuisineTypes()
            updateFilteredRecipes()
        } catch let error as APIClientError {
            viewState = .error(error.description, error.informationalMessage)
            throw error
        }
        
        viewState = recipeList.isEmpty ? .empty : .loaded
    }
    
    /// Helper method to build cuisines from available recipes to populated dropdown menu
    private func getCuisineTypes() {
        let cuisines = Set(recipeList.map { CuisineType.cuisine($0.cuisine) })
        cuisineTypes = [CuisineType.all] + cuisines.sorted { $0.description < $1.description }
    }
    
    /// Updates `filteredRecipes` whenever the search query or selected cuisine changes.
    private func updateFilteredRecipes() {
        var filteredRecipes = recipeList
        if !searchQuery.isEmpty {
            filteredRecipes = filteredRecipes.filter {
                $0.name.lowercased().contains(searchQuery.lowercased())
            }
        }
        
        switch selectedCuisine {
        case .all:
            break
        case .cuisine:
            filteredRecipes = filteredRecipes.filter {
                $0.cuisine.lowercased() == selectedCuisine.description.lowercased()
            }
        }
        
        self.filteredRecipes = filteredRecipes
        self.viewState = filteredRecipes.isEmpty ? .empty : .loaded
    }
    
    enum CuisineType: Hashable {
        case all
        case cuisine(String)
        
        var description: String {
            switch self {
            case .all:
                return "All"
            case .cuisine(let type):
                return type
            }
        }
    }
}
