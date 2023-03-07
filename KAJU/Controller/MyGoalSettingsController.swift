//
//  MyGoalSettingsController.swift
//  KAJU
//
//  Created by kadir on 28.02.2023.
//

import UIKit

class MyGoalSettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView = UITableView()
    let viewTitle = {
        let label = UILabel()
        label.text = "My Goal Settings"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    let backGroundColor = ThemesOptions.backGroundColor
    let cellBackgColor = ThemesOptions.cellBackgColor
    var goalSettingModels: [SettingModel] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        goalSettingModels = fetcData()
        linkViews()
        delegateTableView()
        configureView()
        configureLayout()

    }
    
    func linkViews(){
        view.addSubview(viewTitle)
        view.addSubview(tableView)
    }
    
    func delegateTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyGoalSettingCell.self, forCellReuseIdentifier: MyGoalSettingCell.identifier)
        tableView.backgroundColor = backGroundColor
    }
    
    func configureView(){
        view.backgroundColor = backGroundColor
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func configureLayout(){
        viewTitle.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: tableView.topAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        tableView.anchor(top: viewTitle.bottomAnchor, left: viewTitle.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: viewTitle.rightAnchor)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goalSettingModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyGoalSettingCell.identifier) as! MyGoalSettingCell
        cell.backgroundColor = backGroundColor
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.myViewController = self
        cell.setProfileSetting(model: goalSettingModels[indexPath.row])
        return cell
    }

}

extension MyGoalSettingsController {
    func fetcData() -> [SettingModel]{
        let goalSetting1 = SettingModel(textLabel: "Goal", textValue: "Build Muscle")
        let goalSetting2 = SettingModel(textLabel: "Starting Weight", textValue: "65")
        let goalSetting3 = SettingModel(textLabel: "Goal Weight", textValue: "70")
        let goalSetting4 = SettingModel(textLabel: "Activity Level", textValue: "Moderate")
        let goalSetting5 = SettingModel(textLabel: "Weekly Goal", textValue: "0.5")
        let goalSetting6 = SettingModel(textLabel: "Calory Goal", textValue: "2800")
        
        return [goalSetting1, goalSetting2, goalSetting3, goalSetting4, goalSetting5, goalSetting6]
    }
}
