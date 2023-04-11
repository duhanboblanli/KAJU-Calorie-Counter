//
//  Editor.swift
//  KAJU
//
//  Created by kadir on 2.03.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class Editor: UIViewController {
    
    private var startFromZero = false
    private let db = DatabaseSingleton.db
    private let backGroundColor = ThemesOptions.backGroundColor
    private let cellBackgColor = ThemesOptions.cellBackgColor
    
    // MARK: -UI ELEMENTS
    private var textLabel: UILabel!
    private var textValue: UILabel!
    
    private lazy var contentView = {
        let view = UIView()
        let width = CGFloat(275)
        let height = CGFloat(200)
        view.anchor(width: width, height: height)
        view.backgroundColor = ThemesOptions.backGroundColor
        view.layer.cornerRadius = 10
        return view
    }()
    private lazy var titleLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    private lazy var textField = {
        let textField = UITextField()
        let height = CGFloat(44)
        textField.anchor(height: height)
        textField.borderStyle = .roundedRect
        textField.textColor = .systemGray
        textField.backgroundColor = ThemesOptions.cellBackgColor
        return textField
    }()
    private lazy var doneButton = {
        let button = UIButton()
        let width = CGFloat(76)
        let height = CGFloat(40)
        button.anchor(width: width, height: height)
        button.setTitle("Done".localized(), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = ThemesOptions.buttonBackGColor
        button.layer.cornerRadius = 20
        return button
    }()
    private lazy var cancelButton = {
        let button = UIButton()
        let width = CGFloat(88)
        let height = CGFloat(40)
        button.anchor(width: width, height: height)
        button.setTitle("Cancel".localized(), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = ThemesOptions.buttonBackGColor
        button.layer.cornerRadius = 20
        return button
    }()
    
    // MARK: -INIT-CONTROLLER
    init(textLabel: UILabel, textValue: UILabel) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        self.textLabel = textLabel
        self.textValue = textValue
    }
    
    init(textLabel: UILabel, textValue: UILabel, zero: Bool) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        self.textLabel = textLabel
        self.textValue = textValue
        self.startFromZero = zero
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        linkViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !startFromZero{
            textField.text = textValue.text
        }
        else{
            textField.text = ""
        }
        
        let isInt = Float(textValue.text ?? "") ?? nil
        if(isInt != nil){textField.keyboardType = .numberPad}
        configureView()
        configureLayout()
    }
    
    // MARK: -VIEWS CONNNECTION
    func linkViews(){
        view.backgroundColor = .black.withAlphaComponent(0.8)
        view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        contentView.addSubview(doneButton)
        contentView.addSubview(cancelButton)
    }
    
    // MARK: -CONFIGURATION
    func configureView(){
        titleLabel.text = textLabel.text
        doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    }
    
    // MARK: -FUNCTIONS
   @objc func done(){
       switch textLabel.text {
       case "Name".localized():
           setAttrValue(key: "name", value: textField.text ?? "")
           self.dismiss(animated: true)
       case "Height".localized():
           setAttrValue(key: "height", value: Int(textField.text ?? "") ?? 0)
           self.dismiss(animated: true)
       case "Starting Weight".localized():
           setAttrValue(key: "weight", value: Double(textField.text ?? "") ?? 0)
           self.dismiss(animated: true)
       case "Goal Weight".localized():
           setAttrValue(key: "goalWeight", value: Double(textField.text ?? "") ?? 0)
           self.dismiss(animated: true)
       case "Weekly Goal".localized():
           setAttrValue(key: "weeklyGoal", value: Double(textField.text ?? "") ?? 0)
           self.dismiss(animated: true)
       case "Calorie Goal".localized():
           setAttrValue(key: "calorieGoal", value: Int(textField.text ?? "") ?? 0)
           updateDBValue(key: "adviced", value: false)
           self.dismiss(animated: true)
       default:
           return
       }
    }
    
    func updateDBValue(key: String, value: Any){
        if let currentUserEmail = Auth.auth().currentUser?.email {
            let docRef = DatabaseSingleton.db.collection("UserInformations").document("\(currentUserEmail)")
            docRef.updateData([key: value])
        }
    }
    func setAttrValue(key: String, value: Any){
        if key != "calorieGoal"{
            textValue.text = textField.text
        }else{
            textValue.text = "Manuel"
        }
        
        if let currentUserEmail = Auth.auth().currentUser?.email {
            let docRef = db.collection("UserInformations").document("\(currentUserEmail)")
            docRef.updateData([key: value])
        }
    }
    
    @objc func cancel(){
        self.dismiss(animated: true)
    }
    
    // MARK: -LAYOUT
    func configureLayout(){
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        titleLabel
            .anchor(top: contentView.topAnchor,
                    left: contentView.leftAnchor,
                    right: contentView.rightAnchor,
                    paddingTop: 24,
                    paddingLeft: 24,
                    paddingRight: 16)
        
        textField
            .anchor(top: titleLabel.bottomAnchor,
                    left: titleLabel.leftAnchor,
                    right: contentView.rightAnchor,
                    paddingTop: 16,
                    paddingRight: 24)
        
        cancelButton
            .anchor(top: textField.bottomAnchor,
                    left: contentView.leftAnchor,
                    bottom: contentView.bottomAnchor,
                    paddingTop: 24,
                    paddingLeft: 32,
                    paddingBottom: 16)
        
        doneButton
            .anchor(top: cancelButton.topAnchor,
                    bottom: cancelButton.bottomAnchor,
                    right: contentView.rightAnchor,
                    paddingLeft: 32,
                    paddingRight: 32)
    }
}



