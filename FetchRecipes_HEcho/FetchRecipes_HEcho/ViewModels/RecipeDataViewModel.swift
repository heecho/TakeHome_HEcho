//
//  RecipeDataViewModel.swift
//  FetchRecipes_HEcho
//
//  Created by Hannah Echo on 3/2/25.
//

import Foundation

class RecipeDataViewModel: ObservableObject {
    @Published var recipeList: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var state: String? = nil
    @Published var errorMessage: String?
    @Published var searchQuery: String = ""
    @Published var cuisineTypes: [CuisineType] = []
    @Published var selectedCuisine: CuisineType = .all
    
    var filteredRecipes: [Recipe] {
        var filteredRecipes = recipeList
        
        if !searchQuery.isEmpty {
            filteredRecipes = filteredRecipes.filter {
                $0.name.lowercased().contains(searchQuery.lowercased())
            }
        }
        
        switch selectedCuisine {
        case .all:
            return filteredRecipes
        case .cuisine(let string):
            filteredRecipes = filteredRecipes.filter {
                $0.cuisine.lowercased() == selectedCuisine.description.lowercased()
            }
        }
        return filteredRecipes
    }
    
    @MainActor
    func refresh() async {
        try? await fetchAllRecipes()
    }
    
    @MainActor
    func fetchAllRecipes() async throws{
        isLoading = true
        errorMessage = nil
        //state = nil
        do {
            self.recipeList = try await APIClient.shared.fetchAllRecipeData()
            self.getCuisineTypes()
        } catch {
            //Error handling
        }
        
        isLoading = false
    }
    
    private func getCuisineTypes() {
        let cuisines = Set(recipeList.map {
            CuisineType.cuisine($0.cuisine)
        })
        cuisineTypes = [CuisineType.all] + cuisines.sorted { $0.description < $1.description }
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
