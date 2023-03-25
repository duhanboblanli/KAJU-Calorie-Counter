//
//  AccountSettingsController.swift
//  KAJU
//
//  Created by kadir on 3.03.2023.
//

import UIKit
import DropDown
import FirebaseAuth
import FirebaseFirestore

class AccountSettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let db = DatabaseSingleton.db
    private var userPassword = UserDefaults.standard.string(forKey: Auth.auth().currentUser?.email ?? "")
    private var userEmail = Auth.auth().currentUser?.email
    var accountSettingModels: [SettingModel] = []
    let resetOptions = ["Delete", "Reset"]
    var dropDown = ThemesOptions.dropDown
    let backGroundColor = ThemesOptions.backGroundColor
    let cellBackgColor = ThemesOptions.cellBackgColor
    let tableView: UITableView = UITableView()
    
    let tableTitle = {
        let label = UILabel()
        label.text = "Account Settings"
        label.font = UIFont(name: "Copperplate Bold", size: 33)
        return label
    }()
    let resetButton = {
        let button = UIButton()
        button.setTitle("Reset", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.backgroundColor = ThemesOptions.buttonBackGColor
        button.layer.cornerRadius = 20
        return button
    }()
    let resetButtonImage = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .white
        return imageView
    }()
    let logOutButton = {
        let button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.backgroundColor = ThemesOptions.buttonBackGColor
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
        showSimpleAlert()
    }
    
    func showSimpleAlert() {
        let alert = UIAlertController(title: "Are you sure you want to Log Out ?", message: nil,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            }))
            alert.addAction(UIAlertAction(title: "Log Out",
                                          style: UIAlertAction.Style.destructive,
                                          handler: {(_: UIAlertAction!) in
                let auth = Auth.auth()
                //Sign out action
                do {
                    try auth.signOut()
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let rootViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "nRoot")
                    self.view.window?.rootViewController = rootViewController
                    self.navigationController?.popToRootViewController(animated: true)

                }catch _{}
            }))
        self.present(alert, animated: true, completion: nil)
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
        let accountSetting1 = SettingModel(textLabel: "Email Adress", textValue: userEmail ?? "hello@gmail.com")
        let accountSetting2 = SettingModel(textLabel: "Password", textValue: userPassword ?? "")
        return [accountSetting1, accountSetting2]
    }
}
