//
//  GoalViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 9.02.2023.
//

import UIKit

class GoalViewController: UIViewController {
    
    var changeCalorieAmount = 0
    
    @IBOutlet weak var goalNextButton: UIButton!
    @IBOutlet weak var loseWeightButton: UIButton!
    @IBOutlet weak var protectWeightButton: UIButton!
    @IBOutlet weak var gainMuscleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonStyle(button: goalNextButton, cornerRadius: 0.096)
        //Height 82, soft kare görünüm
        setupButtonStyle(button: loseWeightButton, cornerRadius: 0.04)
        setupButtonStyle(button: protectWeightButton, cornerRadius: 0.04)
        setupButtonStyle(button: gainMuscleButton, cornerRadius: 0.04)
        loseWeightButton.setTitle("🍏 Lose Weight", for: UIControl.State())
        protectWeightButton.setTitle("🧘 Protect Weight", for: UIControl.State())
        gainMuscleButton.setTitle("💪 Gain Muscle", for: UIControl.State())
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func loseWeightPressed(_ sender: UIButton) {
        changeCalorieAmount = -400
        protectWeightButton.isSelected = false
        gainMuscleButton.isSelected = false
    }
    @IBAction func protectWeightPressed(_ sender: UIButton) {
        changeCalorieAmount = 0
        loseWeightButton.isSelected = false
        gainMuscleButton.isSelected = false
    }
    @IBAction func gainMusclePressed(_ sender: UIButton) {
        changeCalorieAmount = 400
        protectWeightButton.isSelected = false
        loseWeightButton.isSelected = false
    }
    
    //Kenarlardan 10,height 72 constraintsli buttonlar için ideal cornerRadius 0.096
    func setupButtonStyle(button : UIButton,cornerRadius: Float){
        button.layer.cornerRadius = CGFloat(cornerRadius) * button.bounds.size.width
        button.clipsToBounds = true
    }
    
    
}
