//
//  SpoonacularClient.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 20.02.2023.
//

import UIKit
import Foundation

class SpoonacularClient {
    
    //static let apiKeys: [String] = ["8b8db97d79c840ec95ae4c7c472b8fdd","0706fa7896064f859e95c8cb220b288e","a67a5241c34f45429f75c2d8a1858a67"]
    //static let randomInt = Int.random(in: 0..<3)
    
    // ege - 8b8db97d79c840ec95ae4c7c472b8fdd
    // duhan - 0706fa7896064f859e95c8cb220b288e
    // duhan2 - 1b7e88a834da447bbb98991d223bceb8
    // duhan3 - cec51adb54d74837a287543d74a80cc9
    // unknown - a67a5241c34f45429f75c2d8a1858a67
    static var apiKey = "a67a5241c34f45429f75c2d8a1858a67"
    static let host = "api.spoonacular.com"
    static let scheme = "https"
    // Random URL
    // https://api.spoonacular.com/recipes/random?apiKey=a67a5241c34f45429f75c2d8a1858a67&number=8&tags=
    
    // Complex Search URL
    // https://api.spoonacular.com/recipes/complexSearch?apiKey=8b8db97d79c840ec95ae4c7c472b8fdd&number=8&addRecipeNutrition=true&fillIngredients=true&instructionsRequired=true
    
    
    // Declare URL
    static var randomRecipeURL: URL {
        //Random kapalı tüm api keyler açılınca açabilirsin!!
        let apiKeys: [String] = ["8b8db97d79c840ec95ae4c7c472b8fdd","0706fa7896064f859e95c8cb220b288e","a67a5241c34f45429f75c2d8a1858a67","1b7e88a834da447bbb98991d223bceb8","cec51adb54d74837a287543d74a80cc9"]
        let randomInt = Int.random(in: 0..<apiKeys.count)
        let randomOffsetInt = Int.random(in: 1...900)
        let randomOffsetString = String(randomOffsetInt)
        var components = URLComponents()
        components.host = host
        components.path = "/recipes/complexSearch"
        components.scheme = scheme
        //Query itemlerdan önce gelmesi gereken '?', '&', '=' gibi semboller otomatik atanır
        components.queryItems = [URLQueryItem]()
        //SpoonacularClient.apiKey = apiKeys[randomInt]
        components.queryItems?.append(URLQueryItem(name: "apiKey", value: SpoonacularClient.apiKey))
        // Kaç tane recipes verisi çekilsin?
        components.queryItems?.append(URLQueryItem(name: "number", value: "20"))
        components.queryItems?.append(URLQueryItem(name: "addRecipeNutrition", value: "true"))
        components.queryItems?.append(URLQueryItem(name: "fillIngredients", value: "true"))
        components.queryItems?.append(URLQueryItem(name: "instructionsRequired", value: "true"))
        components.queryItems?.append(URLQueryItem(name: "offset", value: randomOffsetString))
        
        print("Full URL: " , components.url!)
        return components.url!
    }
    
    static var task: URLSessionDataTask?
    static var isPaginating = false
    // JSON datayı Model.Recipe tipinde döndürür
    class func getRandomRecipe(pagination: Bool,completion: @escaping ([Recipe], Error?) -> Void) {
        DispatchQueue.main.async {
            if pagination {
                isPaginating = true
            } }
            // URL task'e verilir
            task = URLSession.shared.dataTask(with: SpoonacularClient.randomRecipeURL) { (data, response, error) in
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
                    if let recipeArray = responseObject?["results"] as? [[String: Any]] {
                        // Recipe struct modelinde recipes arrayi döner
                        let recipes = createRecipes(recipeArray: recipeArray)
                        // Recipes ve nil error döner
                        
                        DispatchQueue.main.async {
                            completion(recipes, nil)
                            if pagination{
                                self.isPaginating = false
                            }
                        }
                    }
                    else {
                        completion([], error)
                    }
                } catch {
                    completion([], error)
                }
            }
            task?.resume()
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
        
        if let id = recipeInfo["id"] as? Int {
            recipe.id = id
        }
        // Key: title , value: String ise recipe.title'a atanır
        if let title = recipeInfo["title"] as? String {
            recipe.title = title
        }
        if let timeRequired = recipeInfo["readyInMinutes"] as? Int {
            recipe.timeRequired = timeRequired
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
        
        //["results"][0]["extendedIngredients"][0]["original"]
        
        //["results"][0]["nutrition"]["nutrients"][0]["amount"]
        if let nutritions = recipeInfo["nutrition"] as? [String : Any]{
                if let nutrition = nutritions["nutrients"] as? [[String : Any]] {
                    if let calories = nutrition[0]["amount"] as? Double {
                        recipe.calories = calories
                    }
                    
                    if let carbs = nutrition[3]["amount"] as? Double {
                        recipe.carbs = carbs
                    }
                    
                    if let fat = nutrition[1]["amount"] as? Double {
                        recipe.fat = fat
                    }
                    
                    if let protein = nutrition[8]["amount"] as? Double {
                        recipe.protein = protein
                    }
                    if let sugar = nutrition[5]["amount"] as? Double {
                        recipe.sugar = sugar
                    }
                }
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
    // id'den yeni bir url yaratılarak nutritions değerleri bulunur --> x.recipes[0].id
    // https://api.spoonacular.com/recipes/1003464/nutritionWidget.json?apiKey=af5551aeb300483382684e0f90ad9367
    class func getRecipeNutrition(id: Int, completion: @escaping (Recipe?, Bool, Error?) -> Void){
        var url: URL {
            var components = URLComponents()
            components.host = host
            components.path = "/recipes/\(id)/nutritionWidget.json"
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
} // end of SpoonacularClient


