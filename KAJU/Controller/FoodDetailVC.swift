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
import CoreData

class FoodDetailVC: UITableViewController {
    
    var RECENTS_LIMIT = 20
    
    var query = "egg"
    var foodType = "currentBreakfastCal"
    
    var previousValue = 1.0
    var valueCheck = true
    
    var isRecipe = false
    
    let db = Firestore.firestore()
    var food: FoodStruct!
    var image = UIImage()
    var targetCal = 0
    var targetCarb:Float = 0.0
    var targetFat:Float = 0.0
    var targetPro:Float = 0.0
    var amount = 0.0
    var favFood: FavFoodEntity!
    var favFoods: [FavFoodEntity]!
    var recentFoods: [FoodEntity]!
    
    var floatActive = true
    
    var isFav: Bool = false
    var isFav2: Bool = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameTitle: UILabel!
    @IBOutlet weak var nutrientsLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var stepper: ValueStepper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: self.tabBarController!.tabBar.frame.size.height,left: 0,bottom: 0,right: 0)
       
        favoriteAction()
        stepper.minimumValue = 0.1
        stepper.stepValue = 0.1
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
            var lastPart = ""
            if !isRecipe{
                lastPart = "(\(Int(wholeGram))g)"
            }
            foodNameTitle.text = "1 \(measureLabel) \(title) \(lastPart)"
        }
        
        if let calorie = food.calorie, let carbs = food.carbs, let protein = food.protein, let fat = food.fat, let wholeGram = food.wholeGram {
            var multiple = wholeGram / 100
            if isRecipe{
                multiple = 1.0
            }
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchRequest()
    }
    // Fetch the local data
    private func setupFetchRequest() {
        //Recents
        let fetchRequest: NSFetchRequest<FoodEntity> = FoodEntity.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = []
        if let result = try? appDelegate.persistentContainer2.viewContext.fetch(fetchRequest) {
            recentFoods = result
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !isRecipe{
            if !isFav && isFav2 {
                saveActionAddToFavs()
            }
            else if isFav && !isFav2{
                self.appDelegate.persistentContainer3.viewContext.delete(favFood)
                try? self.appDelegate.persistentContainer3.viewContext.save()
            }
        }
    }
    // save to diary
    func saveActionAddToDiary() {
        var inRecent = false
        var lastIndex = 1
        if !recentFoods.isEmpty{
            lastIndex = Int(recentFoods[recentFoods.count-1].index)
            for food2 in recentFoods{
                if food.label == food2.title{
                    inRecent = true
                    appDelegate.persistentContainer2.viewContext.delete(food2)
                }
            }
        }
        if !inRecent && recentFoods.count == RECENTS_LIMIT{
            appDelegate.persistentContainer2.viewContext.delete(recentFoods[0])
        }
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
        foodEntity.index = Int64(lastIndex-1)
        do {
            try appDelegate.persistentContainer2.viewContext.save()
            presentAlert(title: "Food added to diary 🤩", message: "")
        } catch {
            presentAlert(title: "Unable to add food", message: "")
        }
    }
    func saveActionAddToFavs() {
        let imageData = image.pngData()
        let favFoodEntity = FavFoodEntity(context: appDelegate.persistentContainer3.viewContext)
        favFoodEntity.title = food.label
        favFoodEntity.calories = Int64(food.calorie!)
        favFoodEntity.carbs = Int64(food.carbs!)
        favFoodEntity.fats = Int64(food.fat!)
        favFoodEntity.proteins = Int64(food.protein!)
        favFoodEntity.wholeGram = Int64(food.wholeGram!)
        favFoodEntity.measureLabel = food.measureLabel
        favFoodEntity.image = imageData
        
        do {
            try appDelegate.persistentContainer3.viewContext.save()
        } catch {
            presentAlert(title: "Unable to add food", message: "")
        }
    }
    
    
    
    func favoriteAction(){
        if !isRecipe{
            for (i,fav) in favFoods.enumerated() {
                if fav.title == food.label {
                    isFav = true
                    isFav2 = true
                    favFood = favFoods[i]
                }
            }
            if isFav {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorited", style: .plain, target: self, action: #selector(self.unfavorite(_:)))
            }
            else{
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(self.favorite(_:)))
            }
        }
    }
    // Change the button label and action if clicked
    @objc func favorite(_ sender: UITapGestureRecognizer) {
        isFav2 = true
        navigationItem.rightBarButtonItem?.title = "Favorited"
        navigationItem.rightBarButtonItem?.action = #selector(self.unfavorite(_:))
    }
    
    @objc func unfavorite(_ sender: UITapGestureRecognizer) {
        isFav2 = false
        navigationItem.rightBarButtonItem?.title = "Favorite"
        navigationItem.rightBarButtonItem?.action = #selector(self.favorite(_:))
    }
    
    
    // currentCal = currentBreakfastCal + currentLunchCal + currentDinnerCal + currentSnacksCal
    // breakfast lunch dinner snacks değerleri burada db'den gelen calorie değerleri ile güncellenecek
    // current carbs pro fat güncellenecek
    @IBAction func addButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        print(targetCal,targetCarb,targetPro,targetFat)
        let amount = stepper.value
            if let calorie = food.calorie, let carbs = food.carbs, let protein = food.protein, let fat = food.fat, let wholeGram = food.wholeGram {
                var multiple = wholeGram / 100
                if isRecipe{
                    multiple = 1.0
                }
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
        if !isRecipe{
            saveActionAddToDiary()
        }
    }
    
    
    @IBAction func stepperValueChanged(_ sender: ValueStepper) {
        
        if sender.value >= 2{
            sender.value = round(sender.value)
        }
        else if sender.value > 1 && valueCheck{
            sender.value = 2
            valueCheck = false
            sender.stepValue = 1
        }
        else{
            valueCheck = true
            sender.stepValue = 0.1
        }
        amount = sender.value
        if let title = food.label, let wholeGram = food.wholeGram, let measureLabel = food.measureLabel {
    
            var lastPart = ""
            if !isRecipe{
                lastPart = "(\(Int(wholeGram*Float(amount)))g)"
            }
            if amount >= 1{
                foodNameTitle.text = "\(Int(amount)) \(measureLabel) \(title) \(lastPart)"
            }
            else{
                foodNameTitle.text = "\(Float(amount)) \(measureLabel) \(title) \(lastPart)"
            }
            
        }
        
        if let calorie = food.calorie, let carbs = food.carbs, let protein = food.protein, let fat = food.fat, let wholeGram = food.wholeGram {
            var multiple = wholeGram / 100
            if isRecipe{
                multiple = 1.0
            }
            let calInt = Int(calorie * multiple * Float(amount))
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

















