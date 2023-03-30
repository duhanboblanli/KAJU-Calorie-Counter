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
        setupButtonStyle(button: logInButton, cornerRadius: 0.046)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.backgroundColor = UIColor.white
        passwordTextField.backgroundColor = UIColor.white
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "email@example.com",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        emailTextField.tag = 1
        passwordTextField.tag = 2
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            UserDefaults.standard.set(password, forKey: email)
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

//MARK: - UITextFieldDelegate
extension LogInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     //Check if there is any other text-field in the view whose tag is +1 greater than the current text-field on which the return key was pressed. If yes → then move the cursor to that next text-field. If No → Dismiss the keyboard
     if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
     nextField.becomeFirstResponder()
     } else {
     textField.resignFirstResponder()
     }
     return false
     }

} // ends of extension:UITextFieldDelegate
