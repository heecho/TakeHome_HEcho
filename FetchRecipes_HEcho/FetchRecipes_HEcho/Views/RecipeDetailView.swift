//
//  RecipeDetailView.swift
//  FetchRecipes_HEcho
//
//  Created by Hannah Echo on 3/2/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    let size: ImageSizeClass
    
    @StateObject var imageLoader = ImageLoader ()
    @State private var image: UIImage?
    
    private let imageSize: CGSize = CGSize(width: 300, height: 300)
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            switch imageLoader.viewState {
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(height: imageSize.height)
            case .loaded:
                RecipeImageView()
            case .empty, .error:
                EmptyImageView(size: .large)
            }
            
            VStack(alignment: .leading, content: {
                RecipeTitleView()
                    .padding(.horizontal, 8)
                ExternalLinksView()
                    .padding(.horizontal, 8)
                Spacer()
            })
        }
        .onAppear {
            Task { @MainActor in
                self.image = try? await imageLoader.fetchRecipeImage(recipe, size: size)
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private func RecipeImageView() -> some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .frame(height: imageSize.height)
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: Color.black.opacity(0.25), radius: 12, x: 0, y: 4)
        } else {
            EmptyImageView(size: .large)
        }
    }
    
    @ViewBuilder
    private func RecipeTitleView() -> some View {
        HStack(spacing: 4) {
            Text("\(recipe.name)")
                .font(.title3)
            Text(" | ")
            Text("\(recipe.cuisine)")
                .font(.title3)
            Spacer()
        }
    }
    
    @ViewBuilder
    private func ExternalLinksView() -> some View {
        HStack(spacing: 16){
            if let webLink = recipe.sourceUrl {
                Button(action:  {
                    openExternalLink(webLink)
                }) {
                    HStack{
                        Image(systemName: "link.circle")
                            .frame(width: 16, height: 20)
                        Text("Recipe Website")
                            .fontWeight(.semibold)
                    }
                }
            }
            
            if let videoLink = recipe.youtubeUrl {
                Button(action:  {
                    openExternalLink(videoLink)
                }) {
                    HStack{
                        Image(systemName: "play.circle")
                            .frame(width: 16, height: 20)
                        Text("YouTube Video")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }
    
    private func openExternalLink(_ url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
    
}

#Preview {
    RecipeDetailView(recipe: RecipeMock.recipeMock, size: .large)
}
