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
        linkViews()
        addRealTimeUpdate()
        fetchProfileData()
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
        if let goalType = data["goalType"]{self.goal?.goalType = goalType as? String ?? ""}
        if let calorie = data["calorie"]{self.goal?.calorie = "\(calorie)"}
        if let weight = data["weight"]{self.goal?.weight = "\(weight)"}
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
            DispatchQueue.main.async { profileCell.setProfile(model: self.profile ?? ProfileCellModel(profileImage: UIImage(), name: "", sex: "", diateryType: "", height: ""))}
            return profileCell
        case 1:
            goalCell.backgroundColor = cellBackgColor
            goalCell.layer.cornerRadius = 20
            goalCell.myViewController = self
            goalCell.selectionStyle = UITableViewCell.SelectionStyle.none
            DispatchQueue.main.async { goalCell.setGoalCell(model: self.goal ?? GoalCellModel(goalType: "", weight: "", calorie: ""))}
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
                            let gender = data["sex"],
                            let height = data["height"]{
                                let goalTypeUnwrapped = goalType as? String ?? ""
                                let weightUnwrapped = weight as? Int ?? 0
                                let calorieUnwrapped = calorie as? Int ?? 0
                                self.goal = GoalCellModel(goalType: goalTypeUnwrapped, weight: "\(weightUnwrapped)", calorie: "\(calorieUnwrapped)")
                                self.profile = ProfileCellModel(profileImage: UIImage(named:"defaultProfilePhoto") ?? UIImage(), name: "Enter name", sex: gender as! String, diateryType: "Vegetarian", height: "\(height)")
                            }
                    }
                } else { print("Document does not exist.")}
            }
        }
    }
}




