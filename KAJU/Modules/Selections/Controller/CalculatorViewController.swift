//
//  CalculatorViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 2.02.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CalculatorViewController: UIViewController {
    
    // Outlet Variables
    @IBOutlet weak var genderPicker: UISegmentedControl!
    @IBOutlet weak var weightLabell: UILabel!
    @IBOutlet weak var heightLabell: UILabel!
    @IBOutlet weak var ageLabell: UILabel!
    @IBOutlet weak var topExplanation: UILabel!
    @IBOutlet weak var topTitle: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var ageSlider: UISlider!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    @IBOutlet weak var sexSegment: UISegmentedControl!
    
    // General Variables
    let db = Firestore.firestore()
    var calorieSublabel = ""
    var bmh:Float = 1.2
    var changeCalorieAmount = 0
    var goalType = ""
    var calculatorBrain = CalculatorBrain()
    var sex = "Male".localized()
    var ColorDarkGreen = ThemeColors.ColorGreen.associatedColor
    
    //MARK: - View Lifecycle Functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        defineLabels()
        if !UIDevice.hasNotch{
            nextButtonConstraint.constant = 25
            topConstraint.constant = 15
        }
        ageSlider.value = 25
        heightSlider.value = 1.80
        weightSlider.value = 75
    }
    
    func defineLabels(){
        topTitle.text = topTitle.text?.localized()
        topExplanation.text = topExplanation.text?.localized()
        calculateButton.setTitle(calculateButton.currentTitle?.localized(), for: .normal)
        ageLabell.text = ageLabell.text?.localized()
        heightLabel.text = heightLabel.text?.localized()
        weightLabell.text = weightLabell.text?.localized()
        sexSegment.setTitle(sexSegment.titleForSegment(at: 0)?.localized(), forSegmentAt: 0)
        sexSegment.setTitle(sexSegment.titleForSegment(at: 1)?.localized(), forSegmentAt: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonStyle(button: calculateButton, cornerRadius: 0.096)
        calculateButton.isEnabled = false
        calculateButton.isHighlighted = true
        if changeCalorieAmount == 400 {
            goalType = "Build Muscle".localized()
        } else if changeCalorieAmount == -400 {
            goalType = "Lose Weight".localized()
        }
        else {
            goalType = "Maintain Weight".localized()
        }
    }
    
    //MARK: - IBActions
    @IBAction func sexSegmentPressed(_ sender: UISegmentedControl) {
        if sender.isSelected {
            sex = sender.titleForSegment(at:0)!
            sender.isSelected = false
        } else {
            sex = sender.titleForSegment(at: 1)!
            sender.isSelected = true
        }
        calculateButton.backgroundColor = ColorDarkGreen
        calculateButton.isEnabled = true
        calculateButton.isHighlighted = false
    }
    
    // Text Label updates
    @IBAction func ageSliderChanged(_ sender: UISlider) {
        ageLabel.text = String(format: "%.0f", sender.value)
        calculateButton.backgroundColor = ColorDarkGreen
        calculateButton.isEnabled = true
        calculateButton.isHighlighted = false
    }
    @IBAction func hightSliderChanged(_ sender: UISlider) {
        heightLabel.text = String(format: "%.2f", sender.value) + "m"
        calculateButton.backgroundColor = ColorDarkGreen
        calculateButton.isEnabled = true
        calculateButton.isHighlighted = false
    }
    @IBAction func weightSliderChanged(_ sender: UISlider) {
        weightLabel.text = String(format: "%.1f", sender.value) + "Kg"
        calculateButton.backgroundColor = ColorDarkGreen
        calculateButton.isEnabled = true
        calculateButton.isHighlighted = false
    }
    
    // Calculate Button
    @IBAction func calculatePressed(_ sender: UIButton) {
        
        var age = ageSlider.value //35.69361
        age.round()
        let BMIheight = heightSlider.value // 1.5628742 metre
        var height = BMIheight * 100
        height.round()
        let weight = weightSlider.value //78.791916 kg
        
        calculatorBrain.calculateBMI(BMIheight,weight)
        calculatorBrain.calculateCalorie(sex,weight,height,age,bmh,changeCalorieAmount)
        
        //Verilerin database'e kaydedilmesi
        let calorie = calculatorBrain.getCalorie()
        let calorieFloat = Float(calorie) ?? 0.0
        let calorieInt = Int(calorieFloat)
        if let currentUserEmail = Auth.auth().currentUser?.email {
            db.collection("UserInformations").document("\(currentUserEmail)").setData([
                "UserEmail": currentUserEmail,
                "calorie": calorieInt,
                "sex": sex,
                "weight": weight,
                "height": height,
                "age": age,
                "bmh": bmh,
                "changeCalorieAmount": changeCalorieAmount,
                "goalType": goalType,
                "currentDay": Date().get(.minute, .day, .month, .year).day!,
                "currentCarbs": 0.0,
                "currentPro": 0.0,
                "currentFat": 0.0,
                "currentBreakfastCal": 0,
                "currentLunchCal": 0,
                "currentDinnerCal": 0,
                "currentSnacksCal": 0,
                "weeklyGoal": 0,
                "calorieGoal": 0,
                "adviced": true,
                "goalWeight": 0.0,
                "dietaryType": "Classic"
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
        
    }
    
    //MARK: - Supporting Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "goToResult" {
            // CalculatorResultVC field ve fonksiyonlara erişmek için downcasting
            let destinationVC = segue.destination as! CalculatorResultViewController
            destinationVC.bmiValue = calculatorBrain.getBMIValue()
            destinationVC.advice = calculatorBrain.getAdvice().localized()
            destinationVC.color = calculatorBrain.getColor()
            destinationVC.CalorieSublabelField = calorieSublabel
            destinationVC.calorie = calculatorBrain.getCalorie()
            
        }
    }
    
    //Kenarlardan 10,height 72 constraintsli buttonlar için ideal cornerRadius 0.096
    func setupButtonStyle(button : UIButton,cornerRadius: Float){
        button.layer.cornerRadius = CGFloat(cornerRadius) * button.bounds.size.width
        button.clipsToBounds = true
    }
    
}
