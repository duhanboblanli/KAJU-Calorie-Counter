//
//  ProfileSettingsControllerViewController.swift
//  KAJU
//
//  Created by kadir on 15.02.2023.
//

import UIKit
import DropDown

final class ProfileSettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var nameValue: String!
    private var genderValue: String!
    private var diaterValue: String!
    private var heightValue: String!
    private let backGroundColor = ThemesOptions.backGroundColor
    private let cellBackgColor = ThemesOptions.cellBackgColor
    private var profileSettingModels: [SettingModel] = []

    // MARK: -UI ELEMENTS
    private lazy var tableView: UITableView = UITableView()
    
    private lazy var tableTitle = {
        let label = UILabel()
        label.text = "Profile Settings".localized()
        label.font = UIFont(name: "Copperplate Bold", size: 33)
        label.textColor = .white
        return label
    }()
    
    // MARK: -INIT-CONTROLLER
    init(nameValue: String!, genderValue: String!, diaterValue: String!, heightValue: String!) {
        super.init(nibName: nil, bundle: nil)
        self.nameValue = nameValue
        self.genderValue = genderValue
        self.diaterValue = diaterValue
        self.heightValue = heightValue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        profileSettingModels = fetcData()
        linkViews()
        configureView()
        layoutViews()
        delegateTableView()
    }
    
    // MARK: -VIEWS CONNECTION
    func linkViews(){
        view.backgroundColor = backGroundColor
        view.addSubview(tableView)
        view.addSubview(tableTitle)
    }
    
    // MARK: -CONFIGURATION
    func delegateTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureView(){
        tableView.register(ProfileSettingsCell.self, forCellReuseIdentifier: ProfileSettingsCell.identifier)
        tableView.backgroundColor = backGroundColor
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: -LAYOUT
    func layoutViews(){
        tableTitle
            .anchor(top: view.safeAreaLayoutGuide.topAnchor,
                    left: view.leftAnchor,
                    bottom: tableView.topAnchor,
                    right: view.rightAnchor,
                    paddingTop: 32,
                    paddingLeft: 16,
                    paddingBottom: 16,
                    paddingRight: 16)
        
        tableView
            .anchor(top: tableTitle.bottomAnchor,
                    left: tableTitle.leftAnchor,
                    bottom: view.safeAreaLayoutGuide.bottomAnchor,
                    right: tableTitle.rightAnchor)
    }
    
    // MARK: -TABLEVIEW FUNCTIONS
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
// MARK: -DATA FETCH
extension ProfileSettingsController {
    func fetcData() -> [SettingModel]{
        let profileSetting1 = SettingModel(textLabel: "Name".localized(), textValue: nameValue)
        let profileSetting2 = SettingModel(textLabel: "Gender".localized(), textValue: genderValue)
        let profileSetting3 = SettingModel(textLabel: "Dietary".localized(), textValue: diaterValue)
        let profileSetting4 = SettingModel(textLabel: "Height".localized(), textValue: heightValue)
        
        return [profileSetting1, profileSetting2, profileSetting3, profileSetting4]
    }
}



