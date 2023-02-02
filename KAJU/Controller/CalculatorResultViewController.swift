//
//  CalculatorResultViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 2.02.2023.
//

import UIKit

class CalculatorResultViewController: UIViewController {
    
    var bmiValue: String?
    
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let bmiValue {
            bmiLabel.text = bmiValue
        }
        
    }
    
    @IBAction func recalculatePressed(_ sender: UIButton) {
        
        // Back to the previous view controller
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
}
