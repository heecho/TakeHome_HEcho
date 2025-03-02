//
//  RecipeDetailView.swift
//  FetchRecipes_HEcho
//
//  Created by Hannah Echo on 3/2/25.
//

import SwiftUI
import Combine

struct RecipeDetailView: View {
    let recipe: Recipe
    let size: ImageSizeClass
    
    @State private var image: UIImage?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let _ = image {
                RecipeImageView()
            } else {
                ProgressView()
                    .task {
                        self.image = try? await APIClient.shared.fetchRecipeImage(recipe, size: size)
                    }
                    .frame(width: 200, height: 200)
                    .padding()
            }
            
            VStack(alignment: .leading, content: {
                RecipeTitleView()
                    .padding(.horizontal, 8)
                ExternalLinksView()
                    .padding(.horizontal, 8)
                Spacer()
            })
        }
        .padding()
    }
    
    @ViewBuilder
    private func RecipeImageView() -> some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .frame(height: 300)
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: Color.black.opacity(0.25), radius: 12, x: 0, y: 4)
        } else {
            Image(systemName: "photo")
                .resizable()
                .frame(width: 300, height: 300)
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
