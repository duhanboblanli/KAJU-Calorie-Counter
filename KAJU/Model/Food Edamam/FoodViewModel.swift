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
    // The list of stored foods - list type is FoodApiModel FoodStruct struct
    private var targetFoods1: [FoodStruct] = []
    private let food_app_id = "1587e073"
    private let food_app_key = "602facc0a5347c2e83c1a5932bcb13bc"
    private var nextPageUrl: String = ""
    var frequentFoodsData: [FoodData] = []
    var frequentFoods: [FoodStruct] = []
    var x = 0
    
    var breakfastRequestList =  ["https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=egg","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=milk","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=multigrain%2Cbread","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=honey","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=cheese","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=butter","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=tea","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=olive","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=coffee","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=tomato","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=cucumber","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=pancake","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=bagel","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=pita","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=jam","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=pepperoni","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=pastry","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=roll","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=cashew","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=walnut","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=nuts","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=toast","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=apricot","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=croissant","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=oats","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=granola"]
    
    var lunchRequestList =  ["https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=pizza","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=waffle","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=multigrain%2Cbread","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=chicken","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=noodle","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=rice","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=tea","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=pasta","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=coffee","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=tomato","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=cucumber","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=taco","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=veal","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=pita","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=steak","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=meatball","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=pastry","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=beef","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=cashew","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=walnut","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=nuts","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=cookies","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=apricot","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=croissant","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=avocado"]
    
    var dinnerRequestList =  ["https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=falafel","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=fish","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=multigrain%2Cbread","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=tofu","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=tzatziki","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=rice","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=octopus","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=pasta","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=hummus","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=pea","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=chickpea","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=taco","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=veal","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=pita","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=steak","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=meatball","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=turkey","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=beef","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=soup%2Cmix","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=burrito","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=california%2Croast","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=salmon","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=lamb","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=bean","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=yogurt"]
    
    var snacksRequestList =  ["https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=apple","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=peach","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=banana","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=cherry","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=chocolate","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=nutella","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=blueberry","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=muffin","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=coffee","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=pineapple","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=plum","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=watermelon","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=fig","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=oreo","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=avocado","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=popcorn","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=kiwi","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=cookies","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=grape","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=date","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=nuts","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=almond","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=apricot","https://api.edamam.com/api/food-database/v2/parser?&app_id=1587e073&app_key=602facc0a5347c2e83c1a5932bcb13bc&nutrition-type=cooking&ingr=croissant"]
    
    
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
                    var currentCount = self?.targetFoods1.count
                    var theListWithoutImagelessFoods: [FoodData] = []
                    for (i,food) in listOf.hints.enumerated(){
                        if food.food.image != nil{
                            theListWithoutImagelessFoods.append(food)
                        }
                    }
                    print("yassss", theListWithoutImagelessFoods.count)
                    var url2 = ""
                    self?.nextPageUrl = (listOf._links.next?.href)!
                    //FoodStruct
                    for (i, food) in theListWithoutImagelessFoods.enumerated(){
                        url2 = food.food.image!
                        self!.fetchFoodImage(url: url2,food: food, index: currentCount! + i){ [weak self] in
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
                    
                    var currentCount = self?.targetFoods1.count
                    var theListWithoutImagelessFoods: [FoodData] = []
                    for food in listOf.hints{
                        if food.food.image != nil{
                            theListWithoutImagelessFoods.append(food)
                        }
                    }
                    print("yassss", theListWithoutImagelessFoods.count)
                    var url2 = ""
                    self?.nextPageUrl = (listOf._links.next?.href)!
                    //FoodStruct
                    for (i, food) in theListWithoutImagelessFoods.enumerated(){
                        url2 = food.food.image!
                        self!.fetchFoodImage(url: url2,food: food, index: currentCount! + i){ [weak self] in
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
        func fetchFoodImage(url: String, food: FoodData, index: Int, completion: @escaping () -> ()) {
            
            let foodData = food.food
            let measures = food.measures
            apiService.getImageDataFrom(url: url) { [weak self] (result) in
                print(result)
                switch result{
                case .success(let listOf):
                    //FoodStruct değerlerin atanması
                    self?.targetFoods1.append(FoodStruct(label: foodData.label,calorie: foodData.nutrients?.ENERC_KCAL,image: listOf, carbs: foodData.nutrients?.CHOCDF, fat: foodData.nutrients?.FAT, protein: foodData.nutrients?.PROCNT,wholeGram: measures[0].weight,measureLabel: measures[0].label))
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
                targetFoods1.removeAll()
            }
            
            func getFoods()->[FoodStruct]{
                return targetFoods1
            }
            
            func getNextPage()->String{
                return nextPageUrl
            }
            
            func getCount()->Int{
                return targetFoods1.count
            }

            // Return the number of foods in targetFoods
            func numberOfRowsInSection(section: Int) -> Int {
                if targetFoods1.count != 0 {
                    print("Total foods count: ",targetFoods1.count)
                    return targetFoods1.count
                }
                return 0
            }

            // Return the food at index 'indexPath' of targetFoods
            func cellForRowAt (indexPath: IndexPath) -> FoodStruct {
                return targetFoods1[indexPath.row]
            }
    }
