//
//  SearchResultResponse.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 20.02.2023.
//

import Foundation

struct SearchResultResponse: Codable {
    let offset: Int
    let number: Int
    let totalResults: Int
    let results: [SearchedRecipes]
}
