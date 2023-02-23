//
//  FavoritesCell.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 23.02.2023.
//

import UIKit

class FavoritesCell: UITableViewCell {
    
    
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var calorie: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var swipe: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        swipe.layer.cornerRadius = swipe.frame.size.height/4
        swipe.layer.masksToBounds = true
        swipe.layer.borderWidth = 0.9
    }
    
    func updateFoodUI(recipe: FoodRecipe, recipeCell: FavoritesCell) {
        
            let title = recipe.title
            recipeCell.name.text = title
        
            let time = recipe.timeRequired
            recipeCell.time.text = String("\(time) minutes")
         
        if let imageData = recipe.image {
            recipeCell.recipeImage.image = UIImage(data: imageData) }
       
        
        let calorie = recipe.calories
        recipeCell.calorie.text = "\(calorie) kcal"
        
    }
}


