//
//  Model.swift
//  KAJU
//
//  Created by Umut Ulaş Demir on 14.02.2023.
//

import Foundation
import UIKit

// Model for targetFoods which is a list of foods
struct FoodsData: Decodable {
    let hints: [FoodData]
    let _links: NextPageData
    
    private enum CodingKeys: String, CodingKey {
        case hints
        case _links
    }
}

struct FoodData: Decodable {
    let food: Food
    private enum CodingKeys: String, CodingKey {
        case food = "food"
    }
}

struct Food: Decodable {
    let foodId: String?
    let label: String?
    let knownAs: String?
    let nutrients: Nutrients?
    let category: String?
    let categoryLabel: String?
    let image: String? // URL for API call to get UIImage object
    
    private enum CodingKeys: String, CodingKey {
        case foodId
        case label
        case knownAs
        case nutrients
        case category
        case categoryLabel
        case image
    }
}

struct Nutrients: Decodable {
    let ENERC_KCAL: Float?
    let PROCNT: Float?
    let FAT: Float
    let CHOCDF: Float
    let FIBTG: Float
    
    private enum CodingKeys: String, CodingKey {
        case ENERC_KCAL
        case PROCNT
        case FAT
        case CHOCDF
        case FIBTG
    }
}
    
struct NextPageData: Decodable {
    let next: NextPage?
    
    
    private enum CodingKeys: String, CodingKey {
        case next = "next"
    }
}

struct NextPage: Decodable {
    let href: String?
    
    private enum CodingKeys: String, CodingKey {
        case href
    }
}

struct FoodStruct {
    let label: String?
    let calorie: Float?
    let image: UIImage? // URL for API call to get UIImage object
}
