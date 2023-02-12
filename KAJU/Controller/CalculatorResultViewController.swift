//
//  CalculatorResultViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 2.02.2023.
//

import UIKit
import CLTypingLabel


class CalculatorResultViewController: UIViewController {
    
    
    
    var bmiValue: String?
    var advice: String?
    var color: UIColor?
    var calorie: String?
    var CalorieSublabelField: String?
    
    @IBOutlet weak var bmiLabel: CLTypingLabel!
    @IBOutlet weak var adviceLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var calorieLabel: CLTypingLabel!
    @IBOutlet weak var calorieSublabel: UILabel!
    
    @IBOutlet weak var resultNextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonStyle(button: resultNextButton, cornerRadius: 0.096)
        
        if let bmiValue {
            bmiLabel.text = bmiValue
        }
        if let advice {
            adviceLabel.text = advice
        }
        if let color {
            bmiLabel.textColor = color
        }
        if let CalorieSublabelField {
            calorieSublabel.text = CalorieSublabelField
        }
        if let calorie {
            calorieLabel.text = calorie
        }
        
    }
    
    @IBAction func resultNextButtonPressed(_ sender: UIButton) {
    }
    
    //Kenarlardan 10,height 72 constraintsli buttonlar için ideal cornerRadius 0.096
    func setupButtonStyle(button : UIButton,cornerRadius: Float){
        button.layer.cornerRadius = CGFloat(cornerRadius) * button.bounds.size.width
        button.clipsToBounds = true
    }
    
    
    
    
    
    
    
    
    
    
    
}
