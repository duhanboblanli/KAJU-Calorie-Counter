//
//  MainViewController.swift
//  KAJU
//
//  Created by Umut Ulaş Demir on 3.02.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class MainViewController: UITableViewController {
    
    //MARK: - Firebase Variables
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    //MARK: - Shape Variables
    // Shape Layers of Progress Bar Views
    
    // total cal
    private let totalCalShapeLayer = CAShapeLayer ()
    private let totalCalTrackLayer = CAShapeLayer()
    private var circularPathTotalCal: UIBezierPath?
    
    // breakfast cal
    private let breakfastShapeLayer = CAShapeLayer()
    private let breakfastTrackLayer = CAShapeLayer()
    private var circularPathBreakfast: UIBezierPath?
    private var breakfastViewMidX: Double?
    private var breakfastViewMidY: Double?
    
    // lunch cal
    private let lunchShapeLayer = CAShapeLayer()
    private let lunchTrackLayer = CAShapeLayer()
    private var circularPathLunch: UIBezierPath?
    private var lunchViewMidX: Double?
    private var lunchViewMidY: Double?
    
    // dinner cal
    private let dinnerShapeLayer = CAShapeLayer()
    private let dinnerTrackLayer = CAShapeLayer()
    private var circularPathDinner: UIBezierPath?
    private var dinnerViewMidX: Double?
    private var dinnerViewMidY: Double?
    
    // snacks Cal
    private let snacksShapeLayer = CAShapeLayer()
    private let snacksTrackLayer = CAShapeLayer()
    private var circularPathSnacks: UIBezierPath?
    private var snacksViewMidX: Double?
    private var snacksViewMidY: Double?
    
    //MARK: - General Calorie Variables
    // total cal
    private var totalCal: Int?
    private var currentCal: Int?
    
    // burned cal
    private  var totalBurnedCal: Int?
    private var currentBurnedCal: Int?
    
    // breakfast cal = total cal * 3/10
    private var totalBreakfastCal: Int?
    private var currentBreakfastCal: Int?
    
    // lunch cal = total cal * 4/10
    private var totalLunchCal: Int?
    private var currentLunchCal: Int?
    
    // dinner cal = total cal * 25/100
    private var totalDinnerCal: Int?
    private var currentDinnerCal: Int?
    
    // snacks cal = total cal * 5/100
    private var totalSnacksCal: Int?
    private var currentSnacksCal: Int?
    
    // carbs cal = total cal * 5/10
    // 1g carb = 4,1kcal
    // formula --> (total calorie * 5/10) / 4.1
    private var totalCarbsG = 0
    private var currentCarbsG:Float = 0.0
    
    // protein cal = total cal * 2/10
    // 1g protein = 4,1kcal
    // formula --> (total calorie * 2/10) / 4.1
    private var totalProteinG = 0
    private var currentProteinG:Float = 0.0
    
    // fat cal = total cal * 3/10
    // 1g fat = 9,2kcal
    // formula --> (total calorie * 3/10) / 9.2
    private var totalFatG = 0
    private var currentFatG:Float = 0.0

    
    //MARK: - Other Variables
    private var currentDay: Int? // today
    private var progressBarLoadAnimation: CABasicAnimation?
    // loading spinner view
    private var activityIndicatorContainer: UIView!
    private var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - View Outlets
    // circular progress bar shape layer views
    @IBOutlet weak var totalCalView: UIView!
    @IBOutlet weak var breakfastView: UIView!
    @IBOutlet weak var lunchView: UIView!
    @IBOutlet weak var dinnerView: UIView!
    @IBOutlet weak var snacksView: UIView!
    // progress bar views
    @IBOutlet weak var fatProgressBarView: UIProgressView!
    @IBOutlet weak var proteinProgressBarView: UIProgressView!
    @IBOutlet weak var carbsProgressBarView: UIProgressView!
    
    //MARK: - Top Side Outlets
    // Sublabels
    @IBOutlet weak var eatenSubLabel: UILabel!
    @IBOutlet weak var remainingSubLabel: UILabel!
    @IBOutlet weak var burnedSubLabel: UILabel!
    // Nutrients sublabels
    @IBOutlet weak var carbsSubLabel: UILabel!
    @IBOutlet weak var proteinSubLabel: UILabel!
    @IBOutlet weak var fatSubLabel: UILabel!
    // Labels
    @IBOutlet weak var eatenLabel: UILabel!
    @IBOutlet weak var remaniningLabel: UILabel!
    @IBOutlet weak var burnedLabel: UILabel!
    // Nutrients Labels
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    
    //MARK: - Meals Side Outlets
    // Sublabels
    @IBOutlet weak var breakfastSubLabel: UILabel!
    @IBOutlet weak var lunchSubLabel: UILabel!
    @IBOutlet weak var dinnerSubLabel: UILabel!
    @IBOutlet weak var snacksSubLabel: UILabel!
    @IBOutlet weak var bottomBurnedSubLabel: UILabel!
    // Labels
    @IBOutlet weak var breakfastLabel: UILabel!
    @IBOutlet weak var lunchLabel: UILabel!
    @IBOutlet weak var dinnerLabel: UILabel!
    @IBOutlet weak var snacksLabel: UILabel!
    
    //MARK: - View Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupActivityIndicator() // set loading spinner
        showActivityIndicator(show: true) // show spinner
        defineSubLabels() // define localized sublabels
        currentDay = Date().get(.minute, .day, .month, .year).day! // get current day to compare with the day in db
        loadData() // --> calls fillCalLabel at the end --> calls loadProgressBars at the end
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        define()
    }
    
    func define(){
        defineSubLabels()
        action()
    }
    
    //MARK: - Localization
    private func defineSubLabels(){
        navigationItem.title = navigationItem.title?.localized()
        bottomBurnedSubLabel.text = bottomBurnedSubLabel.text?.localized()
        remainingSubLabel.text = remainingSubLabel.text?.localized()
        eatenSubLabel.text = eatenSubLabel.text?.localized()
        burnedSubLabel.text = burnedSubLabel.text?.localized()
        breakfastSubLabel.text = breakfastSubLabel.text?.localized()
        lunchSubLabel.text = lunchSubLabel.text?.localized()
        dinnerSubLabel.text = dinnerSubLabel.text?.localized()
        snacksSubLabel.text = snacksSubLabel.text?.localized()
        carbsSubLabel.text = carbsSubLabel.text?.localized()
        proteinSubLabel.text = proteinSubLabel.text?.localized()
        fatSubLabel.text = fatSubLabel.text?.localized()
    }
    
    
    //MARK: - Load Progress Bars Methods
    
    private func adjustProgressBarColors(){
        carbsProgressBarView.progressTintColor = SpecialColors.strokeColorDarkGreen.associatedColor
        fatProgressBarView.progressTintColor = SpecialColors.strokeColorDarkGreen.associatedColor
        proteinProgressBarView.progressTintColor = SpecialColors.strokeColorDarkGreen.associatedColor
    }
    private func defineProgressViewConstraints(){
        // breakfast
        breakfastViewMidX = breakfastView.bounds.midX
        breakfastViewMidY = breakfastView.bounds.midY
        // lunch
        lunchViewMidX = lunchView.bounds.midX
        lunchViewMidY = lunchView.bounds.midY
        // dinner
        dinnerViewMidX = dinnerView.bounds.midX
        dinnerViewMidY = dinnerView.bounds.midY
        // snacks
        snacksViewMidX = snacksView.bounds.midX
        snacksViewMidY = snacksView.bounds.midY
    }
    // circular paths for circular progress bar shape layers
    private func defineCircularPaths(){
        circularPathTotalCal = UIBezierPath(arcCenter: CGPoint(x: totalCalView.bounds.midX, y: totalCalView.bounds.midY), radius: 50,
                                                startAngle:  CGFloat.pi*3/4 , endAngle: CGFloat.pi/4, clockwise: true)
        // breakfast
        if let breakfastViewMidX = breakfastViewMidX, let breakfastViewMidY = breakfastViewMidY{
            circularPathBreakfast = UIBezierPath(arcCenter: CGPoint(x: breakfastViewMidX, y: breakfastViewMidY), radius: 25,
                                                     startAngle:  CGFloat.pi*3/2 , endAngle: CGFloat.pi/2*7, clockwise: true)
        }
        // lunch
        if let lunchViewMidX = lunchViewMidX, let lunchViewMidY = lunchViewMidY{
            circularPathLunch = UIBezierPath(arcCenter: CGPoint(x: lunchViewMidX, y: lunchViewMidY), radius: 25,
                                                 startAngle:  CGFloat.pi*3/2 , endAngle: CGFloat.pi/2*7, clockwise: true)
        }
        // dinner
        if let dinnerViewMidX = dinnerViewMidX, let dinnerViewMidY = dinnerViewMidY{
            circularPathDinner = UIBezierPath(arcCenter: CGPoint(x: dinnerViewMidX, y: dinnerViewMidY), radius: 25,
                                                  startAngle:  CGFloat.pi*3/2 , endAngle: CGFloat.pi/2*7, clockwise: true)
        }
        // snacks
        if let snacksViewMidX = snacksViewMidX, let snacksViewMidY = snacksViewMidY{
            circularPathSnacks = UIBezierPath(arcCenter: CGPoint(x: snacksViewMidX, y: snacksViewMidY), radius: 25,
                                                  startAngle:  CGFloat.pi*3/2 , endAngle: CGFloat.pi/2*7, clockwise: true)
        }
        
        
    }
        
    private func drawProgressBars(){
        addDefaultTotalCalProgressBarView()
        addTrackerTotalCalProgressBarView()
        // Breakfast Shape Layer.
        
        if let circularPathBreakfast = circularPathBreakfast {
            addDefaultMealProgressBarMealView(shapeLayer: breakfastShapeLayer, circularPath: circularPathBreakfast, view: breakfastView)
            addTrackerMealProgressBarView(shapeLayer: breakfastTrackLayer, circularPath: circularPathBreakfast, view: breakfastView)
        }
        
        if let circularPathLunch = circularPathLunch {
            addDefaultMealProgressBarMealView(shapeLayer: lunchShapeLayer, circularPath: circularPathLunch, view: lunchView)
            addTrackerMealProgressBarView(shapeLayer: lunchTrackLayer, circularPath: circularPathLunch, view: lunchView)
        }
        if let circularPathDinner = circularPathDinner {
            addDefaultMealProgressBarMealView(shapeLayer: dinnerShapeLayer, circularPath: circularPathDinner, view: dinnerView)
            addTrackerMealProgressBarView(shapeLayer: dinnerTrackLayer, circularPath: circularPathDinner, view: dinnerView)
        }
        if let circularPathSnacks = circularPathSnacks {
            addDefaultMealProgressBarMealView(shapeLayer: snacksShapeLayer, circularPath: circularPathSnacks, view: snacksView)
            addTrackerMealProgressBarView(shapeLayer: snacksTrackLayer, circularPath: circularPathSnacks, view: snacksView)
        }
    }
    
    private func addDefaultMealProgressBarMealView(shapeLayer: CAShapeLayer, circularPath: UIBezierPath, view: UIView){
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(shapeLayer)
    }
    private func addTrackerMealProgressBarView(shapeLayer: CAShapeLayer, circularPath: UIBezierPath, view: UIView){
        shapeLayer.path = circularPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = SpecialColors.strokeColorDarkGreen.CGColorType
        shapeLayer.lineWidth = 6
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }
    
    private func addDefaultTotalCalProgressBarView(){
        totalCalShapeLayer.path = circularPathTotalCal?.cgPath
        totalCalShapeLayer.strokeColor = UIColor.lightGray.cgColor
        totalCalShapeLayer.lineWidth = 6
        totalCalShapeLayer.fillColor = UIColor.clear.cgColor
        totalCalShapeLayer.lineCap = CAShapeLayerLineCap.round
        totalCalView.layer.addSublayer(totalCalShapeLayer)
    }
    
    private func addTrackerTotalCalProgressBarView(){
        totalCalTrackLayer.path = circularPathTotalCal?.cgPath
        totalCalTrackLayer.fillColor = UIColor.clear.cgColor
        totalCalTrackLayer.strokeColor = SpecialColors.strokeColorDarkGreen.CGColorType
        totalCalTrackLayer.lineWidth = 7
        totalCalTrackLayer.lineCap = CAShapeLayerLineCap.round
        totalCalTrackLayer.strokeEnd = 0
        totalCalView.layer.addSublayer(totalCalTrackLayer)
    }
    
    // load bar animation
    private func loadProgressBarAnimation(){
        progressBarLoadAnimation = CABasicAnimation(keyPath: "strokeEnd")
        progressBarLoadAnimation?.toValue = 1
        progressBarLoadAnimation?.duration = 2
        progressBarLoadAnimation?.fillMode = CAMediaTimingFillMode.forwards
        progressBarLoadAnimation?.isRemovedOnCompletion = false
    }
    private func createCircularMealLoaderPath(x: Double, y: Double, startAngle: CGFloat, radius: CGFloat, currentCal: Int, totalCal: Int) -> CGPath{
        
        let rate = CGFloat(currentCal)/CGFloat(totalCal)
        let addedProgress = CGFloat.pi*2*CGFloat(rate)
        let endAngle = startAngle + addedProgress
        
        return UIBezierPath(
            arcCenter: CGPoint(x: x, y: y),
            radius: radius,
            startAngle:  startAngle,
            endAngle: endAngle,
            clockwise: true).cgPath
    }
    
    private func totalCalLoadTracker(){
        let currentRate = 1-CGFloat((totalCal ?? Int(0))+(currentBurnedCal ?? Int(0))-(currentCal ?? Int(0)))/CGFloat((totalCal ?? Int(0))+(currentBurnedCal ?? Int(0)))
        let startAngle = CGFloat.pi*3/4
        let progress = CGFloat.pi*3/2*CGFloat(currentRate)
        let currentEndAngle = startAngle + progress
        let circularPath3 = UIBezierPath(arcCenter: CGPoint(x: totalCalView.bounds.midX, y: totalCalView.bounds.midY), radius: 50,
                                         startAngle:  CGFloat.pi*3/4,
                                         endAngle: currentEndAngle, clockwise:true)
      
        
        totalCalTrackLayer.path = circularPath3.cgPath
        totalCalTrackLayer.add(progressBarLoadAnimation!, forKey: "urSoBasic")
    }
    
    private func drawTrackerProgressBars(){
        totalCalLoadTracker()
        // Full Circle Start Angle
        let circleStartAngle = CGFloat.pi*3/2
        let circleRadius = 25
        
        // Load Breakfast Bar
        if let currentBreakfastCal = currentBreakfastCal, let totalBreakfastCal = totalBreakfastCal, let breakfastViewMidX = breakfastViewMidX, let breakfastViewMidY = breakfastViewMidY, let progressBarLoadAnimation = progressBarLoadAnimation{
            if currentBreakfastCal >= totalBreakfastCal{
                self.currentBreakfastCal = totalBreakfastCal
                
            }
            breakfastTrackLayer.path = createCircularMealLoaderPath(x: breakfastViewMidX, y: breakfastViewMidY, startAngle: circleStartAngle, radius: CGFloat(circleRadius), currentCal: currentBreakfastCal, totalCal: totalBreakfastCal)
            breakfastTrackLayer.add(progressBarLoadAnimation, forKey: "urSoBasic")
        }
    
        // Load Lunch Bar
        if let currentLunchCal = currentLunchCal, let totalLunchCal = totalLunchCal, let lunchViewMidX = lunchViewMidX, let lunchViewMidY = lunchViewMidY, let progressBarLoadAnimation = progressBarLoadAnimation{
            if currentLunchCal >= totalLunchCal{
                self.currentLunchCal = totalLunchCal
            }
            lunchTrackLayer.path = createCircularMealLoaderPath(x: lunchViewMidX, y: lunchViewMidY, startAngle: circleStartAngle, radius: CGFloat(circleRadius), currentCal: currentLunchCal, totalCal: totalLunchCal)
            lunchTrackLayer.add(progressBarLoadAnimation, forKey: "urSoBasic")
        }
    
        // Load Dinner Bar
        if let currentDinnerCal = currentDinnerCal, let totalDinnerCal = totalDinnerCal, let dinnerViewMidX = dinnerViewMidX, let dinnerViewMidY = dinnerViewMidY, let progressBarLoadAnimation = progressBarLoadAnimation{
            if currentDinnerCal >= totalDinnerCal{
                self.currentDinnerCal = totalDinnerCal
            }
            dinnerTrackLayer.path = createCircularMealLoaderPath(x: dinnerViewMidX, y: dinnerViewMidY, startAngle: circleStartAngle, radius: CGFloat(circleRadius), currentCal: currentDinnerCal, totalCal: totalDinnerCal)
            dinnerTrackLayer.add(progressBarLoadAnimation, forKey: "urSoBasic")
        }
        
        // Load Snacks Bar
        if let currentSnacksCal = currentSnacksCal, let totalSnacksCal = totalSnacksCal, let snacksViewMidX = snacksViewMidX, let snacksViewMidY = snacksViewMidY, let progressBarLoadAnimation = progressBarLoadAnimation{
            if currentSnacksCal >= totalSnacksCal{
                self.currentSnacksCal = totalSnacksCal
            }
            snacksTrackLayer.path = createCircularMealLoaderPath(x: snacksViewMidX, y: snacksViewMidY, startAngle: circleStartAngle, radius: CGFloat(circleRadius), currentCal: currentSnacksCal, totalCal: totalSnacksCal)
            snacksTrackLayer.add(progressBarLoadAnimation, forKey: "urSoBasic")
        }
        
        // Classic Progress Bars(Food Items)
        carbsProgressBarView.setProgress(Float(currentCarbsG)/Float(totalCarbsG), animated: true)
        proteinProgressBarView.setProgress(Float(currentProteinG)/Float(totalProteinG), animated: true)
        fatProgressBarView.setProgress(Float(currentFatG)/Float(totalFatG), animated: true)
    }
    
    private func loadProgressBars(){
        adjustProgressBarColors()
        loadProgressBarAnimation()
        defineProgressViewConstraints()
        defineCircularPaths()
        drawProgressBars()
        drawTrackerProgressBars()
    }

    //MARK: - Loading Spinner Methods
    
    // Loading alert functionality
    private func showActivityIndicator(show: Bool) {
      if show {
        DispatchQueue.main.async{
            self.activityIndicator.startAnimating()
        }
      } else {
            DispatchQueue.main.async{
                self.activityIndicator.stopAnimating()
                self.activityIndicatorContainer.removeFromSuperview()
            }
        }
    }
    
    //Loading Alert Setup
    private func setupActivityIndicator() {
        activityIndicatorContainer = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        activityIndicatorContainer.center.x = view.center.x
        activityIndicatorContainer.center.y = view.center.y
        activityIndicatorContainer.backgroundColor = UIColor.black
        activityIndicatorContainer.alpha = 0.7
        activityIndicatorContainer.layer.cornerRadius = 10
          
        // Configure the activity indicator
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.color = .white
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorContainer.addSubview(activityIndicator)
        view.addSubview(activityIndicatorContainer)
            
        // Constraints
        activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorContainer.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorContainer.centerYAnchor).isActive = true
    }
    
    //MARK: - Tap Listener Methods

    private func action(){
        let topBurnedTap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.addBurnedButtonClicked))
        burnedLabel.isUserInteractionEnabled = true
        burnedLabel.addGestureRecognizer(topBurnedTap)
        let bottomBurnedTap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.addBurnedButtonClicked))
        burnedSubLabel.isUserInteractionEnabled = true
        burnedSubLabel.addGestureRecognizer(bottomBurnedTap)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
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
    
    @objc
        func addBurnedButtonClicked(sender:UITapGestureRecognizer) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BurnedCalTracker") as! BurnedCalTracker
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    
    //MARK: - Label Filler Methods
    // fill cal labels
    private func fillCalLabels(){
        calculateTotalCalNeeds()
        // Top Side Labels
        if let currentBreakfastCal = currentBreakfastCal, let currentLunchCal = currentLunchCal, let currentDinnerCal = currentDinnerCal, let currentSnacksCal = currentSnacksCal {
            currentCal = currentBreakfastCal + currentLunchCal + currentDinnerCal + currentSnacksCal
            
        }
        if let currentBurnedCal = currentBurnedCal, let currentCal = currentCal, let totalCal = totalCal {
            remaniningLabel.text = abs(totalCal + currentBurnedCal - currentCal).description
            
        }
        eatenLabel.text = currentCal?.description
        burnedLabel.text = currentBurnedCal?.description
        
        // Nutrients Labels
        let currentCarbsGStr = String(format: "%.1f", currentCarbsG)
        carbsLabel.text = currentCarbsGStr + " / " + totalCarbsG.description + " g"
        let currentProGStr = String(format: "%.1f", currentProteinG)
        proteinLabel.text = currentProGStr + " / " + totalProteinG.description + " g"
        let currentPFatGStr = String(format: "%.1f", currentFatG)
        fatLabel.text = currentPFatGStr + " / " + totalFatG.description + " g"
        
        // Meal Side Labels
        breakfastLabel.text = (currentBreakfastCal?.description ?? "0") + " / " + (totalBreakfastCal?.description ?? "0") + " kcal"
        lunchLabel.text = (currentLunchCal?.description ?? "0") + " / " + (totalLunchCal?.description ?? "0") + " kcal"
        dinnerLabel.text = (currentDinnerCal?.description ?? "0") + " / " + (totalDinnerCal?.description ?? "0") + " kcal"
        snacksLabel.text = (currentSnacksCal?.description ?? "0") + " / " + (totalSnacksCal?.description ?? "0") + " kcal"
        
        // check if current cal is over user needs
        if let currentBurnedCal = currentBurnedCal, let currentCal = currentCal, let totalCal = totalCal {
            if currentCal >= (totalCal  + currentBurnedCal){
                remainingSubLabel.text = "Over".localized()
                totalCalTrackLayer.strokeColor = UIColor.orange.cgColor
                self.currentCal = totalCal + currentBurnedCal
             }
             else{
                 remainingSubLabel.text = "Remaining".localized()
             }
        }
        showActivityIndicator(show: false) // dismiss the loading spinner
        self.loadProgressBars() // load progress bar
    }
    // calculate
    private func calculateTotalCalNeeds() {
        let carbsCalorie = Float(totalCal ?? Int(0)) * Float(0.5)
        totalCarbsG = Int(carbsCalorie / Float(4.1))
        let proteinsCalorie = Float(totalCal ?? Int(0)) * Float(0.2)
        totalProteinG = Int(proteinsCalorie / Float(4.1))
        let fatsCalorie = Float(totalCal ?? Int(0)) * Float(0.3)
        totalFatG = Int(fatsCalorie / Float(9.2))
        // total calorie * 3/10
        totalBreakfastCal = Int(Float(totalCal ?? Int(0)) * Float(0.3))
        // total calorie * 4/10
        totalLunchCal = Int(Float(totalCal ?? Int(0)) * Float(0.4))
        // total calorie * 25/100
        totalDinnerCal = Int(Float(totalCal ?? Int(0)) * Float(0.25))
        // total calorie * 5/100
        totalSnacksCal = Int(Float(totalCal ?? Int(0)) * Float(0.05))
    }
    
    //MARK: - Database Methods
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
                "currentDay": currentDay
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
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let data = document.data() {
                        print("Document data: \(data)")
    
                        if let calorie = data["calorie"],let isAdviced = data["adviced"], let manuelCalorie = data["calorieGoal"]{
                            DispatchQueue.main.async {
                                if isAdviced as! Bool {
                                    self.totalCal = calorie as? Int ?? 0
                                }
                                else{
                                    self.totalCal = manuelCalorie as? Int ?? 0
                                }
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
                                    let x = currentDay as? Int ?? 0
                                    if self.currentDay != x{
                                        self.resetData()
                                    }
                                }
                                self.fillCalLabels()
                            }
                        }
                    }
                } else {
                    print("Document does not exist.")
                }
            }
        }
    }
    
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
} // ends of MainViewController

