//
//  MockApiClient.swift
//  FetchRecipes_HEcho
//
//  Created by Hannah Echo on 3/3/25.
//

import Foundation
import UIKit
@testable import FetchRecipes_HEcho

class MockApiClient: ApiClientProtocol, @unchecked Sendable {
    var fetchRecipeDataResult: [Recipe]?
    var fetchRecipeDataError: APIClientError?
    
    var fetchRecipeImageResult: UIImage?
    var fetchRecipeImageError: APIClientError?
    
    func fetchRecipeData(for url: String) async throws -> [Recipe] {
        if let error = fetchRecipeDataError {
            throw error
        }
        return fetchRecipeDataResult ?? []
    }
    
    func fetchRecipeImage(_ recipe: Recipe, size: ImageSizeClass, url: URL) async throws -> UIImage? {
        if let error = fetchRecipeImageError {
            throw error
        }
        return fetchRecipeImageResult
    }
}
