//
//  Recipe.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 20.02.2023.
//

import Foundation

// Reference Recipe struct model.
// Variable names are different from JSON format.
// The data will be decoded from JSON and assigned to these variables.
struct Recipe {
    var title : String?
    var imageURL : String?
    var timeRequired : Int?
    var sourceURL : String?
    var ingredients : [String]?
    var instructions : [String]?
    var servings: Int?
    var id: Int?
    var calories: Double?
    var carbs: Double?
    var fat: Double?
    var protein: Double?
    var sugar: Double?
}
