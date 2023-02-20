//
//  RecipeTableViewCell.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 19.02.2023.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var calorie: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
    }
    
    func setCellWithValuesOf(_ recipeData:RecipeStruct) {
        updateUI(label: recipeData.label, calorie: recipeData.calorie, image: recipeData.image, time: recipeData.time)
    }
    
    // Update the UI Views
    private func updateUI(label: String?, calorie: Float?, image: UIImage?, time: Float?) {
        
        self.name.text = label ?? "Label not found!"
        print("LABELLLLL:", label ?? "Label not found!")
        print("LABELLLLL:", label ?? "Label not found!")

        print("LABELLLLL:", label ?? "Label not found!")

        print("LABELLLLL:", label ?? "Label not found!")

        print("LABELLLLL:", label!)

        print("LABELLLLL:", label!)

        print("LABELLLLL:", label!)

        print("LABELLLLL:", label!)

        
        let calorie = String(format: "%.0f", calorie ?? 0.0)
        self.calorie.text = "\(calorie) kcal"
        self.recipeImage.image = image
        let time = String(format: "%.0f", time ?? 0.0)
        self.time.text = "\(time) min"
    }

}

