//
//  RecipeListView.swift
//  FetchRecipes_HEcho
//
//  Created by Hannah Echo on 3/2/25.
//

import SwiftUI
import Combine

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeDataViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 4) {
                HStack(spacing: 8) {
                    if !viewModel.cuisineTypes.isEmpty {
                        Menu {
                            ForEach(viewModel.cuisineTypes, id: \.self) { cuisine in
                                Button(cuisine.description, action: {
                                    viewModel.selectedCuisine = cuisine
                                })
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                        }
                    }
                    
                    TextField("Search recipes", text: $viewModel.searchQuery)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)
                
                if viewModel.recipeList.isEmpty {
                    ProgressView("Loading Recipes...")
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.filteredRecipes, id: \.self) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipe: recipe, size: .large)) {
                                RecipeListItemView(recipe: recipe, size: .small)
                            }
                        }
                    }
                    .refreshable {
                        await viewModel.refresh()
                    }
                   
                }
            }
            .task {
                try? await viewModel.fetchAllRecipes()
            }
            .navigationTitle("\(viewModel.selectedCuisine.description)Recipes")
        }
    }
}

#Preview {
    RecipeListView()
}
