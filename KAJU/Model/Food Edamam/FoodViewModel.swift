//
//  FoodViewModel.swift
//  KAJU
//
//  Created by Umut Ulaş Demir on 14.02.2023.
//

import Foundation
import UIKit

protocol UpdateDelegate {
    func didUpdate(sender: FoodViewModel)
}

class FoodViewModel {
    var delegate: UpdateDelegate?
    var apiService = FoodApiService()
    // The list of fetch foods - list type is FoodApiModel FoodData struct
    private var targetFoods = [FoodData]()
    // The list of stored foods - list type is FoodApiModel FoodStruct struct
    private var targetFoods1 = [FoodStruct]()
    private let food_app_id = "1587e073"
    private let food_app_key = "602facc0a5347c2e83c1a5932bcb13bc"
    private var nextPageUrl: String = ""
    var frequentFoodsData: [FoodData] = []
    var frequentFoods: [FoodStruct] = []
    var x = 0
    
    var breakfastRequestList =  ["https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=1%2Cmilk","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=1%2Cegg","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=1%2Ctoast","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=1%bread"]
    var lunchRequestList =  ["https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=1%2Cpizza","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=1%2Cpizza","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=1%2Ctoast","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=1%bread"]
    var dinnerRequestList =  ["https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=1%2Cmilk","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=1%2Cegg","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=1%2Cpizza","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=1%bread"]
    var snacksRequestList =  ["https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=1%2Cmilk","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=1%2Cegg","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=1%2Ctoast","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=1%bread"]
    
    
    //Full URL
    //https://api.edamam.com/api/food-database/v2/parser?app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking
    //https://api.edamam.com/api/food-database/v2/parser?app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&foodId=food_ax6ocbjas0levpb3nl0n7auzwy0i
    
    
    // https://api.edamam.com/api/food-database/v2/parser?app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&foodId=food_ax6ocbjas0levpb3nl0n7auzwy0i
    // Search URL     "1,banana"   "&ingr=3%2Cegg"
    // https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=1%2Cmilk
    // The API call to get the foods
    func fetchOneDefaultFood(){
        
    }
    // 0: breakfast, 1: lunch, 2: dinner, 3: snacks
    func fetchDefaultFoodData(mealType: Int,completion: @escaping () -> ()) {
        var reqList: [String]
        switch mealType{
            case 0: reqList = breakfastRequestList
            case 1: reqList = lunchRequestList
            case 2: reqList = dinnerRequestList
            case 3: reqList = snacksRequestList
        default:
            reqList = breakfastRequestList
        }
        for (i,req) in reqList.enumerated(){
            //app_id=1587e073   &app_key=602facc0a5347c2e83c1a5932bcb13bc     &nutrition-type=cooking(default)
            let foodsUrl = req
            // weak self - prevent retain cycles
            print("Fetching food data.. : ", foodsUrl ?? "ERROR: URL Not Found! (FoodViewModel.swift)")
            apiService.getFoodsData2(foodsUrl: foodsUrl) { [weak self] (result) in
                print("apiService.getFoodsData:")
                print(result)
                switch result{
                case .success(let listOf):
                    print("brekfestrjhjhjhjhjhjhjhhj")
                    self!.fetchFoodImage2(url: listOf.hints[0].food.image!,food: listOf.hints[0].food , measure: listOf.hints[0].measures[0], index: i){ [weak self] in
                        //self?.Images = Array(repeating: UIImage(named: "background")!, count: listOf.games.count)
                    }
                case .failure(_):
                    // Something is wrong with the JSON file or the model
                    print("Error processing json data:")
                }
            }
        }
        completion()
    }
        // The API call to get the foods
        func fetchFoodData(pagination: Bool, completion: @escaping () -> ()) {
            //app_id=1587e073   &app_key=602facc0a5347c2e83c1a5932bcb13bc     &nutrition-type=cooking(default)
            var foodsUrl: String?
            
            if pagination == false{
                foodsUrl = "https://api.edamam.com/api/food-database/v2/parser?app_id=" + food_app_id +
                "&app_key=" + food_app_key + "&ingr=egg" // &ingr=3%2Cfish%2Cfry"
            }
            else{
                foodsUrl = nextPageUrl
            }
            // weak self - prevent retain cycles
            print("Fetching food data.. : ", foodsUrl ?? "ERROR: URL Not Found! (FoodViewModel.swift)")
            apiService.getFoodsData(pagination: pagination, foodsUrl: foodsUrl!) { [weak self] (result) in
                print("apiService.getFoodsData:")
                print(result)
                switch result{
                case .success(let listOf):
                    
                    let currentCount = self?.targetFoods.count
                    var url2 = ""
                    self?.targetFoods.append(contentsOf: listOf.hints)
                    self?.nextPageUrl = (listOf._links.next?.href)!
                    // FoodStruct
                    self?.targetFoods1 = self!.targetFoods1 + Array(repeating: FoodStruct(label: "", calorie: 0.0, image: UIImage(named: "imagePlaceholder"), carbs: 0.0, fat: 0.0, protein: 0.0,wholeGram: 0.0,measureLabel: ""), count: listOf.hints.count)
                    for (i, food) in listOf.hints.enumerated(){
                        if food.food.image == nil{
                            url2 = "https://www.edamam.com/food-img/541/541e46e44ba61aec8bcd599df94c0eed.jpg"
                        }
                        else {
                            url2 = food.food.image!
                        }
                        self!.fetchFoodImage(url: url2, index: currentCount! + i){ [weak self] in
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
        
        // The API call to get the foods
        func fetchSearchedFoodData(searchQuery:String, pagination: Bool, completion: @escaping () -> ()) {
            //app_id=1587e073   &app_key=602facc0a5347c2e83c1a5932bcb13bc     &nutrition-type=cooking(default)
            var foodsUrl: String?
            
            if pagination == false{
                foodsUrl = "https://api.edamam.com/api/food-database/v2/parser?app_id=" + food_app_id +
                "&app_key=" + food_app_key + "&ingr=\(searchQuery)" // &ingr=3%2Cfish%2Cfry"
            }
            else{
                foodsUrl = nextPageUrl
            }
            // weak self - prevent retain cycles
            print("Fetching food data.. : ", foodsUrl ?? "ERROR: URL Not Found! (FoodViewModel.swift)")
            apiService.getFoodsData(pagination: pagination, foodsUrl: foodsUrl!) { [weak self] (result) in
                print("apiService.getFoodsData:")
                print(result)
                switch result{
                case .success(let listOf):
                    
                    let currentCount = self?.targetFoods.count
                    var url2 = ""
                    self?.targetFoods.append(contentsOf: listOf.hints)
                    self?.nextPageUrl = (listOf._links.next?.href)!
                    //FoodStruct
                    self?.targetFoods1 = self!.targetFoods1 + Array(repeating: FoodStruct(label: "", calorie: 0.0, image: UIImage(named: "imagePlaceholder"), carbs: 0.0, fat: 0.0, protein: 0.0,wholeGram: 0.0,measureLabel: ""), count: listOf.hints.count)
                    for (i, food) in listOf.hints.enumerated(){
                        print("UUUUUUUU", i)
                        if food.food.image == nil{
                            url2 = "https://www.edamam.com/food-img/541/541e46e44ba61aec8bcd599df94c0eed.jpg"
                        }
                        else {
                            url2 = food.food.image!
                        }
                        self!.fetchFoodImage(url: url2, index: currentCount! + i){ [weak self] in
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
        
        // The API call to get the foods images
        func fetchFoodImage(url: String, index: Int, completion: @escaping () -> ()) {
            
            let food = self.targetFoods[index].food
            let measures = self.targetFoods[index].measures
            apiService.getImageDataFrom(url: url) { [weak self] (result) in
                print(result)
                switch result{
                case .success(let listOf):
                    //FoodStruct değerlerin atanması
                    self?.targetFoods1[index] = FoodStruct(label: food.label,calorie: food.nutrients?.ENERC_KCAL,image: listOf, carbs: food.nutrients?.CHOCDF, fat: food.nutrients?.FAT, protein: food.nutrients?.PROCNT,wholeGram: measures[0].weight,measureLabel: measures[0].label)
                    self?.delegate!.didUpdate(sender: self!)
                    //self?.targetFoods1.append(contentsOf: FoodStruct(label: food.label,
                    //                                              calorie: food.nutrients?.ENERC_KCAL,image: listOf))
                case .failure(let error):
                    // Something is wrong with the JSON file or the model
                    print("Error processing json data: \(error)")
                }
            }
        }
    // The API call to get the foods images
    func fetchFoodImage2(url: String,food: Food,measure: Measure, index: Int, completion: @escaping () -> ()) {
        
        apiService.getImageDataFrom(url: url) { [weak self] (result) in
            print(result)
            switch result{
            case .success(let listOf):
                //FoodStruct değerlerin atanması
                self?.frequentFoods.append(FoodStruct(label: food.label,calorie: food.nutrients?.ENERC_KCAL,image: listOf, carbs: food.nutrients?.CHOCDF, fat: food.nutrients?.FAT, protein: food.nutrients?.PROCNT,wholeGram: measure.weight,measureLabel: measure.label
                                                            ))
                self?.delegate!.didUpdate(sender: self!)
                //self?.targetFoods1.append(contentsOf: FoodStruct(label: food.label,
                //                                              calorie: food.nutrients?.ENERC_KCAL,image: listOf))
            case .failure(let error):
                // Something is wrong with the JSON file or the model
                print("Error processing json data: \(error)")
            }
        }
    }
        
        
        func autoCompleteFoodSearch(searchQuery: String, completion: @escaping ([String], Error?) -> Void) -> URLSessionTask {
                var searchURL: URL {
                    var components = URLComponents()
                    components.host = "api.edamam.com"
                    components.path = "/auto-complete"
                    components.scheme = "https"
                    
                    components.queryItems = [URLQueryItem]()
                    components.queryItems?.append(URLQueryItem(name: "app_id", value: "1587e073"))
                    components.queryItems?.append(URLQueryItem(name: "app_key", value: "602facc0a5347c2e83c1a5932bcb13bc"))
                    components.queryItems?.append(URLQueryItem(name: "q", value: searchQuery))
                    print("autoCompleteURL", components.url!)
                    return components.url!
                }
                let task = URLSession.shared.dataTask(with: searchURL) { (data, response, error) in
                    guard let data = data else {
                        completion([], error)
                        return
                    }
                    do {
                        let responseObject = try JSONDecoder().decode([String].self, from: data)
                        completion(responseObject, nil)
                    } catch {
                        completion([], error)
                    }
                }
                return task
            }

            func clearData(){
                targetFoods.removeAll()
            }
            
            func getFoods()->[FoodData]{
                return targetFoods
            }
            
            func getNextPage()->String{
                return nextPageUrl
            }
            
            func getCount()->Int{
                return targetFoods.count
            }

            // Return the number of foods in targetFoods
            func numberOfRowsInSection(section: Int) -> Int {
                if targetFoods.count != 0 {
                    print("Total foods count: ",targetFoods.count)
                    return targetFoods.count
                }
                return 0
            }

            // Return the food at index 'indexPath' of targetFoods
            func cellForRowAt (indexPath: IndexPath) -> FoodStruct {
                return targetFoods1[indexPath.row]
            }
    }
