//
//  CalculatorViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 2.02.2023.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    var calculatorBrain = CalculatorBrain()
    
    @IBOutlet weak var calculateButton: UIButton!
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var ageSlider: UISlider!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonStyle(button: calculateButton, cornerRadius: 0.096)
    }
    
    // Text Label updates
    @IBAction func ageSliderChanged(_ sender: UISlider) {
        ageLabel.text = String(format: "%.0f", sender.value)
    }
    @IBAction func hightSliderChanged(_ sender: UISlider) {
        heightLabel.text = String(format: "%.2f", sender.value) + "m"
    }
    @IBAction func weightSliderChanged(_ sender: UISlider) {
        weightLabel.text = String(format: "%.1f", sender.value) + "Kg"
    }
    
    // Calculate Button
    @IBAction func calculatePressed(_ sender: UIButton) {
        let height = heightSlider.value
        let weight = weightSlider.value
        
        calculatorBrain.calculateBMI(height,weight)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "goToResult" {
            // CalculatorResultVC field ve fonksiyonlara erişmek için downcasting
            let destinationVC = segue.destination as! CalculatorResultViewController
            destinationVC.bmiValue = calculatorBrain.getBMIValue()
            destinationVC.advice = calculatorBrain.getAdvice()
            destinationVC.color = calculatorBrain.getColor()
        }
        
        
        
    }

    //Kenarlardan 10,height 72 constraintsli buttonlar için ideal cornerRadius 0.096
    func setupButtonStyle(button : UIButton,cornerRadius: Float){
        button.layer.cornerRadius = CGFloat(cornerRadius) * button.bounds.size.width
        button.clipsToBounds = true
    }
    
    
    
    
    
    
    
    
    
    
}
