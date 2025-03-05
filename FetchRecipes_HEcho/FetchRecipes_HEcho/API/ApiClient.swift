//
//  ApiClient.swift
//  FetchRecipes_HEcho
//
//  Created by Hannah Echo on 3/2/25.
//

import Foundation
import UIKit

protocol URLSessionProtocol: Sendable {
    func data(from url: URL) async throws -> (Data, URLResponse)
    func decode<T: Decodable>(_ type: T.Type, from url: URL, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy) async throws -> T
}

protocol ApiClientProtocol: Sendable {
    func fetchRecipeData(for url: String) async throws -> [Recipe]
    func fetchRecipeImage(_ recipe: Recipe, size: ImageSizeClass, url: URL) async throws -> UIImage?
}

actor ApiClient: ApiClientProtocol {
    static let shared = ApiClient()
    private let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetchRecipeData(for url: String = ApiConstants.recipeUrl) async throws -> [Recipe] {
        do {
            // Fetch and decode the recipes
            guard let url = URL(string: url) else {
                throw APIClientError.invalidURL
            }
            
            let recipes = try await urlSession.decode(Recipes.self,
                                                      from: url,
                                                      keyDecodingStrategy: .useDefaultKeys)
            return recipes.recipes
        } catch let error as APIClientError {
            throw error
        } catch {
            throw APIClientError.dataFetchFailed
        }
    }
    
    func fetchRecipeImage(_ recipe: Recipe, size: ImageSizeClass, url: URL) async throws -> UIImage? {
        do {
            // Fetch image data
            let (data, _) = try await urlSession.data(from: url)
            
            guard let image = UIImage(data: data) else {
                throw APIClientError.imageConversionFailed
            }
            
            // Cache the downloaded image
            await RecipeImageCache.shared.addImageToCache(image, imageSize: size, for: recipe)
            
            return image
        } catch {
            throw APIClientError.imageDownloadFailed
        }
    }
    
    
}


extension URLSession: URLSessionProtocol {
    func decode<T: Decodable>(_ type: T.Type = T.self,
                              from url: URL,
                              keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy
    ) async throws -> T {
        let (data, _) = try await data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
    
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        } catch {
            throw APIClientError.decodingFailed
        }
    }
}
