//
//  RegisterViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 8.02.2023.
//

import UIKit


class RegisterViewController: UIViewController {
    
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonStyle(button: signUpButton, cornerRadius: 0.096)
       
    }
    
    
    //Kenarlardan 10,height 72 constraintsli buttonlar için ideal cornerRadius 0.096
    func setupButtonStyle(button : UIButton,cornerRadius: Float){
        button.layer.cornerRadius = CGFloat(cornerRadius) * button.bounds.size.width
        button.clipsToBounds = true
    }
    
}

