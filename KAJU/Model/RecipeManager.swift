//
//  RecipeManager.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 19.02.2023.
//

import Foundation
import UIKit

class RecipeManager {
    var apiService = RecipeApiService()
    // The list of recipes - list type is RecipeApiModel RecipeData struct
    private var targetRecipes = [RecipeData]()
    // The list of foods - list type is RecipeApiModel RecipeStruct struct
    private var targetRecipes1 = [RecipeStruct]()
    private var nextPageUrl: String = ""
    
    // Full URL
    // https://api.edamam.com/api/recipes/v2?type=public&app_id=78a155af&app_key=4d8c707a337640bf241ab4076fc94de7&imageSize=LARGE
    
    // Random Added URL
    // https://api.edamam.com/api/recipes/v2?type=public&app_id=78a155af&app_key=4d8c707a337640bf241ab4076fc94de7&imageSize=LARGE&random=true
    
    private let recipe_app_id = "78a155af"
    private let recipe_app_key = "4d8c707a337640bf241ab4076fc94de7"
    
    // The API call to get the recipes
    func fetchRecipeData(pagination: Bool, completion: @escaping () -> ()) {
        //app_id=78a155af   &app_key=4d8c707a337640bf241ab4076fc94de7    &imageSize=LARGE
        var recipesUrl: String?
        
        if pagination == false{
            recipesUrl = "https://api.edamam.com/api/recipes/v2?type=public&app_id=" + recipe_app_id +
            "&app_key=" + recipe_app_key + "&imageSize=LARGE"
        }
        
        else{
            recipesUrl = nextPageUrl
        }
        // weak self - prevent retain cycles
        print("Fetching food data.. : ", recipesUrl ?? "ERROR: URL Not Found! (RecipesManager.swift)")
        apiService.getRecipesData(pagination: pagination, recipesUrl: recipesUrl!) { [weak self] (result) in
            print("apiService.getRecipesData:")
            print(result)
            switch result{
            case .success(let listOf):
                var currentCount = self?.targetRecipes.count
                var url2 = ""
                self?.targetRecipes.append(contentsOf: listOf.hits)
                self?.nextPageUrl = (listOf._links.next?.href)!
                self?.targetRecipes1 = self!.targetRecipes1 + Array(repeating: RecipeStruct(label: "", calorie: 0.0, image: UIImage(named: "Egg-Breakfast-PNG-Download-Image"), time: 0.0), count: listOf.hits.count)
                for (i, recipe) in listOf.hits.enumerated(){
                    if recipe.recipe.image == nil{
                        url2 = "https://www.edamam.com/food-img/541/541e46e44ba61aec8bcd599df94c0eed.jpg"
                    }
                    else {
                        url2 = recipe.recipe.image!
                    }
                    self!.fetchRecipeImage(url: url2, index: currentCount! + i){ [weak self] in
                        print("noluyo aq")
                    }
                }
                
                //self?.Images = Array(repeating: UIImage(named: "background")!, count: listOf.games.count)
                completion()
            case .failure(let error):
                // Something is wrong with the JSON file or the model
                print("Error processing json data: \(error)")
            }
        }
    }
    // The API call to get the recipes images
    func fetchRecipeImage(url: String, index: Int, completion: @escaping () -> ()) {
        
        let recipe = self.targetRecipes[index].recipe
        
        print("Fetching image.. ", url)
        apiService.getImageDataFrom(url: url) { [weak self] (result) in
            print(result)
            switch result{
            case .success(let listOf):
                print("Fetching image.. !!!!!!!!!!!")
                self?.targetRecipes1[index] = RecipeStruct(label: recipe.label, calorie: recipe.calories, image: listOf, time: recipe.totalTime)
               
            case .failure(let error):
                // Something is wrong with the JSON file or the model
                print("Error processing json data: \(error)")
            }
        }
    }

    func clearData(){
        targetRecipes.removeAll()
    }

    func getFoods()->[RecipeData]{
        return targetRecipes
    }
    func getNextPage()->String{
        return nextPageUrl
    }

    func getCount()->Int{
        return targetRecipes.count
    }

    // Return the number of foods in targetFoods
    func numberOfRowsInSection(section: Int) -> Int {
        if targetRecipes.count != 0 {
            print("Total foods count: ",targetRecipes.count)
            return targetRecipes.count
        }
        return 0
    }

    // Return the food at index 'indexPath' of targetFoods
    func cellForRowAt (indexPath: IndexPath) -> RecipeStruct {
        return targetRecipes1[indexPath.row]
    }
}





