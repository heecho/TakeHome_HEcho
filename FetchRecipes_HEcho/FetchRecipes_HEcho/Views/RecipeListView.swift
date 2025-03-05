//
//  RecipeListView.swift
//  FetchRecipes_HEcho
//
//  Created by Hannah Echo on 3/2/25.
//

import SwiftUI

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
                
                switch viewModel.viewState {
                case .loading:
                    ProgressView("Loading Recipes...")
                    Spacer()
                case .empty:
                    Text("There are no recipes to display, try a new search term or refresh the data.")
                        .padding()
                    Spacer()
                case .loaded:
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
                case .error(let title, let subtitle):
                    VStack(alignment: .center) {
                        Image(systemName: "exclamationmark.triangle")
                            .frame(width: 44, height: 44)
                        Text("\(title)")
                            .font(.headline)
                            .padding(.horizontal)
                        Text("\(subtitle)")
                            .font(.subheadline)
                            .padding(.horizontal)
                    }
                    .padding()
                    Spacer()
                }
            }
            .task {
                try? await viewModel.fetchAllRecipes()
            }
            .navigationTitle("\(viewModel.selectedCuisine.description) Recipes")
        }
    }
}

#Preview {
    RecipeListView()
}
