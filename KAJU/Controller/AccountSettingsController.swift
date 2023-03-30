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
import CoreData

class AccountSettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let user = Auth.auth().currentUser
    let db = DatabaseSingleton.db
    private var userPassword = UserDefaults.standard.string(forKey: Auth.auth().currentUser?.email ?? "")
    private var userEmail = Auth.auth().currentUser?.email
    var accountSettingModels: [SettingModel] = []
    let backGroundColor = ThemesOptions.backGroundColor
    let cellBackgColor = ThemesOptions.cellBackgColor
    let tableView: UITableView = UITableView()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let tableTitle = {
        let label = UILabel()
        label.text = "Account Settings"
        label.textColor = .white
        label.font = UIFont(name: "Copperplate Bold", size: 33)
        return label
    }()
    let deleteButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.backgroundColor = ThemesOptions.buttonBackGColor
        button.layer.cornerRadius = 20
        return button
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
        view.addSubview(deleteButton)
        view.addSubview(logOutButton)
    }
    
    func configureView(){
        view.backgroundColor = backGroundColor
        navigationItem.largeTitleDisplayMode = .never
        deleteButton.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
        logOutButton.addTarget(self, action: #selector(logOutAccount), for: .touchUpInside)
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AccountSettingCell.self, forCellReuseIdentifier: AccountSettingCell.identifier)
        tableView.backgroundColor = backGroundColor
    }
    
    @objc func deleteAccount(){
        showSimpleAlert(title: "Are you sure you want to Delete ? ", firstResponse: "Cancel", secondResponse: "Delete")
    }
    
    @objc func logOutAccount(){
        showSimpleAlert(title: "Are you sure you want to Log Out ?", firstResponse: "Cancel", secondResponse: "Log Out")
    }
    
    func showSimpleAlert(title: String, firstResponse: String, secondResponse: String) {
        let alert = UIAlertController(title: title, message: "Your offline data that consisting of favorite foods, recent foods and favorite recipes will be gone!",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: firstResponse, style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            }))
            alert.addAction(UIAlertAction(title: secondResponse,
                                          style: UIAlertAction.Style.destructive,
                                          handler: {(_: UIAlertAction!) in
                switch secondResponse {
                case "Log Out":
                    self.logOut()
                case "Delete":
                    self.delete()
                default:
                    return
                }
            }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func delete(){
     
        self.user!.delete { error in
          if let error = error {
              let alert = UIAlertController(title: "Deletion unsuccessfull!", message: "Sorry for inconvenience situation. Deletion of an account is sensitive process. You should be re-sign into your account.", preferredStyle: UIAlertController.Style.alert)
              alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
              self.present(alert, animated: true, completion: nil)
            
              print(error)
          } else {
            // Account deleted.
              self.deleteAllOnlineData()
              self.deleteAllOfflineData()
              let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
              let rootViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "nRoot")
              self.view.window?.rootViewController = rootViewController
              self.navigationController?.popToRootViewController(animated: true)
          }
        }
    }
    
    func logOut(){
        let auth = Auth.auth()
        //Sign out action
        do {
            deleteAllOfflineData()
            try auth.signOut()
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let rootViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "nRoot")
            self.view.window?.rootViewController = rootViewController
            self.navigationController?.popToRootViewController(animated: true)

        }catch _{}
    }
    
    func deleteAllOnlineData(){
        if let currentUserEmail = Auth.auth().currentUser?.email {
            let docRef = db.collection("UserInformations").document("\(currentUserEmail)")
            docRef.delete()
        }
    }
    
    func deleteAllOfflineData(){
        let context1 = self.appDelegate.persistentContainer
        let context2 = self.appDelegate.persistentContainer2
        let context3 = self.appDelegate.persistentContainer3
        deleteOfflineData("FoodRecipe", context1)
        deleteOfflineData("FoodEntity", context2)
        deleteOfflineData("FavFoodEntity", context3)
    }
    func deleteOfflineData(_ entity:String,_ container: NSPersistentContainer) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                container.viewContext.delete(objectData)
            }
            try? container.viewContext.save()
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
        
    func configureLayout(){
        tableTitle.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: tableView.topAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        tableView.anchor(top: tableTitle.bottomAnchor, left: tableTitle.leftAnchor, bottom: deleteButton.topAnchor, right: tableTitle.rightAnchor)
        deleteButton.anchor(width: 256, height: 48)
        deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logOutButton.anchor(top: deleteButton.bottomAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingTop: 32, paddingBottom: 32, width: 256, height: 48)
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
        let accountSetting1 = SettingModel(textLabel: "Email Adress", textValue: userEmail ?? "")
        let accountSetting2 = SettingModel(textLabel: "Password", textValue: userPassword ?? "")
        return [accountSetting1, accountSetting2]
    }
}

