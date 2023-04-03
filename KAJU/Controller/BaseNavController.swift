//
//  BaseNavController.swift
//  KAJU
//
//  Created by Umut Ulaş Demir on 3.04.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class BaseNavController: UINavigationController {
    
    var exist: Bool?
    var user = Auth.auth().currentUser
    var store = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
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
