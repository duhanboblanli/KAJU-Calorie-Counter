//
//  WelcomeViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 4.02.2023.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var logInBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var firstInfoLabel: UILabel!
    @IBOutlet weak var thirdInfoLabel: UILabel!
    
    var percentage = 0
    var counter = 0
    var timer: Timer?
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        if !UIDevice.hasNotch{
            print("model:", UIDevice.hasNotch)
            logInBottomConstraint.constant = -20
        }
        //check()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonStyle(button: getStartedButton, cornerRadius: 0.096)
        setupButtonStyle(button: logInButton, cornerRadius: 0.09)
        
        //Title Label Animation With For Loop
        firstInfoLabel.text = ""
        var charIndex = 0.0
        let titleText = "💪 Lose weight, build muscle or simply get healthy."
        for letter in titleText {
            //charIndex ile çarpmaz isek hepsi 0.1'inci saniyede oluşturulur
            //Yani for döngüsü içinde sıra sıra hepsi aynı anda oluşturulmuş olur
            //Bu nedenle 0, 0.1, 0.2, ... olarak zaman aralığını güncelleriz
            Timer.scheduledTimer(withTimeInterval: 0.06*charIndex, repeats: false) { (timer) in
                self.firstInfoLabel.text?.append(letter)
            }
            charIndex += 1
        }
        
        incrementLabel(amount: 12)
    }
    
    //Kenarlardan 10,height 72 constraintsli buttonlar için ideal cornerRadius 0.096
    //Kenarlardan 10,height 65 constraintsli buttonlar için ideal cornerRadius 0.09
    func setupButtonStyle(button : UIButton,cornerRadius: Float){
        button.layer.cornerRadius = CGFloat(cornerRadius) * button.bounds.size.width
        button.clipsToBounds = true
    }
    
    func incrementLabel(amount: Int) {
        counter = amount
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateDelay), userInfo: nil, repeats: true)
    }

    @objc func updateDelay() {
        if (counter > 0) {
            counter -= 1
            percentage += 1
            if percentage == 6 {
                //Title Label Animation With For Loop
                infoLabel.text = ""
                var charIndex = 0.0
                let titleText = "🧑‍🍳 Discover healthy recipes and use food tracker."
                for letter in titleText {
                    Timer.scheduledTimer(withTimeInterval: 0.06*charIndex, repeats: false) { (timer) in
                        self.infoLabel.text?.append(letter)
                    }
                    charIndex += 1
                }
            }
            if percentage == 12 {
                //Title Label Animation With For Loop
                thirdInfoLabel.text = ""
                var charIndex = 0.0
                let titleText = "🙏 We'll help you every step of the way."
                for letter in titleText {
                    Timer.scheduledTimer(withTimeInterval: 0.06*charIndex, repeats: false) { (timer) in
                        self.thirdInfoLabel.text?.append(letter)
                    }
                    charIndex += 1
                }
            }
        } else {
            timer!.invalidate()
            timer = nil
        }
    }
    
}


