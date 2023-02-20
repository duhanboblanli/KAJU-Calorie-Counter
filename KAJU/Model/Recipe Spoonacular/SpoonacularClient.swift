//
//  SpoonacularClient.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 20.02.2023.
//

import UIKit

class SpoonacularClient {
    // af5551aeb300483382684e0f90ad9367
    // a67a5241c34f45429f75c2d8a1858a67
    static let apiKey = "af5551aeb300483382684e0f90ad9367"
    static let host = "api.spoonacular.com"
    static let scheme = "https"
    // Full URL
    // https://api.spoonacular.com/recipes/random?apiKey=a67a5241c34f45429f75c2d8a1858a67&number=8
    
    // Declare URL
    static var randomRecipeURL: URL {
        var components = URLComponents()
        components.host = host
        components.path = "/recipes/random"
        components.scheme = scheme
        //Query itemlerdan önce gelmesi gereken '?', '&', '=' gibi semboller otomatik atanır
        components.queryItems = [URLQueryItem]()
        components.queryItems?.append(URLQueryItem(name: "apiKey", value: SpoonacularClient.apiKey))
        // Kaç tane recipes verisi çekilsin?
        components.queryItems?.append(URLQueryItem(name: "number", value: "8"))
        print("Full URL: " , components.url!)
        return components.url!
    }
    
    // JSON datayı Model.Recipe tipinde döndürür
    class func getRandomRecipe(completion: @escaping ([Recipe], Error?) -> Void) {
        // URL task'e verilir
        let task = URLSession.shared.dataTask(with: SpoonacularClient.randomRecipeURL) { (data, response, error) in
            if error != nil {
                // Nil Array ve error döner
                completion([], error)
                return
            }
            guard let data = data else {
                completion([], error)
                return
            }
            do {
                // responseObject: Optional([AnyHashable("recipes"): <__NSArrayI 0x6000020d54a0> {JSON verilerini NSArray'de döndürür}
                let responseObject = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [AnyHashable: Any]
                // JSON verilerinin "recipes" listesinden, veriler dict olarak alınır ve arraye atılır
                if let recipeArray = responseObject?["recipes"] as? [[String: Any]] {
                    // Recipe struct modelinde recipes arrayi döner
                    let recipes = createRecipes(recipeArray: recipeArray)
                    // Recipes ve nil error döner
                    completion(recipes, nil)
                }
                else {
                    completion([], error)
                }
            } catch {
                completion([], error)
            }
        }
        task.resume()
    }
    
    // JSON verilerini Recipe modele uygun şekilde arraye dönüştürür
    // Recipe struct modelinde recipes arrayi döner
    private class func createRecipes(recipeArray: [[String: Any]]) -> [Recipe] {
        var recipes = [Recipe]()
        for recipeInfo in recipeArray {
            let recipe = configureRecipe(recipeInfo: recipeInfo)
            recipes.append(recipe)
        }
        return recipes
    }
    
    // Json verileri listesindeki dict verileri tipine göre Recipe struct değişkenlerine atanır
    // Recipe tipinde değişkeni döndürür
    private class func configureRecipe(recipeInfo: [String: Any]) -> Recipe{
        var recipe = Recipe()
        
        // Key: title , value: String ise recipe.title'a atanır
        if let title = recipeInfo["title"] as? String {
            recipe.title = title
        }
        
        if let servings = recipeInfo["servings"] as? Int {
            recipe.servings = servings
        }
        
        if let imageURL = recipeInfo["image"] as? String {
            recipe.imageURL = imageURL
        }
        
        if let sourceURL = recipeInfo["sourceUrl"] as? String {
            recipe.sourceURL = sourceURL
        }

        if let ingredientArray = recipeInfo["extendedIngredients"] as? [[String: Any]] {
            if ingredientArray.count == 0 {
                recipe.ingredients = []
            } else {
                var ingredients = [String]()
                for ingredient in ingredientArray {
                    if let ingredient = ingredient["original"] as? String {
                        ingredients.append(ingredient)
                    }
                }
                recipe.ingredients = ingredients
                            }
        } else {
            recipe.ingredients = []
        }
        
        if let timeRequired = recipeInfo["readyInMinutes"] as? Int {
            recipe.timeRequired = timeRequired
        }
        
