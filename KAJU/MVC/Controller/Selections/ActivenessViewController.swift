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
    
    // Outlet Variables
    @IBOutlet weak var downMiddleConstraint: NSLayoutConstraint!
    @IBOutlet weak var middleConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var lightlyActiveButton: UIButton!
    @IBOutlet weak var moderatelyActiveButton: UIButton!
    @IBOutlet weak var activeButton: UIButton!
    @IBOutlet weak var veryActiveButton: UIButton!
    @IBOutlet weak var activenessNextButton: UIButton!
    
    // General Variables
    var changeCalorieAmount = 0
    var calorieSublabel = ""
    var bmh:Float = 0.0
    var ColorSelected = ThemeColors.ColorLightGreen.associatedColor.withAlphaComponent(0.3)

    //MARK: - View Lifecycle Functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !UIDevice.hasNotch{
            nextButtonConstraint.constant = -25
            topConstraint.constant = 15
            middleConstraint.constant = 35
            downMiddleConstraint.constant = 35
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonStyle(button: activenessNextButton, cornerRadius: 0.096)
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
    
    //MARK: - IBActions
    @IBAction func lightlyActivePressed(_ sender: UIButton) {
        bmh = 1.2
        lightlyActiveButton.backgroundColor = ColorSelected
        moderatelyActiveButton.backgroundColor = ThemeColors.ColorDarkGreen.associatedColor
        activeButton.backgroundColor = ThemeColors.ColorDarkGreen.associatedColor
        veryActiveButton.backgroundColor = ThemeColors.ColorDarkGreen.associatedColor
        activenessNextButton.isEnabled = true
        activenessNextButton.isHighlighted = false
        activenessNextButton.backgroundColor = ThemeColors.ColorGreen.associatedColor
    }
    
    @IBAction func moderatelyActivePressed(_ sender: UIButton) {
        bmh = 1.3
        lightlyActiveButton.backgroundColor = ThemeColors.ColorDarkGreen.associatedColor
        moderatelyActiveButton.backgroundColor = ColorSelected
        activeButton.backgroundColor = ThemeColors.ColorDarkGreen.associatedColor
        veryActiveButton.backgroundColor = ThemeColors.ColorDarkGreen.associatedColor
        activenessNextButton.isEnabled = true
        activenessNextButton.isHighlighted = false
        activenessNextButton.backgroundColor = ThemeColors.ColorGreen.associatedColor
    }
    
    @IBAction func activePressed(_ sender: UIButton) {
        bmh = 1.4
        lightlyActiveButton.backgroundColor = ThemeColors.ColorDarkGreen.associatedColor
        moderatelyActiveButton.backgroundColor = ThemeColors.ColorDarkGreen.associatedColor
        activeButton.backgroundColor = ColorSelected
        veryActiveButton.backgroundColor = ThemeColors.ColorDarkGreen.associatedColor
        activenessNextButton.isEnabled = true
        activenessNextButton.isHighlighted = false
        activenessNextButton.backgroundColor = ThemeColors.ColorGreen.associatedColor
    }
    
    @IBAction func veryActivePressed(_ sender: Any) {
        bmh = 1.5
        lightlyActiveButton.backgroundColor = ThemeColors.ColorDarkGreen.associatedColor
        moderatelyActiveButton.backgroundColor = ThemeColors.ColorDarkGreen.associatedColor
        activeButton.backgroundColor = ThemeColors.ColorDarkGreen.associatedColor
        veryActiveButton.backgroundColor = ColorSelected
        activenessNextButton.isEnabled = true
        activenessNextButton.isHighlighted = false
        activenessNextButton.backgroundColor = ThemeColors.ColorGreen.associatedColor
    }

    //MARK: - Supporting Functions
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

