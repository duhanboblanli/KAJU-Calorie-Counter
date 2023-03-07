//
//  ProfileViewController.swift
//  KAJU
//
//  Created by kadir on 20.02.2023.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var profile: ProfileCellModel!
    var goal: GoalCellModel!
    let table: UITableView = UITableView()
    let backGroundColor = ThemesOptions.backGroundColor
    let cellBackgColor = ThemesOptions.cellBackgColor
    let tableTitle = {
        let label = UILabel()
        label.text = "Profile"
        label.font = UIFont.boldSystemFont(ofSize: 36)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        profile = fetchProfileData()
        goal = fetchGoalData()
        linkViews()
        configureView()
        configureTableView()
        configureLayout()
    }
    
    func linkViews(){
        view.backgroundColor = backGroundColor
        view.addSubview(table)
        view.addSubview(tableTitle)
    }
    
    func configureView(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingsButtonTapped))
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = ThemesOptions.buttonBackGColor
        navigationItem.largeTitleDisplayMode = .never
    }
    
    @objc func settingsButtonTapped() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    func configureLayout(){
        tableTitle.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 16, paddingRight: 16)
        table.anchor(top: tableTitle.bottomAnchor, left: tableTitle.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: tableTitle.rightAnchor, paddingBottom: 8)
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
            profileCell.setProfile(model: profile)
            profileCell.selectionStyle = UITableViewCell.SelectionStyle.none
            profileCell.tintColor = backGroundColor
            return profileCell
        case 1:
            goalCell.backgroundColor = cellBackgColor.withAlphaComponent(0.6)
            goalCell.layer.cornerRadius = 20
            goalCell.myViewController = self
            goalCell.selectionStyle = UITableViewCell.SelectionStyle.none
            goalCell.setGoalCell(model: goal)
            return goalCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            navigationController?.pushViewController(ProfileSettingsController(), animated: true)
        default:
            return
        }
    }
}

extension ProfileViewController {
    func fetchProfileData() -> ProfileCellModel {
        let profile = ProfileCellModel(profileImage: UIImage(named: "ProfileImage") ?? UIImage(), name: "Abdulkadir Çopur", gender: "Male", diateryType: "Vegetarian")
        
        return profile
    }
    
    func fetchGoalData() -> GoalCellModel {
        let goal = GoalCellModel(goalType: "Build Muscle", weight: "65", calories: "2,543")
        
        return goal
    }
}

