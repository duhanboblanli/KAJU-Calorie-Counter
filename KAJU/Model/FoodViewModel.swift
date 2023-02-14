//
//  FoodViewModel.swift
//  KAJU
//
//  Created by Umut Ulaş Demir on 14.02.2023.
//

import Foundation

class FoodViewModel{
    private var apiService = ApiService()
    private var targetFoods = [Food]() // The list of games
    private let food_app_id = "1587e073"
    private let food_app_key = "602facc0a5347c2e83c1a5932bcb13bc"

    // The API call to get the foods
    func fetchFoodData(completion: @escaping () -> ()) {
        //app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking
        let foodsUrl = "https://api.edamam.com/api/food-database/v2/parser?app_id=" + food_app_id +
        "&app_key=" + food_app_key + "&nutrition-type=cooking"
        // weak self - prevent retain cycles
        print("Fetching food data..")
        apiService.getFoodsData(foodsUrl: foodsUrl) { [weak self] (result) in
            print(result)
            switch result{
            case .success(let listOf):
                self?.targetFoods = listOf.hints
                //self?.Images = Array(repeating: UIImage(named: "background")!, count: listOf.games.count)
                completion()
            case .failure(let error):
                // Something is wrong with the JSON file or the model
                print("Error processing json data: \(error)")
            }
        }
    }

    func clearData(){
        targetFoods.removeAll()
    }

    func getFoods()->[Food]{
        return targetFoods
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
    func cellForRowAt (indexPath: IndexPath) -> Food {
        return targetFoods[indexPath.row]
    }
}




