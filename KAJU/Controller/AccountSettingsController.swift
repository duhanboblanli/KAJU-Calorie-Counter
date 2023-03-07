//
//  AccountSettingsController.swift
//  KAJU
//
//  Created by kadir on 3.03.2023.
//

import UIKit
import DropDown

class AccountSettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var accountSettingModels: [SettingModel] = []
    let resetOptions = ["Delete", "Reset"]
    var dropDown = ThemesOptions.dropDown
    let backGroundColor = ThemesOptions.backGroundColor
    let cellBackgColor = ThemesOptions.cellBackgColor
    let tableView: UITableView = UITableView()
    
    let tableTitle = {
        let label = UILabel()
        label.text = "Account Settings"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    let resetButton = {
        let button = UIButton()
        button.setTitle("Reset", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.backgroundColor = ThemesOptions.cellBackgColor
        button.layer.cornerRadius = 20
        return button
    }()
    let resetButtonImage = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = ThemesOptions.figureColor
        return imageView
    }()
    let logOutButton = {
        let button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.backgroundColor = ThemesOptions.cellBackgColor
        button.layer.cornerRadius = 20
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        accountSettingModels = fetcData()
        linkViews()
        configureView()
        configureTableView()
        configureLayout()
    }
    
    func linkViews(){
        view.addSubview(tableView)
        view.addSubview(tableTitle)
        view.addSubview(resetButton)
        view.addSubview(logOutButton)
        resetButton.addSubview(resetButtonImage)
    }
    
    func configureView(){
        view.backgroundColor = backGroundColor
        navigationItem.largeTitleDisplayMode = .never
        resetButton.addTarget(self, action: #selector(resetAccount), for: .touchUpInside)
        logOutButton.addTarget(self, action: #selector(logOutAccount), for: .touchUpInside)
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AccountSettingCell.self, forCellReuseIdentifier: AccountSettingCell.identifier)
        tableView.backgroundColor = backGroundColor
    }
    
    @objc func resetAccount(){
        dropDown = setDropDown(dataSource: resetOptions, anchorView: resetButton, bottomOffset: CGPoint(x: 0, y:(resetButton.plainView.bounds.height ) + 8))
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
        }
    }
    
    @objc func logOutAccount(){
        
    }
    
    func configureLayout(){
        tableTitle.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: tableView.topAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        tableView.anchor(top: tableTitle.bottomAnchor, left: tableTitle.leftAnchor, bottom: resetButton.topAnchor, right: tableTitle.rightAnchor)
        resetButton.anchor(width: 256, height: 48)
        resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resetButtonImage.anchor(right: resetButton.rightAnchor, paddingRight: 32, width: 20, height: 20)
        resetButtonImage.centerYAnchor.constraint(equalTo: resetButton.centerYAnchor).isActive = true
        logOutButton.anchor(top: resetButton.bottomAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingTop: 32, paddingBottom: 32, width: 256, height: 48)
        logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        accountSettingModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountSettingCell.identifier) as! AccountSettingCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = backGroundColor
        cell.myViewController = self
        cell.setAccountSettings(model: accountSettingModels[indexPath.row])
        return cell
    }

}

extension AccountSettingsController {
    func fetcData() -> [SettingModel]{
        let accountSetting1 = SettingModel(textLabel: "Email Adress", textValue: "hello@gmail.com")
        let accountSetting2 = SettingModel(textLabel: "Password", textValue: "12345")

        return [accountSetting1, accountSetting2]
    }
}
