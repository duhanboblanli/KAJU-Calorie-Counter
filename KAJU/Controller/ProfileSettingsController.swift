//
//  ProfileSettingsControllerViewController.swift
//  KAJU
//
//  Created by kadir on 15.02.2023.
//

import UIKit
import DropDown

class ProfileSettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView = UITableView()
    let tableTitle = {
        let label = UILabel()
        label.text = "Profile Settings"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    let backGroundColor = ThemesOptions.backGroundColor
    let cellBackgColor = ThemesOptions.cellBackgColor
    var profileSettingModels: [SettingModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        profileSettingModels = fetcData()
        linkViews()
        configureView()
        layoutViews()
        delegateTableView()
    }
    
    func delegateTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func linkViews(){
        view.backgroundColor = backGroundColor
        view.addSubview(tableView)
        view.addSubview(tableTitle)
    }
    
    func configureView(){
        tableView.register(ProfileSettingsCell.self, forCellReuseIdentifier: ProfileSettingsCell.identifier)
        tableView.backgroundColor = backGroundColor
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func layoutViews(){
        tableTitle.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: tableView.topAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        tableView.anchor(top: tableTitle.bottomAnchor, left: tableTitle.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: tableTitle.rightAnchor)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSettingModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSettingsCell.identifier) as! ProfileSettingsCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = backGroundColor
        cell.myViewController = self
        cell.setProfileSetting(model: profileSettingModels[indexPath.row])
        return cell
    }
}

extension ProfileSettingsController {
    func fetcData() -> [SettingModel]{
        let profileSetting1 = SettingModel(textLabel: "Name", textValue: "Kadir Çopur")
        let profileSetting2 = SettingModel(textLabel: "Gender", textValue: "Male")
        let profileSetting3 = SettingModel(textLabel: "Dieatary", textValue: "Classic")
        let profileSetting4 = SettingModel(textLabel: "Height", textValue: "175")
        
        return [profileSetting1, profileSetting2, profileSetting3, profileSetting4]
    }
}

