//
//  ActivenessViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 10.02.2023.
//

import UIKit

class ActivenessViewController: UIViewController {
    
    //Masa başı ve durağan bir yaşamınız varsa, BMH’nızı 1.2 ile çarpın.
    //Hafif düzeyde hareketliyseniz, BMH’nızı 1.3 ile çarpın.
    //Orta düzeyde hareketli olup çok oturmuyorsanız, BMH’nızı 1.4 ile çarpın.
    //Yüksek düzeyde aktifseniz ve düzenli spor yapıyorsanız, BMH’ınızı 1.5 ile çarpın.
    
    var changeCalorieAmount = 0
    var calorieSublabel = ""
    var bmh:Float = 0.0
    var ColorDarkGreen = UIColor( red: 47/255, green: 136/255, blue: 134/255, alpha: 1)
    
    @IBOutlet weak var lightlyActiveButton: UIButton!
    @IBOutlet weak var moderatelyActiveButton: UIButton!
    @IBOutlet weak var activeButton: UIButton!
    @IBOutlet weak var veryActiveButton: UIButton!
    @IBOutlet weak var activenessNextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonStyle(button: activenessNextButton, cornerRadius: 0.046)
        activenessNextButton.isEnabled = false
        activenessNextButton.isHighlighted = true
        //Height 82, soft kare görünüm
        setupButtonStyle(button: lightlyActiveButton, cornerRadius: 0.04)
        setupButtonStyle(button: moderatelyActiveButton, cornerRadius: 0.04)
        setupButtonStyle(button: activeButton, cornerRadius: 0.04)
        setupButtonStyle(button: veryActiveButton, cornerRadius: 0.04)
        lightlyActiveButton.setTitle("🧑‍💻 Lightly active", for: UIControl.State())
        moderatelyActiveButton.setTitle("🧑‍🏫 Moderately active", for: UIControl.State())
        activeButton.setTitle("🧑‍💼 Active", for: UIControl.State())
        veryActiveButton.setTitle("👷 Very active", for: UIControl.State())
        
    }
    
    
    @IBAction func lightlyActivePressed(_ sender: UIButton) {
        bmh = 1.2
        lightlyActiveButton.isSelected = true
        moderatelyActiveButton.isSelected = false
        activeButton.isSelected = false
        veryActiveButton.isSelected = false
        activenessNextButton.isEnabled = true
        activenessNextButton.isHighlighted = false
        activenessNextButton.backgroundColor = ColorDarkGreen
    }
    
    @IBAction func moderatelyActivePressed(_ sender: UIButton) {
        bmh = 1.3
        moderatelyActiveButton.isSelected = true
        lightlyActiveButton.isSelected = false
        activeButton.isSelected = false
        veryActiveButton.isSelected = false
        activenessNextButton.isEnabled = true
        activenessNextButton.isHighlighted = false
        activenessNextButton.backgroundColor = ColorDarkGreen
    }
    
    @IBAction func activePressed(_ sender: UIButton) {
        bmh = 1.4
        activeButton.isSelected = true
        moderatelyActiveButton.isSelected = false
        lightlyActiveButton.isSelected = false
        veryActiveButton.isSelected = false
        activenessNextButton.isEnabled = true
        activenessNextButton.isHighlighted = false
        activenessNextButton.backgroundColor = ColorDarkGreen
    }
    
    @IBAction func veryActivePressed(_ sender: Any) {
        bmh = 1.5
        veryActiveButton.isSelected = true
        moderatelyActiveButton.isSelected = false
        activeButton.isSelected = false
        lightlyActiveButton.isSelected = false
        activenessNextButton.isEnabled = true
        activenessNextButton.isHighlighted = false
        activenessNextButton.backgroundColor = ColorDarkGreen
    }
    
    //Kenarlardan 10,height 72 constraintsli buttonlar için ideal cornerRadius 0.096
    func setupButtonStyle(button : UIButton,cornerRadius: Float){
        button.layer.cornerRadius = CGFloat(cornerRadius) * button.bounds.size.width
        button.clipsToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "goToCalculator" {
            let destinationVC = segue.destination as! CalculatorViewController
            destinationVC.bmh = bmh
            destinationVC.changeCalorieAmount = changeCalorieAmount
            destinationVC.calorieSublabel = calorieSublabel
        }
    }
    
    
}

