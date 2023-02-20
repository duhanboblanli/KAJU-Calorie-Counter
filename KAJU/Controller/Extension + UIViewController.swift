//
//  Extension + UIViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 20.02.2023.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String, message: String) {
         let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
         let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
         alertVC.addAction(alertAction)
         present(alertVC, animated: true)
     }
}


