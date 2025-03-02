//
//  Recipe.swift
//  FetchRecipes_HEcho
//
//  Created by Hannah Echo on 3/2/25.
//

struct Recipe: Codable, Hashable, Identifiable, Sendable {
    let cuisine: String
    let name: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let id: String
    let sourceUrl: String?
    let youtubeUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case cuisine, name
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }
}

struct Recipes: Codable {
    var recipes: [Recipe]
}

struct RecipeMock {
    static let recipeMock: Recipe = .init(
        cuisine: "American",
        name: "Mock Recipe",
        photoUrlLarge: nil,
        photoUrlSmall: nil,
        id: "12345",
        sourceUrl: nil,
        youtubeUrl: nil
    )
}
