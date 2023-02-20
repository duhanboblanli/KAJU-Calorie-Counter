//
//  SearchedRecipes.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 20.02.2023.
//

import Foundation

struct SearchedRecipes: Codable {
    let id: Int
    let title: String
    //Image URL
    let image: String
    // Image extension like jpg, jpeg
    let imageType: String
}
