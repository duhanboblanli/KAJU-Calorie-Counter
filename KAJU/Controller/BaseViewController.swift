//
//  BaseViewController.swift
//  KAJU
//
//  Created by Umut Ulaş Demir on 3.04.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class BaseViewController: UIViewController {
    
    var exist: Bool?
    var user = Auth.auth().currentUser
    var store = Firestore.firestore()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        check()
    }

    func check(){
        
        if self.user != nil{
            if let currentUserEmail = self.user!.email {
                let docRef = store.collection("UserInformations").document("\(currentUserEmail)")
                docRef.getDocument {
                    (document, error) in
                    if let document = document, document.exists{
                        print("HIII2!")
                        print("user exist")
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "FirstResponder") as! TabBarController
                        
                        self.navigationController?.pushViewController(viewController, animated: false)
                    }
                    else{
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SecondResponder") as! GoalViewController
                        nextViewController.check = true
                        self.navigationController?.pushViewController(nextViewController, animated: false)
                    }
                }
            }
        }
        else{
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "WelcomeResponder") as! WelcomeViewController
            self.navigationController?.pushViewController(viewController, animated: false)
            print("HIII!")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
