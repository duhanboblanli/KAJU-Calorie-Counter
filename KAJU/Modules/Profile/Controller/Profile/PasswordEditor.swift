//
//  PasswordEditor.swift
//  KAJU
//
//  Created by kadir on 10.03.2023.
//

import UIKit
import FirebaseAuth
import Toast

final class PasswordEditor: UIViewController {
    
    // MARK: -UI ELEMENTS
    private var textLabel: UILabel!
    private var textValue: UILabel!
    
    private lazy var contentView = {
        let view = UIView()
        let width = CGFloat(275)
        let height = CGFloat(240)
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
    private lazy var oldPassword = {
        let textField = UITextField()
        let height = CGFloat(44)
        textField.anchor(height: height)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Old Password".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        textField.borderStyle = .roundedRect
        textField.textColor = .white
        textField.isSecureTextEntry = true
        textField.backgroundColor = ThemesOptions.cellBackgColor
        return textField
    }()
    private lazy var newPassword = {
        let textField = UITextField()
        let height = CGFloat(44)
        textField.anchor(height: height)
        textField.attributedPlaceholder = NSAttributedString(
            string: "New Password".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        textField.borderStyle = .roundedRect
        textField.textColor = .white
        textField.backgroundColor = ThemesOptions.cellBackgColor
        textField.isSecureTextEntry = true
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
    let cancelButton = {
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
    private lazy var eyeButtonN = {
        let button = UIButton()
        let size = CGFloat(36)
        button.anchor(width: size, height: 36)
        button.accessibilityIdentifier = "new"
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        button.layer.cornerRadius = 5
        button.tintColor = ThemesOptions.buttonBackGColor
        button.backgroundColor = ThemesOptions.figureColor
        //
        return button
    }()
    private lazy var eyeButtonO = {
        let button = UIButton()
        let size = CGFloat(36)
        button.anchor(width: size, height: 36)
        button.accessibilityIdentifier = "old"
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        button.layer.cornerRadius = 5
        button.tintColor = ThemesOptions.buttonBackGColor
        button.backgroundColor = ThemesOptions.figureColor
        return button
    }()
    
    // MARK: -INIT-CONTROLLER
    init(textLabel: UILabel, textValue: UILabel) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        self.textLabel = textLabel
        self.textValue = textValue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        linkViews()
        configureView()
        configureLayout()
    }
    
    // MARK: -VIEWS CONNECTION
    func linkViews(){
        view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(oldPassword)
        contentView.addSubview(newPassword)
        contentView.addSubview(doneButton)
        contentView.addSubview(cancelButton)
        contentView.addSubview(eyeButtonN)
        contentView.addSubview(eyeButtonO)
    }
    
    // MARK: -CONFIGURATION
    func configureView(){
        view.backgroundColor = .black.withAlphaComponent(0.8)
        titleLabel.text = textLabel.text
        doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        eyeButtonN.addTarget(self, action: #selector(changeEyeAppearance(sender: )), for: .touchUpInside)
        eyeButtonO.addTarget(self, action: #selector(changeEyeAppearance(sender: )), for: .touchUpInside)
    }
    
    // MARK: -FUNCTIONS
    @objc func done(){
        showSimpleAlert()
    }
    
    @objc func cancel(){
        self.dismiss(animated: true)
    }
    
    @objc func changeEyeAppearance(sender: UIButton){
        switch sender.accessibilityIdentifier{
        case "new":
            if(newPassword.isSecureTextEntry){
                eyeButtonN.setImage(UIImage(systemName: "eye"), for: .normal)
                newPassword.isSecureTextEntry = false
            }else{
                eyeButtonN.setImage(UIImage(systemName: "eye.slash"), for: .normal)
                newPassword.isSecureTextEntry = true
            }
        case "old":
            if(oldPassword.isSecureTextEntry){
                eyeButtonO.setImage(UIImage(systemName: "eye"), for: .normal)
                oldPassword.isSecureTextEntry = false
            }else{
                eyeButtonO.setImage(UIImage(systemName: "eye.slash"), for: .normal)
                oldPassword.isSecureTextEntry = true
            }
        default:
            return
        }
    }
    
    func showSimpleAlert() {
        let alert = UIAlertController(title: "Are you sure you want to Change ?".localized(),
                                      message: nil,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.default,
                                      handler: { _ in }))
        
        alert.addAction(UIAlertAction(title: "Change".localized(),
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
            if let email = Auth.auth().currentUser?.email,
               let newPass = self.newPassword.text {
                    let oldPass = UserDefaults.standard.string(forKey: email)
                
                    if (self.oldPassword.text != oldPass){
                        self.showInfo(title: Texts.dunoMatchPass)
                    }else if(newPass.count < 6){
                        self.showInfo(title: Texts.shortPass)
                    }else if(newPass == oldPass){
                        self.showInfo(title: Texts.samePass)
                    }else{
                        Auth.auth().currentUser?.updatePassword(to: newPass)
                        UserDefaults.standard.set(newPass, forKey: email)
                        let succesImg = UIImage(systemName: "checkmark.circle.fill")
                        self.textValue.text = String(repeating: "* ", count: newPass.count)
                        self.view.makeToast(nil, duration: 0.5, position: .bottom, title: Texts.passChanged, image: succesImg, completion: {_ in self.dismiss(animated: true)})
                    }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showInfo(title: String){
        let alert = UIAlertController(title: title,
                                      message: nil,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.destructive,
                                      handler: { _ in }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: -LAYOUT
    func configureLayout(){
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        titleLabel
            .anchor(top: contentView.topAnchor,
                    left: contentView.leftAnchor,
                    right: contentView.rightAnchor,
                    paddingTop: 16,
                    paddingLeft: 24,
                    paddingRight: 24)
        
        oldPassword
            .anchor(top: titleLabel.bottomAnchor,
                    left: titleLabel.leftAnchor,
                    right: eyeButtonO.leftAnchor,
                    paddingTop: 16,
                    paddingRight: 0)
        
        eyeButtonO
            .anchor(top: oldPassword.topAnchor,
                    bottom: oldPassword.bottomAnchor,
                    right: contentView.rightAnchor,
                    paddingRight: 24)
        
        eyeButtonN
            .anchor(top: newPassword.topAnchor,
                    bottom: newPassword.bottomAnchor,
                    right: contentView.rightAnchor,
                    paddingRight: 24)
        
        newPassword
            .anchor(top: oldPassword.bottomAnchor,
                    left: titleLabel.leftAnchor,
                    right: eyeButtonN.leftAnchor,
                    paddingTop: 8,
                    paddingRight: 0)
        
        cancelButton
            .anchor(top: newPassword.bottomAnchor,
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

