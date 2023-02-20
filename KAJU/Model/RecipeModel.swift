//
//  RecipeApiModel.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 19.02.2023.
//

import Foundation
import UIKit

// Model for targetRecipes which is a list of recipes
struct RecipesData: Decodable {
    let hits: [RecipeData]
    let _links: NextPageData2
    
    private enum CodingKeys: String, CodingKey {
        case hits
        case _links
    }
}

struct RecipeData: Decodable {
    let recipe: Recipe
    private enum CodingKeys: String, CodingKey {
        case recipe = "recipe"
    }
}

struct Recipe: Decodable {
    let label: String?
    let image: String? // URL for API call to get UIImage object
    let url: String? // URL for API call to get detail website
    let calories: Float?
    let totalTime: Float?
    let ingredientLines: [String?]
    let cuisineType: [String?]
    let mealType: [String?]
    let dishType: [String?]

    private enum CodingKeys: String, CodingKey {
        case label
        case image
        case url
        case calories
        case totalTime
        case ingredientLines
        case cuisineType
        case mealType
        case dishType
    }
}

struct NextPageData2: Decodable {
    let next: NextPage2?
    
    private enum CodingKeys: String, CodingKey {
        case next = "next"
    }
}

struct NextPage2: Decodable {
    let href: String?
    
    private enum CodingKeys: String, CodingKey {
        case href
    }
}

//Recipe Cell'e Aktarılacak Bilgiler
struct RecipeStruct {
    let label: String?
    let calorie: Float?
    let image: UIImage? // URL for API call to get UIImage object
    let time: Float?
}
