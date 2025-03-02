//
//  RecipeListItemView.swift
//  FetchRecipes_HEcho
//
//  Created by Hannah Echo on 3/2/25.
//


import SwiftUI
import Combine

struct RecipeListItemView: View {
    let recipe: Recipe
    let size: ImageSizeClass
    
    @State private var image: UIImage?
    
    var body: some View {
        HStack {
            RecipeImageView()
            VStack(alignment: .leading, spacing: 4) {
                Text("\(recipe.name)")
                    .font(.headline)
                Text("\(recipe.cuisine)")
                    .font(.subheadline)
            }
            .padding(.horizontal, 4)
        }
        .onAppear {
            Task { @MainActor in
                self.image = try? await APIClient.shared.fetchRecipeImage(recipe, size: size)
            }
        }
    }
    
    @ViewBuilder
    private func RecipeImageView() -> some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 9))
        } else {
            Image(systemName: "photo")
                .resizable()
                .frame(width: 60, height: 60)
        }
    }
}

#Preview {
    RecipeListItemView(recipe: RecipeMock.recipeMock, size: .small)
}
