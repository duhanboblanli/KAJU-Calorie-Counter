//
//  LogInViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 7.02.2023.
//

import UIKit


class LogInViewController: UIViewController {
    

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonStyle(button: logInButton, cornerRadius: 0.096)
       
    }
    
    
    //Kenarlardan 10,height 72 constraintsli buttonlar için ideal cornerRadius 0.096
    func setupButtonStyle(button : UIButton,cornerRadius: Float){
        button.layer.cornerRadius = CGFloat(cornerRadius) * button.bounds.size.width
        button.clipsToBounds = true
    }
    
}
