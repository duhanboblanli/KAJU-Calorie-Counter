//
//  ProfileViewController.swift
//  KAJU
//
//  Created by kadir on 14.02.2023.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let backGroundColor = ThemesOptions.backGroundColor
    var optionList: [ProfileOption] = []
    let tableView = UITableView()
    let tableTitle = {
        let label = UILabel()
        label.text = "Settings"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionList = fetchData()
        linkViews()
        configureView()
        configureTableView()
        configureLayout()
    }
    
    func linkViews(){
        view.addSubview(tableTitle)
        view.addSubview(tableView)
    }
    
    func configureView(){
        view.backgroundColor = backGroundColor
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func configureLayout(){
        tableTitle.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: tableView.topAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        tableView.anchor(top: tableTitle.bottomAnchor, left: tableTitle.leftAnchor, bottom: view.bottomAnchor, right: tableTitle.rightAnchor)
    }
    
    func configureTableView(){
        setTableViewDelegates()
        tableView.backgroundColor = backGroundColor
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        tableView.rowHeight = 64
    }
    
    func setTableViewDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier) as! SettingsCell
        let settingOption = optionList[indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.setSetting(setting: settingOption)
        cell.backgroundColor = backGroundColor
        cell.tintColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
        case 0:
            navigationController?.pushViewController(AccountSettingsController(), animated: true)
            
        case 1:
            navigationController?.pushViewController(ProfileSettingsController(), animated: true)
            
        case 2:
            navigationController?.pushViewController(MyGoalSettingsController(), animated: true)
            
        case 3:
            navigationController?.pushViewController(AboutUsController(), animated: true)
            
        default:
            print("ERROR!")
        }
    }
}

extension SettingsViewController {
    func fetchData() -> [ProfileOption]{
        let option1 = ProfileOption(image: UIImage(systemName: "lock.fill") ?? UIImage(), title: "Account")
        let option2 = ProfileOption(image: UIImage(systemName: "person.circle.fill") ?? UIImage(), title: "Profile")
        let option3 = ProfileOption(image: UIImage(systemName: "flag.fill") ?? UIImage(), title: "My Goals")
        let option4 = ProfileOption(image: UIImage(systemName: "questionmark.app.fill") ?? UIImage(), title: "About Us")

        return[option1, option2, option3, option4]
    }
}

