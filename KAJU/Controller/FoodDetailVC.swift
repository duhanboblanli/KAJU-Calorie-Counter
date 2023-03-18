//
//  FoodDetailVC.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 6.03.2023.
//

import UIKit
import Foundation
import ValueStepper
import FirebaseAuth
import FirebaseFirestore

class FoodDetailVC: UITableViewController {
    
    var query = "egg"
    var foodType = "currentBreakfastCal"
    
    let db = Firestore.firestore()
    var food: FoodStruct!
    var image = UIImage()
    var targetCal = 0
    var targetCarb:Float = 0.0
    var targetFat:Float = 0.0
    var targetPro:Float = 0.0
    var amount = 0.0
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameTitle: UILabel!
    @IBOutlet weak var nutrientsLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var stepper: ValueStepper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepper.enableManualEditing = true
        if query == "egg" {
            foodType = "currentBreakfastCal"
            
        } else if query == "penne" {
            foodType = "currentLunchCal"
        }
        else if query == "fish" {
            foodType = "currentDinnerCal"
        }
        else if query == "apple" {
            foodType = "currentSnacksCal"
        }
        
       
        if let title = food.label, let wholeGram = food.wholeGram, let measureLabel = food.measureLabel {
            foodNameTitle.text = "1 \(measureLabel) \(title) (\(Int(wholeGram))g)"
        }
        
        if let calorie = food.calorie, let carbs = food.carbs, let protein = food.protein, let fat = food.fat, let wholeGram = food.wholeGram {
            let multiple = wholeGram / 100
            let calInt = Int((calorie * multiple).rounded())
            let carbFloat = (carbs * multiple)
            let carbStr = String(format: "%.1f", carbFloat)
            let proFloat = (protein * multiple)
            let proStr = String(format: "%.1f", proFloat)
            let fatFloat = (fat * multiple)
            let fatStr = String(format: "%.1f", fatFloat)
            nutrientsLabel.text = "🔥\(calInt)kcal   🥖Carbs: \(carbStr)g   🥩Protein: \(proStr)g   🧈Fat: \(fatStr)g"
        }
        
        if let image = food.image {
            self.image = image
        } else {
            self.image = UIImage(named: "imagePlaceholder")!
            self.presentAlert(title: "Image not available", message: "")
        }
        foodImageView.image = image
    }
    
    func saveAction() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let imageData = image.pngData()
        let foodEntity = FoodEntity(context: appDelegate.persistentContainer2.viewContext)
        foodEntity.title = food.label
        foodEntity.calories = Int64(food.calorie!)
        foodEntity.carbs = Int64(food.carbs!)
        foodEntity.fats = Int64(food.fat!)
        foodEntity.proteins = Int64(food.protein!)
        foodEntity.wholeGram = Int64(food.wholeGram!)
        foodEntity.measureLabel = food.measureLabel
        foodEntity.image = imageData
        
        do {
            try appDelegate.persistentContainer2.viewContext.save()
            presentAlert(title: "Food added to diary 🤩", message: "")
        } catch {
            presentAlert(title: "Unable to add food", message: "")
        }
    }
    
    
    // currentCal = currentBreakfastCal + currentLunchCal + currentDinnerCal + currentSnacksCal
    // breakfast lunch dinner snacks değerleri burada db'den gelen calorie değerleri ile güncellenecek
    // current carbs pro fat güncellenecek
    @IBAction func addButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        print(targetCal,targetCarb,targetPro,targetFat)
        let amount = stepper.value
            if let calorie = food.calorie, let carbs = food.carbs, let protein = food.protein, let fat = food.fat, let wholeGram = food.wholeGram {
                let multiple = wholeGram / 100
                let calInt = Int((calorie * multiple).rounded()) * Int(amount)
                targetCal += calInt
                let carbFloat = (carbs * multiple) * Float(amount)
                targetCarb += carbFloat
                let proFloat = (protein * multiple) * Float(amount)
                targetPro += proFloat
                let fatFloat = (fat * multiple) * Float(amount)
                targetFat += fatFloat
            }
        
        //Verilerin updatelenmesi(increment işlemi)
        if let currentUserEmail = Auth.auth().currentUser?.email {
             db.collection("UserInformations").document("\(currentUserEmail)").updateData([
                foodType: FieldValue.increment(Int64(targetCal)),
                "currentCarbs": FieldValue.increment(Float64(targetCarb)),
                "currentPro": FieldValue.increment(Float64(targetPro)),
                "currentFat": FieldValue.increment(Float64(targetFat))
             ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
        }
        saveAction()
    }
    
    
    @IBAction func stepperValueChanged(_ sender: ValueStepper) {
        
        amount = sender.value
        if let title = food.label, let wholeGram = food.wholeGram, let measureLabel = food.measureLabel {
            foodNameTitle.text = "\(Int(amount)) \(measureLabel) \(title) (\(Int(wholeGram)*Int(amount))g)"
        }
        
        if let calorie = food.calorie, let carbs = food.carbs, let protein = food.protein, let fat = food.fat, let wholeGram = food.wholeGram {
            let multiple = wholeGram / 100
            let calInt = Int((calorie * multiple).rounded()) * Int(amount)
            let carbFloat = (carbs * multiple) * Float(amount)
            targetCarb += carbFloat
            let carbStr = String(format: "%.1f", carbFloat)
            let proFloat = (protein * multiple) * Float(amount)
            let proStr = String(format: "%.1f", proFloat)
            let fatFloat = (fat * multiple) * Float(amount)
            let fatStr = String(format: "%.1f", fatFloat)
            nutrientsLabel.text = "🔥\(calInt)kcal   🥖Carbs: \(carbStr)g   🥩Protein: \(proStr)g   🧈Fat: \(fatStr)g"
        }
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
        return 4
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}

















