//
//  ProfileViewController.swift
//  KAJU
//
//  Created by kadir on 20.02.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore



class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {



    let db = DatabaseSingleton.db
    var profile: ProfileCellModel?
    var goal: GoalCellModel?
    let table: UITableView = UITableView()
    let backGroundColor = ThemesOptions.backGroundColor
    let cellBackgColor = ThemesOptions.cellBackgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRealTimeUpdate()
        fetchProfileData()
        linkViews()
        configureTableView()
        configureView()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func addRealTimeUpdate(){
        if let currentUserEmail = Auth.auth().currentUser?.email {
            db.collection("UserInformations").document("\(currentUserEmail)")
                .addSnapshotListener { documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    guard let data = document.data() else {
                        print("Document data was empty.")
                        return
                    }
                    print("Current data: \(data)")
                    self.checkProfileSettingsUpdate(data: data)
                    self.checkGoalSetttingsUpdate(data: data)
                    self.table.reloadData()
                }
        }
    }
    
    
    func checkProfileSettingsUpdate (data: Dictionary<String, Any>){
        if let name = data["name"]{self.profile?.name = name as? String ?? ""}
        if let height = data["height"]{self.profile?.height = "\(height)"}
        if let diateryType = data["diateryType"]{self.profile?.diateryType = diateryType as? String ?? ""}
        if let sex = data["sex"]{self.profile?.sex = sex as? String ?? ""}
    }
    
    func checkGoalSetttingsUpdate(data: Dictionary<String, Any>){
        updateCalorie(data: data)
        if let goalType = data["goalType"]{self.goal?.goalType = goalType as? String ?? ""}
        if let manuelCalorie = data["calorieGoal"]{self.goal?.manuelCalorieGoal = "\(manuelCalorie)"}
        if let advicedCalorie = data["calorie"]{self.goal?.advicedCalorieGoal = "\(advicedCalorie)"}
        if let isAdviced = data["adviced"]{self.goal?.isAdviced = isAdviced as! Bool}
        
        
        if let weight = data["weight"]{
            let weightWrapped = weight as? Double ?? 0
            self.goal?.weight = String(format: "%.2f", weightWrapped)
        }
    }
    func updateDBValue(key: String, value: Any){
        if let currentUserEmail = Auth.auth().currentUser?.email {
            let docRef = DatabaseSingleton.db.collection("UserInformations").document("\(currentUserEmail)")
            docRef.updateData([key: value])
        }
    }
    func updateCalorie(data: Dictionary<String, Any>){
        
        var calculator = CalculatorBrain()
        calculator.calculateCalorie(data["sex"] as! String,data["weight"] as! Float,data["height"] as! Float,data["age"] as! Float,data["bmh"] as! Float,data["changeCalorieAmount"] as! Int)
        updateDBValue(key: "calorie", value: Int(calculator.getCalorie()))
    }
    
    func linkViews(){
        view.backgroundColor = backGroundColor
        view.addSubview(table)
    }
    
    func configureView(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingsButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.largeTitleDisplayMode = .never
    }
    
    @objc func settingsButtonTapped() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    func configureLayout(){
        table.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,paddingTop: 32,paddingLeft: 16 ,paddingBottom: 8, paddingRight: 16)
    }
    
    func configureTableView(){
        table.delegate = self
        table.dataSource = self
        table.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.identifier)
        table.register(MyGoalCell.self, forCellReuseIdentifier: MyGoalCell.identifier)
        table.backgroundColor = backGroundColor
        table.tableHeaderView?.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileCell = table.dequeueReusableCell(withIdentifier: ProfileCell.identifier) as! ProfileCell
        let goalCell = table.dequeueReusableCell(withIdentifier: MyGoalCell.identifier) as! MyGoalCell
        
        switch indexPath.section {
        case 0:
            profileCell.layer.cornerRadius = 20
            profileCell.myViewController = self
            profileCell.selectionStyle = UITableViewCell.SelectionStyle.none
            profileCell.tintColor = backGroundColor
            profileCell.setProfile(model: self.profile ?? ProfileCellModel(profileImage: UIImage(named: "defaultProfilePhoto") ?? UIImage(), name: "", sex: "", diateryType: "", height: ""))
            return profileCell
        case 1:
            goalCell.backgroundColor = cellBackgColor
            goalCell.layer.cornerRadius = 20
            goalCell.myViewController = self
            goalCell.selectionStyle = UITableViewCell.SelectionStyle.none
            goalCell.setGoalCell(model: self.goal ?? GoalCellModel(goalType: "", weight: "", activeness: "", goalWeight: "", weeklyGoal: "", manuelCalorieGoal: "", advicedCalorieGoal: "", isAdviced: true))
            return goalCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            navigationController?.pushViewController(ProfileCell.myProfileSettings, animated: true)
        default:
            return
        }
    }
}

extension ProfileViewController {
    func fetchProfileData() {
        if let currentUserEmail = Auth.auth().currentUser?.email {
            let docRef = db.collection("UserInformations").document("\(currentUserEmail)")
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let data = document.data() {
                        print("Document data: \(data)")
                        if let goalType = data["goalType"],
                           let weight = data["weight"],
                           let calorie = data["calorie"],
                           let sex = data["sex"],
                           let bmh = data["bmh"],
                           let isAdviced = data["adviced"],
                           let weeklyGoal = data["weeklyGoal"],
                           let goalWeight = data["goalWeight"],
                           let caloryGoal = data["calorieGoal"],
                           let height = data["height"]{
                            let weightWrapped = weight as? Double ?? 0
                            var activeness: String = "Moderate"
                            switch bmh as? Float{
                            case 1.2: activeness = "Low"
                            case 1.3: activeness = "Moderate"
                            case 1.4: activeness = "High"
                            case 1.5: activeness = "Very High"
                            default: print("Error happened while choosing activeness")
                            }
                            self.goal = GoalCellModel(goalType: "\(goalType)", weight: String(format: "%.2f", weightWrapped), activeness: "\(activeness)", goalWeight: "\(goalWeight)" , weeklyGoal: "\(weeklyGoal)",manuelCalorieGoal: "\(caloryGoal)", advicedCalorieGoal: "\(calorie)", isAdviced: isAdviced as! Bool)
                            self.profile = ProfileCellModel(profileImage: UIImage(named: "defaultProfilePhoto") ?? UIImage(), name: data["name"] as? String ?? "Enter a name", sex: "\(sex)", diateryType: data["diateryType"] as? String ?? "Classic", height: "\(height)")
                            self.table.reloadData()
                        }
                    }
                } else { print("Document does not exist.")}
            }
        }
    }
}




