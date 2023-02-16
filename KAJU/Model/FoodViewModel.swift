//
//  FoodViewModel.swift
//  KAJU
//
//  Created by Umut Ulaş Demir on 14.02.2023.
//

import Foundation
import UIKit

class FoodViewModel{
    var apiService = ApiService()
    private var targetFoods = [FoodData]() // The list of games
    private var targetFoods1 = [FoodStruct]() // The list of games
    private let food_app_id = "1587e073"
    private let food_app_key = "602facc0a5347c2e83c1a5932bcb13bc"
    private var nextPageUrl: String = ""

    // The API call to get the foods
    func fetchFoodData(pagination: Bool, completion: @escaping () -> ()) {
        //app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking
        var foodsUrl: String?
        
        if pagination == false{
            foodsUrl = "https://api.edamam.com/api/food-database/v2/parser?app_id=" + food_app_id +
            "&app_key=" + food_app_key + "&nutrition-type=cooking"
        }
        else{
            foodsUrl = nextPageUrl
        }
        // weak self - prevent retain cycles
        print("Fetching food data.. : ", foodsUrl)
        apiService.getFoodsData(pagination: pagination, foodsUrl: foodsUrl!) { [weak self] (result) in
            print(result)
            switch result{
            case .success(let listOf):
                var currentCount = self?.targetFoods.count
                var url2 = ""
                self?.targetFoods.append(contentsOf: listOf.hints)
                self?.nextPageUrl = (listOf._links.next?.href)!
                self?.targetFoods1 = self!.targetFoods1 + Array(repeating: FoodStruct(label: "", calorie: 0.0, image: UIImage(named: "Egg-Breakfast-PNG-Download-Image")), count: listOf.hints.count)
                for (i, food) in listOf.hints.enumerated(){
                    if food.food.image == nil{
                        url2 = "https://www.edamam.com/food-img/541/541e46e44ba61aec8bcd599df94c0eed.jpg"
                    }
                    else {
                        url2 = food.food.image!
                    }
                    self!.fetchFoodImage(url: url2, index: currentCount! + i){ [weak self] in
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
    // The API call to get the foods images
    func fetchFoodImage(url: String, index: Int, completion: @escaping () -> ()) {
        
        let food = self.targetFoods[index].food
        
        print("Fetching image.. ", url)
        apiService.getImageDataFrom(url: url) { [weak self] (result) in
            print(result)
            switch result{
            case .success(let listOf):
                print("Fetching image.. !!!!!!!!!!!")
                self?.targetFoods1[index] = FoodStruct(label: food.label,
                                                  calorie: food.nutrients?.ENERC_KCAL,image: listOf)
                //self?.targetFoods1.append(contentsOf: FoodStruct(label: food.label,
                  //                                              calorie: food.nutrients?.ENERC_KCAL,image: listOf))
            case .failure(let error):
                // Something is wrong with the JSON file or the model
                print("Error processing json data: \(error)")
            }
        }
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
            print("total games count: ",targetFoods.count)
            return targetFoods.count
        }
        return 0
    }

    // Return the game at index 'indexPath' of targetFoods
    func cellForRowAt (indexPath: IndexPath) -> FoodStruct {
        return targetFoods1[indexPath.row]
    }
}




