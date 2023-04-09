//
//  GoalViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 9.02.2023.
//

import UIKit
import FirebaseAuth

class GoalViewController: UIViewController{
    
    // Outlet Variables
    @IBOutlet weak var downMiddleConstraint: NSLayoutConstraint!
    @IBOutlet weak var middleConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var goalNextButton: UIButton!
    @IBOutlet weak var loseWeightButton: UIButton!
    @IBOutlet weak var protectWeightButton: UIButton!
    @IBOutlet weak var gainMuscleButton: UIButton!
    
    // General Variables
    var changeCalorieAmount = 0
    var calorieSublabel = "According to your choices, your goal is to maintain your weight."
    var check = false
    var user = Auth.auth().currentUser
    var ColorSelected = ThemeColors.ColorLightGreen.associatedColor.withAlphaComponent(0.3)
    
    
    //MARK: - View Lifecycle Functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !UIDevice.hasNotch{
            nextButtonConstraint.constant = -25
            topConstraint.constant = 15
            middleConstraint.constant = 60
            downMiddleConstraint.constant = 60
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if check{
            let alert = UIAlertController(title: "Your registration has been suspended!", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        self.navigationItem.setHidesBackButton(false, animated: false)
        setupButtonStyle(button: goalNextButton, cornerRadius: 0.096)
        goalNextButton.isEnabled = false
        goalNextButton.isHighlighted = true
        //Height 82, soft kare görünüm
        setupButtonStyle(button: loseWeightButton, cornerRadius: 0.04)
        setupButtonStyle(button: protectWeightButton, cornerRadius: 0.04)
        setupButtonStyle(button: gainMuscleButton, cornerRadius: 0.04)
        loseWeightButton.setTitle("🍏 Lose Weight", for: UIControl.State())
        protectWeightButton.setTitle("🧘 Maintain Weight", for: UIControl.State())
        gainMuscleButton.setTitle("💪 Gain Muscle", for: UIControl.State())
        navigationItem.hidesBackButton = true
    }
    
    //MARK: - IBActions
    @IBAction func loseWeightPressed(_ sender: UIButton) {
        changeCalorieAmount = -400
        calorieSublabel = "According to your choices, your goal is to lose your weight."
        protectWeightButton.backgroundColor = ThemeColors.ColorDarkGreen.associatedColor
        gainMuscleButton.backgroundColor = ThemeColors.ColorDarkGreen.associatedColor
        loseWeightButton.backgroundColor = ColorSelected
        goalNextButton.isEnabled = true
        goalNextButton.isHighlighted = false
        goalNextButton.backgroundColor = ThemeColors.ColorGreen.associatedColor
    }
    @IBAction func protectWeightPressed(_ sender: UIButton) {
        
        changeCalorieAmount = 0
        calorieSublabel = "According to your choices, your goal is to maintain your weight."
        protectWeightButton.backgroundColor = ColorSelected
        gainMuscleButton.backgroundColor = ThemeColors.ColorDarkGreen.associatedColor
        loseWeightButton.backgroundColor = ThemeColors.ColorDarkGreen.associatedColor
        goalNextButton.isEnabled = true
        goalNextButton.isHighlighted = false
        goalNextButton.backgroundColor = ThemeColors.ColorGreen.associatedColor
    }
    @IBAction func gainMusclePressed(_ sender: UIButton) {
        changeCalorieAmount = 400
        calorieSublabel = "According to your choices, your goal is to gain muscle."
        protectWeightButton.backgroundColor = ThemeColors.ColorDarkGreen.associatedColor
        gainMuscleButton.backgroundColor = ColorSelected
        loseWeightButton.backgroundColor = ThemeColors.ColorDarkGreen.associatedColor
        goalNextButton.isEnabled = true
        goalNextButton.isHighlighted = false
        goalNextButton.backgroundColor = ThemeColors.ColorGreen.associatedColor
    }
    
    //MARK: - Supporting Functions
    func animate(){
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.endProgress = 0.5
        transition.fillMode = CAMediaTimingFillMode.backwards
        navigationController?.view.layer.add(transition, forKey: nil)
    }
    
    //Kenarlardan 10,height 72 constraintsli buttonlar için ideal cornerRadius 0.096
    func setupButtonStyle(button : UIButton,cornerRadius: Float){
        button.layer.cornerRadius = CGFloat(cornerRadius) * button.bounds.size.width
        button.clipsToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "goToActivenes" {
            let destinationVC = segue.destination as! ActivenessViewController
            destinationVC.changeCalorieAmount = changeCalorieAmount
            destinationVC.calorieSublabel = calorieSublabel
            
        }
    }
}

