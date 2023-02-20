//
//  Recipe.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 20.02.2023.
//

import Foundation

// Referans Recipe struct modelidir
// Değişken isimleri JSON formatından farklıdır
// JSON'dan decode edilip datalar bu değişkenlere atanacak
struct Recipe {
    var title : String?
    var imageURL : String?
    var timeRequired : Int?
    var sourceURL : String?
    var ingredients : [String]?
    var instructions : [String]?
    var servings: Int?
}
