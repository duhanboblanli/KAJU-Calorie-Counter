//
//  GoalViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 9.02.2023.
//

import UIKit
import FirebaseAuth




class GoalViewController: UIViewController{
    
    
    var check = false
    var user = Auth.auth().currentUser
    
    @IBOutlet weak var downMiddleConstraint: NSLayoutConstraint!
    @IBOutlet weak var middleConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButtonConstraint: NSLayoutConstraint!
    var changeCalorieAmount = 0
    var calorieSublabel = "According to your choices, your goal is to maintain your weight."
    var ColorDarkGreen = UIColor( red: 47/255, green: 136/255, blue: 134/255, alpha: 1)
    var ColorSelected = UIColor( red: 132/255, green: 198/255, blue: 155/255, alpha: 0.3)
    var ColorDarkBlue = UIColor( red: 40/255, green: 71/255, blue: 92/255, alpha: 1)
    
    @IBOutlet weak var goalNextButton: UIButton!
    @IBOutlet weak var loseWeightButton: UIButton!
    @IBOutlet weak var protectWeightButton: UIButton!
    @IBOutlet weak var gainMuscleButton: UIButton!
    
    
    func animate(){
        let transition = CATransition()
            transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.endProgress = 0.5
        transition.fillMode = CAMediaTimingFillMode.backwards
        navigationController?.view.layer.add(transition, forKey: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !UIDevice.hasNotch{
            print("model:", UIDevice.hasNotch)
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
    
    @IBAction func loseWeightPressed(_ sender: UIButton) {
        changeCalorieAmount = -400
        calorieSublabel = "According to your choices, your goal is to lose your weight."
        protectWeightButton.backgroundColor = ColorDarkBlue
        gainMuscleButton.backgroundColor = ColorDarkBlue
        loseWeightButton.backgroundColor = ColorSelected
        goalNextButton.isEnabled = true
        goalNextButton.isHighlighted = false
        goalNextButton.backgroundColor = ColorDarkGreen
    }
    @IBAction func protectWeightPressed(_ sender: UIButton) {
        
        changeCalorieAmount = 0
        calorieSublabel = "According to your choices, your goal is to maintain your weight."
        protectWeightButton.backgroundColor = ColorSelected
        gainMuscleButton.backgroundColor = ColorDarkBlue
        loseWeightButton.backgroundColor = ColorDarkBlue
        goalNextButton.isEnabled = true
        goalNextButton.isHighlighted = false
        goalNextButton.backgroundColor = ColorDarkGreen
    }
    @IBAction func gainMusclePressed(_ sender: UIButton) {
        changeCalorieAmount = 400
        calorieSublabel = "According to your choices, your goal is to gain muscle."
        protectWeightButton.backgroundColor = ColorDarkBlue
        gainMuscleButton.backgroundColor = ColorSelected
        loseWeightButton.backgroundColor = ColorDarkBlue
        goalNextButton.isEnabled = true
        goalNextButton.isHighlighted = false
        goalNextButton.backgroundColor = ColorDarkGreen
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


