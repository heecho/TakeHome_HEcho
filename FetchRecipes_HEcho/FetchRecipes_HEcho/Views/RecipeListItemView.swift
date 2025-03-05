//
//  RecipeListItemView.swift
//  FetchRecipes_HEcho
//
//  Created by Hannah Echo on 3/2/25.
//


import SwiftUI

struct RecipeListItemView: View {
    let recipe: Recipe
    let size: ImageSizeClass
    
    @StateObject var imageLoader = ImageLoader ()
    @State private var image: UIImage?
    
    var body: some View {
        HStack {
            switch imageLoader.viewState {
            case .loading:
                ProgressView()
                    .frame(width: 44, height: 44)
            case .loaded:
                RecipeImageView()
            case .empty, .error:
                EmptyImageView(size: .small)
            }
            
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
                self.image = try? await imageLoader.fetchRecipeImage(recipe, size: size)
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
            EmptyImageView(size: .small)
        }
    }
}

#Preview {
    RecipeListItemView(recipe: RecipeMock.recipeMock, size: .small)
}
