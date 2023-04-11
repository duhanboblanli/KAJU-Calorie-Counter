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
    
    // Update the Cell UI Views
    func updateUI(recipe: Recipe, recipeCell: RecipeTableViewCell) {
        
        if let title = recipe.title {
            recipeCell.name.text = title
        }
        if let time = recipe.timeRequired {
            recipeCell.time.text = String("\(time) minutes")
            
        }
        recipeCell.recipeImage.image = Images.Placeholder.associatedImage
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

