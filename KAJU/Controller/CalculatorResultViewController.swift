//
//  CalculatorResultViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 2.02.2023.
//

import UIKit

class CalculatorResultViewController: UIViewController {
    
    var bmiValue: String?
    var advice: String?
    var color: UIColor?
    
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let bmiValue {
            bmiLabel.text = bmiValue
        }
        if let advice {
            adviceLabel.text = advice
        }
        if let color {
            bmiLabel.textColor = color
            adviceLabel.textColor = color
            resultLabel.textColor = color
        }
        
    }
    
    @IBAction func recalculatePressed(_ sender: UIButton) {
        // Back to the previous view controller
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
}
