//
//  MainViewController.swift
//  KAJU
//
//  Created by Umut Ulaş Demir on 3.02.2023.
//

import UIKit

class MainViewController: UITableViewController {
    
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
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
    
    // Test Values Before DB
    let totalBreakfastCal = 675
    var currentBreakfastCal = 200
    let totalLunchCal = 900
    var currentLunchCal = 1400
    let totalDinnerCal = 563
    var currentDinnerCal = 440
    let totalSnacksCal = 113
    var currentSnacksCal = 20
    let totalCarbsG = 275
    var currentCarbsG = 212
    let totalProteinG = 110
    var currentProteinG = 152
    let totalFatG = 73
    var currentFatG = 69
    var totalCal =  0
    var currentCal = 0
    
    var strokeColorDarkGreen = UIColor( red: 47/255, green: 136/255, blue: 134/255, alpha: 1).cgColor
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.leftBarButtonItem = nil
        navigationBar.hidesBackButton = true
        
        // Test Values Before DB
        totalCal = totalBreakfastCal + totalLunchCal + totalDinnerCal + totalSnacksCal
        currentCal = currentBreakfastCal + currentLunchCal + currentDinnerCal + currentSnacksCal
        
        // set values..
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
        totalCalShapeLayer.lineWidth = 5
        totalCalShapeLayer.fillColor = UIColor.clear.cgColor
        totalCalShapeLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(totalCalShapeLayer)
        
        // Total Calorie Track Layer
        totalCalTrackLayer.path = circularPathTotalCal.cgPath
        totalCalTrackLayer.fillColor = UIColor.clear.cgColor
        totalCalTrackLayer.strokeColor = strokeColorDarkGreen
        totalCalTrackLayer.lineWidth = 8
        totalCalTrackLayer.lineCap = CAShapeLayerLineCap.round
        totalCalTrackLayer.strokeEnd = 0
        view.layer.addSublayer(totalCalTrackLayer)
        
        if currentCal >= totalCal{
            remainingTitle.text = "Over"
            totalCalTrackLayer.strokeColor = UIColor.orange.cgColor
            currentCal = totalCal
        }
        
        
        // tap gesture just for testing circular progress bars.
        view.addGestureRecognizer(UITapGestureRecognizer (target: self, action: #selector (loadProgressBars)))
    }
    @objc private func loadProgressBars() {
        
        // Load Total Calorie Bar
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

