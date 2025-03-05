//
//  ApiConstants.swift
//  FetchRecipes_HEcho
//
//  Created by Hannah Echo on 3/2/25.
//

enum ApiConstants {
    static let recipeUrl: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    static let emptyDataUrl: String = "https://d3jbb8n5wk0qxi.cloudfront.net/empty_recipes.json"
    static let malformedUrl: String = "https:///d3jbb8n5wk0qxi.cloudfront.net/recipes.jason"
}

enum APIClientError: Error {
    case invalidURL
    case dataFetchFailed
    case decodingFailed
    case imageDownloadFailed
    case imageConversionFailed
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .dataFetchFailed:
            return "Data fetch failed"
        case .decodingFailed:
            return "Decoding failed"
        case .imageDownloadFailed:
            return "Failed to load image"
        case .imageConversionFailed:
            return "Image conversion failed"
        }
    }
    
    var informationalMessage: String {
        switch self {
        case .invalidURL:
            return "Please check the URL and try again."
        case .dataFetchFailed:
            return "We encountered an issue fetching data. Please try again later."
        case .decodingFailed:
            return "We encountered an issue parsing the data. Please try again later."
        case .imageDownloadFailed, .imageConversionFailed:
            return "We encountered an issue downloading the image. Please try again later."
        }
    }
}
