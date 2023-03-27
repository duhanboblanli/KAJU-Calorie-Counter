//
//  MainViewController.swift
//  KAJU
//
//  Created by Umut Ulaş Demir on 3.02.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MainViewController: UITableViewController {
    
    let strokeColorDarkGreen = UIColor( red: 47/255, green: 160/255, blue: 134/255, alpha: 1).cgColor
    let db = Firestore.firestore()
    
    let user = Auth.auth().currentUser
    
    // Views for shapes autolayout constraints
    @IBOutlet weak var totalCalView: UIView!
    let totalCalShapeLayer = CAShapeLayer ()
    let totalCalTrackLayer = CAShapeLayer()
    
    
    @IBOutlet weak var breakfastView: UIView!
    let breakfastShapeLayer = CAShapeLayer()
    let breakfastTrackLayer = CAShapeLayer()
    
    
    @IBOutlet weak var lunchView: UIView!
    let lunchShapeLayer = CAShapeLayer()
    let lunchTrackLayer = CAShapeLayer()
    
    
    @IBOutlet weak var dinnerView: UIView!
    let dinnerShapeLayer = CAShapeLayer()
    let dinnerTrackLayer = CAShapeLayer()
    
    
    @IBOutlet weak var snacksView: UIView!
    let snacksShapeLayer = CAShapeLayer()
    let snacksTrackLayer = CAShapeLayer()
    
    
    // total calorie * 3/10
    var totalBreakfastCal = 0
    var currentBreakfastCal = 0
    
    // total calorie * 4/10
    var totalLunchCal = 0
    var currentLunchCal = 0
    
    // total calorie * 25/100
    var totalDinnerCal = 0
    var currentDinnerCal = 0
    
    // total calorie * 5/100
    var totalSnacksCal = 0
    var currentSnacksCal = 0
    
    // total calorie * 5/10
    // 1g carb = 4,1kcal
    // formula --> (total calorie * 5/10) / 4.1
    var totalCarbsG = 0
    var currentCarbsG:Float = 0.0
    
    // total calorie * 2/10
    // 1g protein = 4,1kcal
    // formula --> (total calorie * 2/10) / 4.1
    var totalProteinG = 0
    var currentProteinG:Float = 0.0
    
    // total calorie * 3/10
    // 1g fat = 9,2kcal
    // formula --> (total calorie * 3/10) / 9.2
    var totalFatG = 0
    var currentFatG:Float = 0.0
    
    var totalCal =  0
    var currentCal = 0
    
    var totalBurnedCal = 0
    var currentBurnedCal = 0
    
    var currentDayReal = 0
    
    @IBOutlet weak var burnedLabel: UILabel!
    @IBOutlet weak var breakfastCalLabel: UILabel!
    @IBOutlet weak var snacksCalLabel: UILabel!
    @IBOutlet weak var dinnerCalLabel: UILabel!
    @IBOutlet weak var lunchCalLabel: UILabel!
    @IBOutlet weak var fatProgressBar: UIProgressView!
    @IBOutlet weak var proteinProgressBar: UIProgressView!
    @IBOutlet weak var carbsProgressBar: UIProgressView!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var calorieBurned: UILabel!
    @IBOutlet weak var remainingTitle: UILabel!
    @IBOutlet weak var calorieEaten: UILabel!
    @IBOutlet weak var calorieRemaining: UILabel!
    @IBOutlet weak var addSnacksButton: UIButton!
    @IBOutlet weak var addDinnerButton: UIButton!
    @IBOutlet weak var addLunchButton: UIButton!
    @IBOutlet weak var addBreakfastButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentDayReal = Date().get(.minute, .day, .month, .year).day!
        // DB verilerini çeker, define(), loadprogressBars() çağırır
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        check()
        self.navigationItem.setHidesBackButton(true, animated: true)
        carbsProgressBar.progressTintColor = UIColor( red: 47/255, green: 160/255, blue: 134/255, alpha: 1)
        fatProgressBar.progressTintColor = UIColor( red: 47/255, green: 160/255, blue: 134/255, alpha: 1)
        proteinProgressBar.progressTintColor = UIColor( red: 47/255, green: 160/255, blue: 134/255, alpha: 1)
 
    }
    private func check(){
        if user == nil{
            print("user not exist")
            
        }
        else{
            print("user exist")
        }
    }
    
    @objc
        func burnedTapFunction(sender:UITapGestureRecognizer) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BurnedCalTracker") as! BurnedCalTracker
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    
    // breakfast, dinners vs. total değerleri ekler
    func calculateTotalValues() {
        let carbsCalorie = Float(totalCal) * Float(0.5)
        totalCarbsG = Int(carbsCalorie / Float(4.1))
        let proteinsCalorie = Float(totalCal) * Float(0.2)
        totalProteinG = Int(proteinsCalorie / Float(4.1))
        let fatsCalorie = Float(totalCal) * Float(0.3)
        totalFatG = Int(fatsCalorie / Float(9.2))
        // total calorie * 3/10
        totalBreakfastCal = Int(Float(totalCal) * Float(0.3))
        // total calorie * 4/10
        totalLunchCal = Int(Float(totalCal) * Float(0.4))
        // total calorie * 25/100
        totalDinnerCal = Int(Float(totalCal) * Float(0.25))
        // total calorie * 5/100
        totalSnacksCal = Int(Float(totalCal) * Float(0.05))
    }
    
    private func resetData(){
        if let currentUserEmail = Auth.auth().currentUser?.email {
            self.db.collection("UserInformations").document("\(currentUserEmail)").updateData([
                "currentBreakfastCal": 0,
                "currentLunchCal": 0,
                "currentDinnerCal": 0,
                "currentSnacksCal": 0,
                "currentCarbs": 0.0,
                "currentPro": 0.0,
                "currentFat": 0.0,
                "currentBurnedCal": 0,
                "currentDay": currentDayReal
             ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
        }
    }
    
    // Load firebase db
    private func loadData() {
        
        if let currentUserEmail = Auth.auth().currentUser?.email {
            let docRef = db.collection("UserInformations").document("\(currentUserEmail)")
            
            // currentCal = currentBreakfastCal + currentLunchCal + currentDinnerCal + currentSnacksCal
            // breakfast lunch dinner snacks değerleri burada db'den gelen calorie değerleri ile güncellenecek
            // current carbs pro fat güncellenecek
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let data = document.data() {
                        print("Document data: \(data)")
    
                        if let calorie = data["calorie"]{
                            DispatchQueue.main.async {
                                self.totalCal = calorie as? Int ?? 0
                                //Breakfast and Nutrients Updated
                                if let currentBreakfastCal = data["currentBreakfastCal"],let currentCarb = data["currentCarbs"], let currentFat = data["currentFat"], let currentPro = data["currentPro"] {
                                    self.currentBreakfastCal = currentBreakfastCal as? Int ?? 0
                                    self.currentCarbsG = Float(currentCarb as? Float64 ?? 0.0)
                                    self.currentFatG = Float(currentFat as? Float64 ?? 0.0)
                                    self.currentProteinG = Float(currentPro as? Float64 ?? 0.0)
                                }// Lunch Cal Updated
                                if let currentLunchCal = data["currentLunchCal"] {
                                    self.currentLunchCal = currentLunchCal as? Int ?? 0
                                    
                                }// Dinner Cal Updated
                                if let currentDinnerCal = data["currentDinnerCal"] {
                                    self.currentDinnerCal = currentDinnerCal as? Int ?? 0
                                   
                                }// Snacks Cal Updated
                                if let currentSnacksCal = data["currentSnacksCal"] {
                                    self.currentSnacksCal = currentSnacksCal as? Int ?? 0
                                
                                }// Burned Cal Updated
                                if let currentBurnedCal = data["currentBurnedCal"] {
                                    self.currentBurnedCal = currentBurnedCal as? Int ?? 0
                                }
                                if let currentDay = data["currentDay"] {
                                    if self.currentDayReal != currentDay as? Int{
                                        self.resetData()
                                    }
                                }
                                
                                // db'den current değer eklendikten sonra değer sıfırlanmalı
                                // yoksa her viewDidLoad'da değer tekrar eklenir
                                /*if let currentUserEmail = Auth.auth().currentUser?.email {
                                    self.db.collection("UserInformations").document("\(currentUserEmail)").updateData([
                                        "currentBreakfastCal": 0,
                                        "currentLunchCal": 0,
                                        "currentDinnerCal": 0,
                                        "currentSnacksCal": 0,
                                        "currentCarbs": 0.0,
                                        "currentPro": 0.0,
                                        "currentFat": 0.0,
                                        "currentBurnedCal": 0
                                     ]) { err in
                                            if let err = err {
                                                print("Error adding document: \(err)")
                                            } else {
                                                print("Document successfully written!")
                                            }
                                        }
                                }*/
                                self.define()
                                self.loadProgressBars()
                            }
                        }
                    }
                } else {
                    print("Document does not exist.")
                }
            }
        }
    }
    
    
    private func define(){
        
        let burnedTap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.burnedTapFunction))
        calorieBurned.isUserInteractionEnabled = true
        calorieBurned.addGestureRecognizer(burnedTap)
        let burnedTap2 = UITapGestureRecognizer(target: self, action: #selector(MainViewController.burnedTapFunction))
        burnedLabel.isUserInteractionEnabled = true
        burnedLabel.addGestureRecognizer(burnedTap2)
        
        //addBreakfastButton.addTarget(self, action: "addBreakfastButtonClicked:", for: .touchUpInside)
        
        // Test Values Before DB
        //totalCal = totalBreakfastCal + totalLunchCal + totalDinnerCal + totalSnacksCal
        currentCal = currentBreakfastCal + currentLunchCal + currentDinnerCal + currentSnacksCal
        
        // set values..
        print("insideDefine:\(totalCal)")
        print("insideDefine:\(currentCal)")
        calculateTotalValues()
        calorieRemaining.text = abs((totalCal + currentBurnedCal - currentCal)).description
        calorieEaten.text = currentCal.description
        calorieBurned.text = currentBurnedCal.description
        let currentCarbsGStr = String(format: "%.1f", currentCarbsG)
        carbsLabel.text = currentCarbsGStr + " / " + totalCarbsG.description + " g"
        let currentProGStr = String(format: "%.1f", currentProteinG)
        proteinLabel.text = currentProGStr + " / " + totalProteinG.description + " g"
        let currentPFatGStr = String(format: "%.1f", currentFatG)
        fatLabel.text = currentPFatGStr + " / " + totalFatG.description + " g"
        breakfastCalLabel.text = currentBreakfastCal.description + " / " + totalBreakfastCal.description + " kcal"
        lunchCalLabel.text = currentLunchCal.description + " / " + totalLunchCal.description + " kcal"
        dinnerCalLabel.text = currentDinnerCal.description + " / " + totalDinnerCal.description + " kcal"
        snacksCalLabel.text = currentSnacksCal.description + " / " + totalSnacksCal.description + " kcal"
        
        // circular paths for circular progress bar shape layers
        // viewin ortası CGPoint(x: totalCalView.bounds.midX, y: totalCalView.bounds.midY)
        // x: 196.5, y: 90 ---> totalCalView.layer.addSublayer(breakfastShapeLayer)
        let circularPathTotalCal = UIBezierPath(arcCenter: CGPoint(x: totalCalView.bounds.midX, y: totalCalView.bounds.midY), radius: 50,
                                                startAngle:  CGFloat.pi*3/4 , endAngle: CGFloat.pi/4, clockwise: true)
        //x: 71, y: 282
        let circularPathBreakfast = UIBezierPath(arcCenter: CGPoint(x: breakfastView.bounds.midX, y: breakfastView.bounds.midY), radius: 25,
                                                 startAngle:  CGFloat.pi*3/2 , endAngle: CGFloat.pi/2*7, clockwise: true)
        
        let circularPathLunch = UIBezierPath(arcCenter: CGPoint(x: lunchView.bounds.midX, y: lunchView.bounds.midY), radius: 25,
                                             startAngle:  CGFloat.pi*3/2 , endAngle: CGFloat.pi/2*7, clockwise: true)
        
        let circularPathDinner = UIBezierPath(arcCenter: CGPoint(x: dinnerView.bounds.midX, y: dinnerView.bounds.midY), radius: 25,
                                              startAngle:  CGFloat.pi*3/2 , endAngle: CGFloat.pi/2*7, clockwise: true)
        
        let circularPathSnacks = UIBezierPath(arcCenter: CGPoint(x: snacksView.bounds.midX, y: snacksView.bounds.midY), radius: 25,
                                              startAngle:  CGFloat.pi*3/2 , endAngle: CGFloat.pi/2*7, clockwise: true)
        
        
        // BREAKFAST
        // Breakfast Shape Layer..
        breakfastShapeLayer.path = circularPathBreakfast.cgPath
        breakfastShapeLayer.strokeColor = UIColor.lightGray.cgColor
        breakfastShapeLayer.lineWidth = 5
        breakfastShapeLayer.fillColor = UIColor.clear.cgColor
        breakfastShapeLayer.lineCap = CAShapeLayerLineCap.round
        //view.layer.addSublayer(breakfastShapeLayer)
        breakfastView.layer.addSublayer(breakfastShapeLayer)
        
      
        // Breakfast Track Layer..
        breakfastTrackLayer.path = circularPathBreakfast.cgPath
        breakfastTrackLayer.fillColor = UIColor.clear.cgColor
        breakfastTrackLayer.strokeColor = strokeColorDarkGreen
        breakfastTrackLayer.lineWidth = 6
        breakfastTrackLayer.lineCap = CAShapeLayerLineCap.round
        breakfastTrackLayer.strokeEnd = 0
        //view.layer.addSublayer(breakfastTrackLayer)
        breakfastView.layer.addSublayer(breakfastTrackLayer)
        
        
        // LUNCH
        // Lunch Shape Layer
        lunchShapeLayer.path = circularPathLunch.cgPath
        lunchShapeLayer.strokeColor = UIColor.lightGray.cgColor
        lunchShapeLayer.lineWidth = 5
        lunchShapeLayer.fillColor = UIColor.clear.cgColor
        lunchShapeLayer.lineCap = CAShapeLayerLineCap.round
        //view.layer.addSublayer(lunchShapeLayer)
        lunchView.layer.addSublayer(lunchShapeLayer)
        
        // Lunch Track Layer
        lunchTrackLayer.path = circularPathLunch.cgPath
        lunchTrackLayer.fillColor = UIColor.clear.cgColor
        lunchTrackLayer.strokeColor = strokeColorDarkGreen
        lunchTrackLayer.lineWidth = 6
        lunchTrackLayer.lineCap = CAShapeLayerLineCap.round
        lunchTrackLayer.strokeEnd = 0
        //view.layer.addSublayer(lunchTrackLayer)
        lunchView.layer.addSublayer(lunchTrackLayer)
        
        
        // DINNER
        // Dinner Shape Layer
        dinnerShapeLayer.path = circularPathDinner.cgPath
        dinnerShapeLayer.strokeColor = UIColor.lightGray.cgColor
        dinnerShapeLayer.lineWidth = 5
        dinnerShapeLayer.fillColor = UIColor.clear.cgColor
        dinnerShapeLayer.lineCap = CAShapeLayerLineCap.round
        //view.layer.addSublayer(dinnerShapeLayer)
        dinnerView.layer.addSublayer(dinnerShapeLayer)
        
        // Dinner Track Layer
        dinnerTrackLayer.path = circularPathDinner.cgPath
        dinnerTrackLayer.fillColor = UIColor.clear.cgColor
        dinnerTrackLayer.strokeColor = strokeColorDarkGreen
        dinnerTrackLayer.lineWidth = 6
        dinnerTrackLayer.lineCap = CAShapeLayerLineCap.round
        dinnerTrackLayer.strokeEnd = 0
        //view.layer.addSublayer(dinnerTrackLayer)
        dinnerView.layer.addSublayer(dinnerTrackLayer)

        
        // SNACKS
        // Snacks Shape Layer
        snacksShapeLayer.path = circularPathSnacks.cgPath
        snacksShapeLayer.strokeColor = UIColor.lightGray.cgColor
        snacksShapeLayer.lineWidth = 5
        snacksShapeLayer.fillColor = UIColor.clear.cgColor
        snacksShapeLayer.lineCap = CAShapeLayerLineCap.round
        //view.layer.addSublayer(snacksShapeLayer)
        snacksView.layer.addSublayer(snacksShapeLayer)

        // Snacks Track Layer
        snacksTrackLayer.path = circularPathSnacks.cgPath
        snacksTrackLayer.fillColor = UIColor.clear.cgColor
        snacksTrackLayer.strokeColor = strokeColorDarkGreen
        snacksTrackLayer.lineWidth = 6
        snacksTrackLayer.lineCap = CAShapeLayerLineCap.round
        snacksTrackLayer.strokeEnd = 0
        //view.layer.addSublayer(snacksTrackLayer)
        snacksView.layer.addSublayer(snacksTrackLayer)

        
        // TOTAL CALORIE
        // Total Calorie Shape Layer
        totalCalShapeLayer.path = circularPathTotalCal.cgPath
        totalCalShapeLayer.strokeColor = UIColor.lightGray.cgColor
        totalCalShapeLayer.lineWidth = 6
        totalCalShapeLayer.fillColor = UIColor.clear.cgColor
        totalCalShapeLayer.lineCap = CAShapeLayerLineCap.round
        //view.layer.addSublayer(totalCalShapeLayer)
        totalCalView.layer.addSublayer(totalCalShapeLayer)
        
        // Total Calorie Track Layer
        totalCalTrackLayer.path = circularPathTotalCal.cgPath
        totalCalTrackLayer.fillColor = UIColor.clear.cgColor
        totalCalTrackLayer.strokeColor = strokeColorDarkGreen
        totalCalTrackLayer.lineWidth = 7
        totalCalTrackLayer.lineCap = CAShapeLayerLineCap.round
        totalCalTrackLayer.strokeEnd = 0
        //view.layer.addSublayer(totalCalTrackLayer)
        totalCalView.layer.addSublayer(totalCalTrackLayer)
        
       if currentCal >= totalCal{
            remainingTitle.text = "Over"
            totalCalTrackLayer.strokeColor = UIColor.orange.cgColor
            currentCal = totalCal
        }
    } // ends of func define()
    
 
    
    @IBAction func caloryBurnedButtonPressed(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BurnedCalTracker") as! BurnedCalTracker
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    private func addBreakfastButtonClicked() {
        if let vc = storyboard?.instantiateViewController(identifier:
        "FoodsViewController") as?
            FoodsViewController {
            vc.query = "egg"
            vc.mealType = 0
            self.navigationController?.pushViewController(vc,animated:true)
        }
    }
    
    @IBAction func addLunchButtonClicked(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FoodsViewController") as! FoodsViewController
        nextViewController.query = "penne"
        nextViewController.mealType = 1
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func addDinnerButtonClicked(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FoodsViewController") as! FoodsViewController
        nextViewController.query = "fish"
        nextViewController.mealType = 2
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func addSnacksButtonClicked(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FoodsViewController") as! FoodsViewController
        nextViewController.query = "apple"
        nextViewController.mealType = 3
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    private func loadProgressBars() {
        // Load Total Calorie Bar
        print("insideLoadProgressBar:\(totalCal)")
        var currentRate = 1-CGFloat(totalCal+currentBurnedCal-currentCal)/CGFloat(totalCal)
        var startAngle = CGFloat.pi*3/4
        var progress = CGFloat.pi*3/2*CGFloat(currentRate)
        var currentEndAngle = startAngle + progress
        let circularPath3 = UIBezierPath(arcCenter: CGPoint(x: totalCalView.bounds.midX, y: totalCalView.bounds.midY), radius: 50,
                                         startAngle:  CGFloat.pi*3/4,
                                         endAngle: currentEndAngle, clockwise:true)
      
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        totalCalTrackLayer.path = circularPath3.cgPath
        totalCalTrackLayer.add(basicAnimation, forKey: "urSoBasic")
        
        // Full Circle Start Angle
        var circleStartAngle = CGFloat.pi*3/2
        
        // Load Breakfast Bar
        if currentBreakfastCal >= totalBreakfastCal{
            currentBreakfastCal = totalBreakfastCal
        }
        var breakfastRate = CGFloat(currentBreakfastCal)/CGFloat(totalBreakfastCal)
        var addedBreakfastProgress = CGFloat.pi*2*CGFloat(breakfastRate)
        var currentBreakfastProgressEndAngle = circleStartAngle + addedBreakfastProgress
        let currentTrackPathBreakfast = UIBezierPath(arcCenter: CGPoint(x: breakfastView.bounds.midX, y: breakfastView.bounds.midY), radius: 25,
                                                     startAngle:  CGFloat.pi*3/2 , endAngle: currentBreakfastProgressEndAngle, clockwise: true)
        
        breakfastTrackLayer.path = currentTrackPathBreakfast.cgPath
        breakfastTrackLayer.add(basicAnimation, forKey: "urSoBasic")
        
        // Load Lunch Bar
        if currentLunchCal >= totalLunchCal{
            currentLunchCal = totalLunchCal
        }
        var lunchRate = CGFloat(currentLunchCal)/CGFloat(totalLunchCal)
        var addedLunchProgress = CGFloat.pi*2*CGFloat(lunchRate)
        var currentLunchProgressEndAngle = circleStartAngle + addedLunchProgress
        let currentTrackPathLunch = UIBezierPath(arcCenter: CGPoint(x: lunchView.bounds.midX, y: lunchView.bounds.midY), radius: 25,
                                                 startAngle:  CGFloat.pi*3/2 , endAngle: currentLunchProgressEndAngle, clockwise: true)
        
        lunchTrackLayer.path = currentTrackPathLunch.cgPath
        lunchTrackLayer.add(basicAnimation, forKey: "urSoBasic")
        
        // Load Dinner Bar
        if currentDinnerCal >= totalDinnerCal{
            currentDinnerCal = totalDinnerCal
        }
        var dinnerRate = CGFloat(currentDinnerCal)/CGFloat(totalDinnerCal)
        var addedDinnerProgress = CGFloat.pi*2*CGFloat(dinnerRate)
        var currentDinnerProgressEndAngle = circleStartAngle + addedDinnerProgress
        let currentTrackPathDinner = UIBezierPath(arcCenter: CGPoint(x: dinnerView.bounds.midX, y: dinnerView.bounds.midY), radius: 25,
                                                  startAngle:  CGFloat.pi*3/2 , endAngle: currentDinnerProgressEndAngle, clockwise: true)
        
        dinnerTrackLayer.path = currentTrackPathDinner.cgPath
        dinnerTrackLayer.add(basicAnimation, forKey: "urSoBasic")
        
        // Load Snacks Bar
        if currentSnacksCal >= totalSnacksCal{
            currentSnacksCal = totalSnacksCal
        }
        var snacksRate = CGFloat(currentSnacksCal)/CGFloat(totalSnacksCal)
        var addedSnacksProgress = CGFloat.pi*2*CGFloat(snacksRate)
        var currentSnacksProgressEndAngle = circleStartAngle + addedSnacksProgress
        let currentTrackPathSnacks = UIBezierPath(arcCenter: CGPoint(x: snacksView.bounds.midX, y: snacksView.bounds.midY), radius: 25,
                                                  startAngle:  CGFloat.pi*3/2 , endAngle: currentSnacksProgressEndAngle, clockwise: true)
        
        snacksTrackLayer.path = currentTrackPathSnacks.cgPath
        snacksTrackLayer.add(basicAnimation, forKey: "urSoBasic")
        
        
        // Classic Progress Bars(Food Items)
        carbsProgressBar.setProgress(Float(currentCarbsG)/Float(totalCarbsG), animated: true)
        proteinProgressBar.setProgress(Float(currentProteinG)/Float(totalProteinG), animated: true)
        fatProgressBar.setProgress(Float(currentFatG)/Float(totalFatG), animated: true)
        
    } // ends of func loadProgressBars()
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1 {
            return 4
        }
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
