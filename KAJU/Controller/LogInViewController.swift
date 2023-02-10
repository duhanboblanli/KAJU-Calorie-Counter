//
//  LogInViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 7.02.2023.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonStyle(button: logInButton, cornerRadius: 0.096)
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.errorTextField.text = e.localizedDescription
                }else {
                    //Navigate to the nextViewController
                    self.performSegue(withIdentifier: "LoginToCalculate", sender: self)
                }
            }
        }
    }
    
    //Kenarlardan 10,height 72 constraintsli buttonlar için ideal cornerRadius 0.096
    func setupButtonStyle(button : UIButton,cornerRadius: Float){
        button.layer.cornerRadius = CGFloat(cornerRadius) * button.bounds.size.width
        button.clipsToBounds = true
    }
    
}