        if let instructions = recipeInfo["analyzedInstructions"] as? [[String : Any]]  {
            if instructions.count == 0 {
                recipe.instructions = []
            } else {
                var instructionsArray = [String]()
                for instructionSteps in instructions {
                    if let instructionSteps = instructionSteps["steps"] as? [[String : Any]] {
                        for step in instructionSteps {
                            if let instructionStep = step["step"] as? String {
                                instructionsArray.append(instructionStep)
                            }
                        }
                    }
                }
                recipe.instructions = instructionsArray
            }
        } else {
            recipe.instructions = []
        }
        return recipe
    }
    
    // String şeklinde verilen imageURL'i UIImage tipine dönüştürür
    class func downloadRecipeImage(imageURL: String, completion: @escaping (UIImage?, Bool) -> Void) {
        if let url = URL(string: imageURL) {
            DispatchQueue.global(qos: .userInitiated).async {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard let data = data else {
                        completion(nil, false)
                        return
                    }
                    DispatchQueue.main.async{
                        completion(UIImage(data: data), true)
                    }
                }
                task.resume()
            }
        }
    }
    
    // Id Int parametre olarak alınır ve tek bir Recipe döndürür
    // Örn URL:
    // https://api.spoonacular.com/recipes/9042/information?apiKey=a67a5241c34f45429f75c2d8a1858a67&number=8
    class func getUserSearchedRecipe(id: Int, completion: @escaping (Recipe?, Bool, Error?) -> Void){
        var url: URL {
            var components = URLComponents()
            components.host = host
            components.path = "/recipes/\(id)/information"
            components.scheme = scheme
            
            components.queryItems = [URLQueryItem]()
            components.queryItems?.append(URLQueryItem(name: "apiKey", value: SpoonacularClient.apiKey))
            
            return components.url!
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(nil, false, error)
                return
            }
            guard let data = data else {
                completion(nil, false, error)
                return
            }
            do {
                if let responseObject = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] {
                    let recipe = configureRecipe(recipeInfo: responseObject)
                    completion(recipe, true, nil)
                }
            } catch {
                completion(nil, false, error)
            }
            
        }
        task.resume()
    }
    
    // Query String olarak alınır ve AutoCompleteSearchResponse modelinde liste döndürür
    // Verilen stringe benzer stringde recipeler bu modelde listelenir
    // Örn URL
    //https://api.spoonacular.com/recipes/autocomplete?apiKey=a67a5241c34f45429f75c2d8a1858a67&number=8&query=chicken
    class func autoCompleteRecipeSearch(query: String, completion: @escaping ([AutoCompleteSearchResponse], Error?) -> Void) -> URLSessionTask {
        var searchURL: URL {
            var components = URLComponents()
            components.host = host
            components.path = "/recipes/autocomplete"
            components.scheme = scheme
            
            components.queryItems = [URLQueryItem]()
            components.queryItems?.append(URLQueryItem(name: "apiKey", value: SpoonacularClient.apiKey))
            components.queryItems?.append(URLQueryItem(name: "number", value: "8"))
            components.queryItems?.append(URLQueryItem(name: "query", value: query))
            
            return components.url!
        }
        let task = URLSession.shared.dataTask(with: searchURL) { (data, response, error) in
            guard let data = data else {
                completion([], error)
                return
            }
            do {
                let responseObject = try JSONDecoder().decode([AutoCompleteSearchResponse].self, from: data)
                completion(responseObject, nil)
            } catch {
                completion([], error)
            }
        }
        return task
    }
    
    // Query String olarak alınır ve SearchedRecipes modelinde liste döndürür
    // Verilen stringe benzer stringde recipeler bu modelde listelenir
    // Örn URL
    // https://api.spoonacular.com/recipes/complexSearch?apiKey=a67a5241c34f45429f75c2d8a1858a67&number=8&query=chicken
    class func search(query: String, completion: @escaping ([SearchedRecipes], Bool, Error?) -> Void) {
        var searchURL: URL {
            var components = URLComponents()
            components.host = host
            components.path = "/recipes/complexSearch"
            components.scheme = scheme
            
            components.queryItems = [URLQueryItem]()
            components.queryItems?.append(URLQueryItem(name: "apiKey", value: SpoonacularClient.apiKey))
            components.queryItems?.append(URLQueryItem(name: "number", value: "8"))
            components.queryItems?.append(URLQueryItem(name: "query", value: query))
            
            return components.url!
        }
        
        let task = URLSession.shared.dataTask(with: searchURL) { (data, response, error) in
            guard let data = data else {
                completion([], false, error)
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                completion(responseObject.results, true, nil)
            } catch {
                completion([], false, error)
            }
        }
        task.resume()
    }
    
    
}


