//
//  WelcomeViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 4.02.2023.
//

import UIKit


class WelcomeViewController: UIViewController {

    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonStyle(button: getStartedButton, cornerRadius: 0.096)
        setupButtonStyle(button: logInButton, cornerRadius: 0.09)
    }
    
    
    //Kenarlardan 10,height 72 constraintsli buttonlar için ideal cornerRadius 0.096
    //Kenarlardan 10,height 65 constraintsli buttonlar için ideal cornerRadius 0.09
    func setupButtonStyle(button : UIButton,cornerRadius: Float){
        button.layer.cornerRadius = CGFloat(cornerRadius) * button.bounds.size.width
        button.clipsToBounds = true
    }
    
    
    
    
    
}


