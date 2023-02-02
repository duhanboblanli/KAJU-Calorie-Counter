//
//  CalculatorViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 2.02.2023.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var ageSlider: UISlider!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    
    var bmiString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let bmi = weight / pow(height,2)
        bmiString = String(format: "%.1f", bmi)
        
        //Storyboard buttondan zaten bağlantılı
        //self.performSegue(withIdentifier: "goToResult", sender: self)
  
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "goToResult" {
            // CalculatorResultVC field ve fonksiyonlara erişmek için downcasting
            let destinationVC = segue.destination as! CalculatorResultViewController
            destinationVC.bmiValue = bmiString
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
