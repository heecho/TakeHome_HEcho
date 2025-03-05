//
//  EmptyImageView.swift
//  FetchRecipes_HEcho
//
//  Created by Hannah Echo on 3/2/25.
//

import SwiftUI

struct EmptyImageView: View {
    var size: ImageSizeClass
    
    var body: some View {
        switch size {
        case .small:
            Image(systemName: "photo")
                .resizable()
                .frame(width: 60, height: 60)
        case .large:
            Image(systemName: "photo")
                .resizable()
                .frame(width: 250, height: 250)
        }
        
    }
}
