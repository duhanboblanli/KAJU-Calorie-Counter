//
//  RecipeTableViewCell.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 20.02.2023.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var calorie: UILabel!
    @IBOutlet weak var time: UILabel!
    
    /*override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
    }*/
    
    /*func setCellWithValuesOf(_ recipeData:RecipeStruct) {
        updateUI(label: recipeData.label, calorie: recipeData.calorie, image: recipeData.image, time: recipeData.time)
    }
    
    // Update the UI Views
    private func updateUI(label: String?, calorie: Float?, image: UIImage?, time: Float?) {
        
        self.name.text = label ?? "Label not found!"
        let calorie = String(format: "%.0f", calorie ?? 0.0)
        self.calorie.text = "\(calorie) kcal"
        self.recipeImage.image = image
        let time = String(format: "%.0f", time ?? 0.0)
        self.time.text = "\(time) min"
    } */
    
    // Update the Cell UI Views
    func updateUI(recipe: Recipe, recipeCell: RecipeTableViewCell) {
        
        if let title = recipe.title {
            recipeCell.name.text = title
        }
        if let time = recipe.timeRequired {
            recipeCell.time.text = String("\(time) minutes")
         
        }
        recipeCell.recipeImage.image = UIImage(named: "imagePlaceholder")
        if let imageURL = recipe.imageURL {
            SpoonacularClient.downloadRecipeImage(imageURL: imageURL) { (image, success) in
                recipeCell.recipeImage.image = image
            }
        }
        recipeCell.calorie.text = "0 kcal"
        if let calorie = recipe.calories {
            let calorieString = String(format: "%.0f", calorie)
            recipeCell.calorie.text = "\(calorieString) kcal"
        }
    }
    
    func updateFoodUI(recipe: FoodRecipe, recipeCell: RecipeTableViewCell) {
        
            let title = recipe.title
            recipeCell.name.text = title
        
            let time = recipe.timeRequired
            recipeCell.time.text = String("\(time) minutes")
         
        
        recipeCell.recipeImage.image = UIImage(data: recipe.image!)
       
        
        let calorie = recipe.calories
        recipeCell.calorie.text = "\(calorie) kcal"
        
    }
}

