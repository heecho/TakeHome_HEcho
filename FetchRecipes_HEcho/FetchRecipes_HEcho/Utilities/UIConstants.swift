//
//  UIConstants.swift
//  FetchRecipes_HEcho
//
//  Created by Hannah Echo on 3/2/25.
//

enum ImageSizeClass {
    case small
    case large
}

enum ViewState: Equatable {
    case loading
    case loaded
    case empty
    case error(String, String)
}
