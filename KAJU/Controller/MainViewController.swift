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
    
    let db = Firestore.firestore()
    
    // Constant theme colors
    let strokeColorDarkGreen = UIColor( red: 47/255, green: 160/255, blue: 134/255, alpha: 1).cgColor
    
    let totalCalShapeLayer = CAShapeLayer ()
    let breakfastShapeLayer = CAShapeLayer()
    let lunchShapeLayer = CAShapeLayer()
    let dinnerShapeLayer = CAShapeLayer()
    let snacksShapeLayer = CAShapeLayer()
    
    let totalCalTrackLayer = CAShapeLayer()
    let breakfastTrackLayer = CAShapeLayer()
    let lunchTrackLayer = CAShapeLayer()
    let dinnerTrackLayer = CAShapeLayer()
    let snacksTrackLayer = CAShapeLayer()
    
    // total calorie * 3/10
    var totalBreakfastCal = 0
    var currentBreakfastCal = 200
    
    // total calorie * 4/10
    var totalLunchCal = 0
    var currentLunchCal = 200
    
    // total calorie * 25/100
    var totalDinnerCal = 0
    var currentDinnerCal = 200
    
    // total calorie * 5/100
    var totalSnacksCal = 0
    var currentSnacksCal = 200
    
    // total calorie * 5/10
    // 1g carb = 4,1kcal
    // formula --> (total calorie * 5/10) / 4.1
    var totalCarbsG = 0
    var currentCarbsG = 50
    
    // total calorie * 2/10
    // 1g protein = 4,1kcal
    // formula --> (total calorie * 2/10) / 4.1
    var totalProteinG = 0
    var currentProteinG = 50
    
    // total calorie * 3/10
    // 1g fat = 9,2kcal
    // formula --> (total calorie * 3/10) / 9.2
    var totalFatG = 0
    var currentFatG = 50
    
    var totalCal =  0
    var currentCal = 200
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carbsProgressBar.progressTintColor = UIColor( red: 47/255, green: 160/255, blue: 134/255, alpha: 1)
        fatProgressBar.progressTintColor = UIColor( red: 47/255, green: 160/255, blue: 134/255, alpha: 1)
        proteinProgressBar.progressTintColor = UIColor( red: 47/255, green: 160/255, blue: 134/255, alpha: 1)
        
        // DB verilerini çeker ve define() çağırır
        loadData()
        
        action()
        
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
    
    // Load firebase db
    private func loadData() {
        
        if let currentUserEmail = Auth.auth().currentUser?.email {
            
            let docRef = db.collection("UserInformations").document("\(currentUserEmail)")
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let data = document.data() {
                        print("Document data: \(data)")
                        if let calorie = data["calorie"] {
                            DispatchQueue.main.async {
                                self.totalCal = calorie as! Int
                                print("insideLoadData:\(self.totalCal)")
                                self.define()
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
        
        //addBreakfastButton.addTarget(self, action: "addBreakfastButtonClicked:", for: .touchUpInside)
        
        // Test Values Before DB
        //totalCal = totalBreakfastCal + totalLunchCal + totalDinnerCal + totalSnacksCal
        //currentCal = currentBreakfastCal + currentLunchCal + currentDinnerCal + currentSnacksCal
        
        // set values..
        print("insideDefine:\(totalCal)")
        print("insideDefine:\(currentCal)")
        calculateTotalValues()
        calorieRemaining.text = abs((totalCal - currentCal)).description
        calorieEaten.text = currentCal.description
        carbsLabel.text = currentCarbsG.description + " / " + totalCarbsG.description + " g"
        proteinLabel.text = currentProteinG.description + " / " + totalProteinG.description + " g"
        fatLabel.text = currentFatG.description + " / " + totalFatG.description + " g"
        breakfastCalLabel.text = currentBreakfastCal.description + " / " + totalBreakfastCal.description + " kcal"
        lunchCalLabel.text = currentLunchCal.description + " / " + totalLunchCal.description + " kcal"
        dinnerCalLabel.text = currentDinnerCal.description + " / " + totalDinnerCal.description + " kcal"
        snacksCalLabel.text = currentSnacksCal.description + " / " + totalSnacksCal.description + " kcal"
        
        // circular paths for circular progress bar shape layers..
        // x: 196.5, y: 90   141.5 58  w:70 h:23
        
        let circularPathTotalCal = UIBezierPath(arcCenter: CGPoint(x: 196.5, y: 90), radius: 50,
                                                startAngle:  CGFloat.pi*3/4 , endAngle: CGFloat.pi/4, clockwise: true)
        let circularPathBreakfast = UIBezierPath(arcCenter: CGPoint(x: 71, y: 282), radius: 25,
                                                 startAngle:  CGFloat.pi*3/2 , endAngle: CGFloat.pi/2*7, clockwise: true)
        let circularPathLunch = UIBezierPath(arcCenter: CGPoint(x: 71, y: 367), radius: 25,
                                             startAngle:  CGFloat.pi*3/2 , endAngle: CGFloat.pi/2*7, clockwise: true)
        let circularPathDinner = UIBezierPath(arcCenter: CGPoint(x: 71, y: 452), radius: 25,
                                              startAngle:  CGFloat.pi*3/2 , endAngle: CGFloat.pi/2*7, clockwise: true)
        let circularPathSnacks = UIBezierPath(arcCenter: CGPoint(x: 71, y: 537), radius: 25,
                                              startAngle:  CGFloat.pi*3/2 , endAngle: CGFloat.pi/2*7, clockwise: true)
        
        
        // BREAKFAST
        // Breakfast Shape Layer..
        breakfastShapeLayer.path = circularPathBreakfast.cgPath
        breakfastShapeLayer.strokeColor = UIColor.lightGray.cgColor
        breakfastShapeLayer.lineWidth = 5
        breakfastShapeLayer.fillColor = UIColor.clear.cgColor
        breakfastShapeLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(breakfastShapeLayer)
        
        // Breakfast Track Layer..
        breakfastTrackLayer.path = circularPathBreakfast.cgPath
        breakfastTrackLayer.fillColor = UIColor.clear.cgColor
        breakfastTrackLayer.strokeColor = strokeColorDarkGreen
        breakfastTrackLayer.lineWidth = 6
        breakfastTrackLayer.lineCap = CAShapeLayerLineCap.round
        breakfastTrackLayer.strokeEnd = 0
        view.layer.addSublayer(breakfastTrackLayer)
        
        
        // LUNCH
        // Lunch Shape Layer
        lunchShapeLayer.path = circularPathLunch.cgPath
        lunchShapeLayer.strokeColor = UIColor.lightGray.cgColor
        lunchShapeLayer.lineWidth = 5
        lunchShapeLayer.fillColor = UIColor.clear.cgColor
        lunchShapeLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(lunchShapeLayer)
        
        // Lunch Track Layer
        lunchTrackLayer.path = circularPathLunch.cgPath
        lunchTrackLayer.fillColor = UIColor.clear.cgColor
        lunchTrackLayer.strokeColor = strokeColorDarkGreen
        lunchTrackLayer.lineWidth = 6
        lunchTrackLayer.lineCap = CAShapeLayerLineCap.round
        lunchTrackLayer.strokeEnd = 0
        view.layer.addSublayer(lunchTrackLayer)
        
        
        // DINNER
        // Dinner Shape Layer
        dinnerShapeLayer.path = circularPathDinner.cgPath
        dinnerShapeLayer.strokeColor = UIColor.lightGray.cgColor
        dinnerShapeLayer.lineWidth = 5
        dinnerShapeLayer.fillColor = UIColor.clear.cgColor
        dinnerShapeLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(dinnerShapeLayer)
        
        // Dinner Track Layer
        dinnerTrackLayer.path = circularPathDinner.cgPath
        dinnerTrackLayer.fillColor = UIColor.clear.cgColor
        dinnerTrackLayer.strokeColor = strokeColorDarkGreen
        dinnerTrackLayer.lineWidth = 6
        dinnerTrackLayer.lineCap = CAShapeLayerLineCap.round
        dinnerTrackLayer.strokeEnd = 0
        view.layer.addSublayer(dinnerTrackLayer)
        
        
        // SNACKS
        // Snacks Shape Layer
        snacksShapeLayer.path = circularPathSnacks.cgPath
        snacksShapeLayer.strokeColor = UIColor.lightGray.cgColor
        snacksShapeLayer.lineWidth = 5
        snacksShapeLayer.fillColor = UIColor.clear.cgColor
        snacksShapeLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(snacksShapeLayer)
        
        // Snacks Track Layer
        snacksTrackLayer.path = circularPathSnacks.cgPath
        snacksTrackLayer.fillColor = UIColor.clear.cgColor
        snacksTrackLayer.strokeColor = strokeColorDarkGreen
        snacksTrackLayer.lineWidth = 6
        snacksTrackLayer.lineCap = CAShapeLayerLineCap.round
        snacksTrackLayer.strokeEnd = 0
        view.layer.addSublayer(snacksTrackLayer)
        
        
        // TOTAL CALORIE
        // Total Calorie Shape Layer
        totalCalShapeLayer.path = circularPathTotalCal.cgPath
        totalCalShapeLayer.strokeColor = UIColor.lightGray.cgColor
        totalCalShapeLayer.lineWidth = 6
        totalCalShapeLayer.fillColor = UIColor.clear.cgColor
        totalCalShapeLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(totalCalShapeLayer)
        
        // Total Calorie Track Layer
        totalCalTrackLayer.path = circularPathTotalCal.cgPath
        totalCalTrackLayer.fillColor = UIColor.clear.cgColor
        totalCalTrackLayer.strokeColor = strokeColorDarkGreen
        totalCalTrackLayer.lineWidth = 7
        totalCalTrackLayer.lineCap = CAShapeLayerLineCap.round
        totalCalTrackLayer.strokeEnd = 0
        view.layer.addSublayer(totalCalTrackLayer)
        
        if currentCal >= totalCal{
            remainingTitle.text = "Over"
            totalCalTrackLayer.strokeColor = UIColor.orange.cgColor
            currentCal = totalCal
        }
    } // ends of func define()
    
    private func action(){
        // tap gesture just for testing circular progress bars.
        view.addGestureRecognizer(UITapGestureRecognizer (target: self, action: #selector (loadProgressBars)))
    }
    
    private func addBreakfastButtonClicked(){
        if let vc = storyboard?.instantiateViewController(identifier:
        "FoodsViewController") as?
            FoodsViewController{ // Set the view controller to pass to
            //vc.name = targetgGames[i].name
            //vc.isFav = favoriteGamesList?[i]
            /*vc.callBack = { (index: Int,isFav: Bool) in
             //nothing for now
             }*/
            self.navigationController?.pushViewController(vc,animated:true)
        }
    }
    
    @objc private func loadProgressBars() {
        // Load Total Calorie Bar
        print("insideLoadProgressBar:\(totalCal)")
        var currentRate = 1-CGFloat(totalCal-currentCal)/CGFloat(totalCal)
        var startAngle = CGFloat.pi*3/4
        var progress = CGFloat.pi*3/2*CGFloat(currentRate)
        var currentEndAngle = startAngle + progress
        let circularPath3 = UIBezierPath(arcCenter: CGPoint(x: 196.5, y: 90), radius: 50,
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
        let currentTrackPathBreakfast = UIBezierPath(arcCenter: CGPoint(x: 71, y: 282), radius: 25,
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
        let currentTrackPathLunch = UIBezierPath(arcCenter: CGPoint(x: 71, y: 367), radius: 25,
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
        let currentTrackPathDinner = UIBezierPath(arcCenter: CGPoint(x: 71, y: 452), radius: 25,
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
        let currentTrackPathSnacks = UIBezierPath(arcCenter: CGPoint(x: 71, y: 537), radius: 25,
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

