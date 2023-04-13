//
//  BurnedCalTracker.swift
//  KAJU
//
//  Created by Umut Ulaş Demir on 22.03.2023.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class BurnedCalTracker: UITableViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var calEditText: UITextField!
    @IBOutlet weak var addToDiaryButton: UIButton!
    @IBOutlet weak var calPicker: UIPickerView!
    let calOptions = Array(10...1000)
    var pickerView = UIPickerView()
    override func viewDidLoad() {
        pickerView.delegate = self
        pickerView.dataSource = self
        calEditText.inputView = pickerView
        calEditText.textAlignment = .center
        pickerView.selectRow(90, inComponent: 0, animated: true)
        let burnedTap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.addBurnedButtonClicked))
        addToDiaryButton.isUserInteractionEnabled = true
        addToDiaryButton.addGestureRecognizer(burnedTap)
    }
    @objc
    func burnedTapFunction(sender:UITapGestureRecognizer) {
        //Verilerin updatelenmesi(increment işlemi)
        let cal = Int(calEditText.text!)
        if let currentUserEmail = Auth.auth().currentUser?.email {
             db.collection("UserInformations").document("\(currentUserEmail)").updateData([
                "currentBurnedCal": FieldValue.increment(Int64(cal!)),
                
             ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(nextViewController, animated: false)
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        return 3
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}
extension BurnedCalTracker: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.calOptions.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.calOptions[row].description
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        calEditText.text = calOptions[row].description
        calEditText.resignFirstResponder()
    }
}
extension UIView {
  func comingFromRight(containerView: UIView) {
    let offset = CGPoint(x: containerView.frame.maxX, y: 0)
    let x: CGFloat = 0, y: CGFloat = 0
    self.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
    self.isHidden = false
    UIView.animate(
        withDuration: 1, delay: 0, usingSpringWithDamping: 0.47, initialSpringVelocity: 3,
        options: .curveEaseOut, animations: {
            self.transform = .identity
            self.alpha = 1
    })

} }
                      
