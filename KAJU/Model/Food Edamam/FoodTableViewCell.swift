//
//  FoodTableViewCell.swift
//  KAJU
//
//  Created by Umut Ulaş Demir on 15.02.2023.
//

import UIKit

class FoodTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var calorie: UILabel!
    @IBOutlet weak var name: UILabel!
    
    /*override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }*/
    
    func setCellWithValuesOf(_ foodData:FoodStruct) {
        updateUI(label: foodData.label, calorie: foodData.calorie, image: foodData.image)
    }
    
    // Update the UI Views
    private func updateUI(label: String?, calorie: Float?, image: UIImage?) {
        self.name.text = label
        let calorieNoDecimal = Int(calorie ?? 0.0)
        self.calorie.text = (calorieNoDecimal.description) + " kcal"
        self.foodImage.image = image
    }

}
