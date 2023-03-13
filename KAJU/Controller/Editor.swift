//
//  Editor.swift
//  KAJU
//
//  Created by kadir on 2.03.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class Editor: UIViewController {
    
    let db = DatabaseSingleton.db
    let backGroundColor = ThemesOptions.backGroundColor
    let cellBackgColor = ThemesOptions.cellBackgColor
    var eyeButton: UIButton?
    var textLabel: UILabel!
    var textValue: UILabel!
    
    let contentView = {
        let view = UIView()
        let width = CGFloat(275)
        let height = CGFloat(200)
        view.anchor(width: width, height: height)
        view.backgroundColor = ThemesOptions.backGroundColor
        view.layer.cornerRadius = 10
        return view
    }()
    let titleLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28)
        return label
    }()
    let textField = {
        let textField = UITextField()
        let height = CGFloat(44)
        textField.anchor(height: height)
        textField.borderStyle = .roundedRect
        textField.textColor = .systemGray
        textField.backgroundColor = ThemesOptions.cellBackgColor
        return textField
    }()
    let doneButton = {
        let button = UIButton()
        let width = CGFloat(76)
        let height = CGFloat(40)
        button.anchor(width: width, height: height)
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)

        button.backgroundColor = ThemesOptions.buttonBackGColor
        button.layer.cornerRadius = 20
        return button
    }()
    let cancelButton = {
        let button = UIButton()
        let width = CGFloat(88)
        let height = CGFloat(40)
        button.anchor(width: width, height: height)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = ThemesOptions.buttonBackGColor
        button.layer.cornerRadius = 20
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.text = textValue.text
        let isInt = Float(textValue.text ?? "") ?? nil
        if(isInt != nil){textField.keyboardType = .numberPad}
        configureView()
        configureLayout()
    }
    
    init(textLabel: UILabel, textValue: UILabel) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        self.textLabel = textLabel
        self.textValue = textValue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func linkViews(){
        view.backgroundColor = .black.withAlphaComponent(0.8)
        view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        contentView.addSubview(doneButton)
        contentView.addSubview(cancelButton)
    }
    
    func configureView(){
        titleLabel.text = textLabel.text
        doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    }
    
   @objc func done(){
       switch textLabel.text {
       case "Name":
           setAttrValue(key: "name", value: textField.text ?? "")
           self.dismiss(animated: true)
       case "Height":
           setAttrValue(key: "height", value: Int(textField.text ?? "") ?? 0)
           self.dismiss(animated: true)
       case "Starting Weight":
           setAttrValue(key: "weight", value: Double(textField.text ?? "") ?? 0)
           self.dismiss(animated: true)
       case "Goal Weight":
           setAttrValue(key: "goalWeight", value: Double(textField.text ?? "") ?? 0)
           self.dismiss(animated: true)
       case "Weekly Goal":
           setAttrValue(key: "weeklyGoal", value: Double(textField.text ?? "") ?? 0)
           self.dismiss(animated: true)
       case "Calory Goal":
           setAttrValue(key: "caloryGoal", value: Int(textField.text ?? "") ?? 0)
           self.dismiss(animated: true)
       default:
           return
       }
    }
    
    func setAttrValue(key: String, value: Any){
        textValue.text = textField.text
        if let currentUserEmail = Auth.auth().currentUser?.email {
            let docRef = db.collection("UserInformations").document("\(currentUserEmail)")
            docRef.updateData([key: value])
        }
    }
    
    @objc func cancel(){
        self.dismiss(animated: true)
    }
    
    func configureLayout(){
        
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        titleLabel.anchor(top: contentView.topAnchor,
                          left: contentView.leftAnchor,
                          right: contentView.rightAnchor,
                          paddingTop: 24,
                          paddingLeft: 24,
                          paddingRight: 16)
        
        textField.anchor(top: titleLabel.bottomAnchor,
                         left: titleLabel.leftAnchor,
                         right: eyeButton?.leftAnchor ?? contentView.rightAnchor,
                         paddingTop: 16,
                         paddingRight: 24)
        
        cancelButton.anchor(top: textField.bottomAnchor,
                            left: contentView.leftAnchor,
                            bottom: contentView.bottomAnchor,
                            paddingTop: 24,
                            paddingLeft: 32,
                            paddingBottom: 16)
        doneButton.anchor(top: cancelButton.topAnchor,
                          bottom: cancelButton.bottomAnchor,
                          right: contentView.rightAnchor,
                          paddingLeft: 32,
                          paddingRight: 32)
    }
}


