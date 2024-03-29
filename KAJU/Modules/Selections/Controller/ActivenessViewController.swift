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
    @IBOutlet weak var topExplanation: UILabel!
    @IBOutlet weak var topTitle: UILabel!
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
    var ColorSelected = ThemeColors.colorLightGreen.associatedColor.withAlphaComponent(0.3)

    //MARK: - View Lifecycle Functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        defineLabels()
        if !UIDevice.hasNotch{
            nextButtonConstraint.constant = -25
            topConstraint.constant = 15
            middleConstraint.constant = 35
            downMiddleConstraint.constant = 35
        }
    }
    func defineLabels(){
        topTitle.text = topTitle.text?.localized()
        topExplanation.text = topExplanation.text?.localized()
        activenessNextButton.setTitle(activenessNextButton.currentTitle?.localized(), for: .normal)
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
        lightlyActiveButton.setTitle("🧑‍💻 Lightly active".localized(), for: UIControl.State())
        if #available(iOS 15.0, *) {
            lightlyActiveButton.configuration?.subtitle =
            lightlyActiveButton.configuration?.subtitle?.localized()
        } else {
            // Fallback on earlier versions
        }
        moderatelyActiveButton.setTitle("🧑‍🏫 Moderately active".localized(), for: UIControl.State())
        if #available(iOS 15.0, *) {
            moderatelyActiveButton.configuration?.subtitle =
            moderatelyActiveButton.configuration?.subtitle?.localized()
        } else {
            // Fallback on earlier versions
        }
        activeButton.setTitle("🧑‍💼 Active".localized(), for: UIControl.State())
        if #available(iOS 15.0, *) {
            activeButton.configuration?.subtitle =
            activeButton.configuration?.subtitle?.localized()
        } else {
            // Fallback on earlier versions
        }
        veryActiveButton.setTitle("👷 Very active".localized(), for: UIControl.State())
        if #available(iOS 15.0, *) {
            veryActiveButton.configuration?.subtitle =
            veryActiveButton.configuration?.subtitle?.localized()
        } else {
            // Fallback on earlier versions
        }
    }
    
    //MARK: - IBActions
    @IBAction func lightlyActivePressed(_ sender: UIButton) {
        bmh = 1.2
        lightlyActiveButton.backgroundColor = ColorSelected
        moderatelyActiveButton.backgroundColor = ThemeColors.colorDarkGreen.associatedColor
        activeButton.backgroundColor = ThemeColors.colorDarkGreen.associatedColor
        veryActiveButton.backgroundColor = ThemeColors.colorDarkGreen.associatedColor
        activenessNextButton.isEnabled = true
        activenessNextButton.isHighlighted = false
        activenessNextButton.backgroundColor = ThemeColors.colorGreen.associatedColor
    }
    
    @IBAction func moderatelyActivePressed(_ sender: UIButton) {
        bmh = 1.3
        lightlyActiveButton.backgroundColor = ThemeColors.colorDarkGreen.associatedColor
        moderatelyActiveButton.backgroundColor = ColorSelected
        activeButton.backgroundColor = ThemeColors.colorDarkGreen.associatedColor
        veryActiveButton.backgroundColor = ThemeColors.colorDarkGreen.associatedColor
        activenessNextButton.isEnabled = true
        activenessNextButton.isHighlighted = false
        activenessNextButton.backgroundColor = ThemeColors.colorGreen.associatedColor
    }
    
    @IBAction func activePressed(_ sender: UIButton) {
        bmh = 1.4
        lightlyActiveButton.backgroundColor = ThemeColors.colorDarkGreen.associatedColor
        moderatelyActiveButton.backgroundColor = ThemeColors.colorDarkGreen.associatedColor
        activeButton.backgroundColor = ColorSelected
        veryActiveButton.backgroundColor = ThemeColors.colorDarkGreen.associatedColor
        activenessNextButton.isEnabled = true
        activenessNextButton.isHighlighted = false
        activenessNextButton.backgroundColor = ThemeColors.colorGreen.associatedColor
    }
    
    @IBAction func veryActivePressed(_ sender: Any) {
        bmh = 1.5
        lightlyActiveButton.backgroundColor = ThemeColors.colorDarkGreen.associatedColor
        moderatelyActiveButton.backgroundColor = ThemeColors.colorDarkGreen.associatedColor
        activeButton.backgroundColor = ThemeColors.colorDarkGreen.associatedColor
        veryActiveButton.backgroundColor = ColorSelected
        activenessNextButton.isEnabled = true
        activenessNextButton.isHighlighted = false
        activenessNextButton.backgroundColor = ThemeColors.colorGreen.associatedColor
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

