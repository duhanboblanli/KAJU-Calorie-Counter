//
//  ProfileCell.swift
//  KAJU
//
//  Created by kadir on 21.02.2023.
//

import UIKit
import FirebaseAuth
import FirebaseStorageUI

class ProfileCell: UITableViewCell {
    
    let profileRef = DatabaseSingleton.storage
    let db = DatabaseSingleton.db
    private var userEmail = Auth.auth().currentUser?.email
    var myViewController: UIViewController!
    static var myProfileSettings: UIViewController!
    var alertPhotoPicker: PhotoPicker!
    static var identifier = "ProfileCell"
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        let size = CGFloat(150)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = CGFloat(size / 2)
        imageView.layer.borderWidth = 3
        imageView.anchor(width: size, height: size)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let backGroundView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = ThemesOptions.cellBackgColor
        return view
    }()
    
    let nameIcon = {
        let icon = UIImageView()
        let size = CGFloat(38)
        icon.anchor(width: size, height: size)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.clipsToBounds = true
        icon.layer.cornerRadius = 10
        return icon
    }()
    let genderIcon = {
        let icon = UIImageView()
        let size = CGFloat(38)
        icon.anchor(width: size, height: size)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.clipsToBounds = true
        icon.layer.cornerRadius = 10
        return icon
    }()
    let diateryIcon = {
        let icon = UIImageView()
        let size = CGFloat(38)
        icon.anchor(width: size, height: size)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.clipsToBounds = true
        icon.layer.cornerRadius = 10
        return icon
    }()
    let editPhotoButton = {
        let button = UIButton()
        let size = CGFloat(42)
        button.anchor(width: size, height: size)
        button.backgroundColor = ThemesOptions.backGroundColor
        button.layer.cornerRadius = CGFloat(size / 2)
        return button
    }()
    let photoImage = {
        let image = UIImageView()
        image.image = UIImage(systemName: "photo.circle.fill")
        image.clipsToBounds = true
        image.tintColor = .white
        return image
    }()
    let nameLabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Name"
        label.makeLargeText(fontSize: 18)
        return label
    }()
    let genderLabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Gender"
        label.makeLargeText(fontSize: 18)
        return label
    }()
    let diateryLabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Diatery"
        label.makeLargeText(fontSize: 18)
        return label
    }()
    let nameContainer = {
        let container = UIView()
        let width = CGFloat(120)
        container.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        container.layer.borderWidth = 1
        container.anchor(width: width)
        container.layer.cornerRadius = 10
        return container
        
    }()
    let genderContainer = {
        let container = UIView()
        let width = CGFloat(120)
        container.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        container.layer.borderWidth = 1
        container.layer.cornerRadius = 10
        container.anchor(width: width)
        return container
        
    }()
    let diateryContainer = {
        let container = UIView()
        let width = CGFloat(120)
        container.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        container.layer.borderWidth = 1
        container.anchor(width: width)
        container.layer.cornerRadius = 10
        container.backgroundColor = .systemOrange.withAlphaComponent(0.8)
        return container
    }()
    let nameValue = {
        let label = UILabel()
        label.textColor = .white
        label.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        label.makeLargeText(fontSize: 16)
        return label
    }()
    let genderLValue = {
        let label = UILabel()
        label.textColor = .white
        label.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        label.makeLargeText(fontSize: 16)
        return label
    }()
    let diateryValue = {
        let label = UILabel()
        label.textColor = .white
        label.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        label.makeLargeText(fontSize: 16)
        return label
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        alertPhotoPicker = PhotoPicker(imageView: profileImage)
        linkViews()
        layoutSubviews()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func linkViews(){
        contentView.addSubview(backGroundView)
        contentView.addSubview(profileImage)
        contentView.addSubview(editPhotoButton)
        contentView.addSubview(nameContainer)
        contentView.addSubview(genderContainer)
        contentView.addSubview(diateryContainer)
        nameContainer.addSubview(nameIcon)
        nameContainer.addSubview(nameLabel)
        nameContainer.addSubview(nameValue)
        genderContainer.addSubview(genderIcon)
        genderContainer.addSubview(genderLabel)
        genderContainer.addSubview(genderLValue)
        diateryContainer.addSubview(diateryIcon)
        diateryContainer.addSubview(diateryLabel)
        diateryContainer.addSubview(diateryValue)
        editPhotoButton.addSubview(photoImage)
    }
    
    func configureView(){
        editPhotoButton.addTarget(self, action: #selector(showOpt), for: .touchUpInside)
        if let email = userEmail {
            let docRef = db.collection("UserInformations").document("\(email)")
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let data = document.data() {
                        guard let url = data["profileImgURL"] else{ return }
                        self.profileImage.sd_setImage(with: self.profileRef.reference(withPath: url as! String), placeholderImage: UIImage(named: "defaultProfilePhoto"))
                    }
                }
            }
        } else { profileImage.image = UIImage(named: "defaultProfilePhoto") }
    }
    
    @objc func showOpt(){
        myViewController.present(alertPhotoPicker, animated: false)
    }
    
    func setProfile(model: ProfileCellModel){
        nameValue.text = model.name
        genderLValue.text = model.sex
        diateryValue.text = model.diateryType
        ProfileCell.myProfileSettings = ProfileSettingsController(nameValue: model.name, genderValue: model.sex, diaterValue: model.diateryType, heightValue: model.height)
        
        switch genderLValue.text{
        case "Male":
            nameIcon.image = UIImage(named: "MaleImage")
            genderIcon.image = UIImage(named: "MaleGender")
            nameContainer.backgroundColor = .systemBlue.withAlphaComponent(0.8)
            genderContainer.backgroundColor = .systemRed.withAlphaComponent(0.8)
        case "Female":
            nameIcon.image = UIImage(named: "FemaleImage")
            genderIcon.image = UIImage(named: "FemaleGender")
            nameContainer.backgroundColor = .systemPink.withAlphaComponent(0.8)
            genderContainer.backgroundColor = .systemGreen.withAlphaComponent(0.8)
        default:
            return
        }
        
        switch diateryValue.text{
        case "Classic":
            diateryIcon.image = UIImage(named: "classicDiate")
        case "Vegetarian":
            diateryIcon.image = UIImage(named: "vegetarianDiate")
        case "Vegan":
            diateryIcon.image = UIImage(named: "veganDiate")
        default:
            return
        }
    
    }
    
    override func layoutSubviews() {
        backGroundView.anchor(top: profileImage.centerYAnchor,
                              left: contentView.leftAnchor,
                              bottom: contentView.bottomAnchor,
                              right: contentView.rightAnchor)
        
        profileImage.anchor(top: contentView.topAnchor)
        
        editPhotoButton.anchor(bottom: profileImage.bottomAnchor,
                               right: profileImage.rightAnchor,
                               paddingRight: 8)
        
        photoImage.anchor(top: editPhotoButton.topAnchor,
                          left: editPhotoButton.leftAnchor,
                          bottom: editPhotoButton.bottomAnchor,
                          right: editPhotoButton.rightAnchor,
                          paddingTop: 8,
                          paddingLeft: 8,
                          paddingBottom: 8,
                          paddingRight: 8,
                          width: 28,
                          height: 28)
        
        nameContainer.anchor(top: profileImage.bottomAnchor,
                             left: contentView.leftAnchor,
                             paddingTop: 16,
                             paddingLeft: 32)
        
        nameIcon.anchor(top: nameContainer.topAnchor,
                        left: nameContainer.leftAnchor,
                        paddingTop: 2,
                        paddingLeft: 2)
        
        nameLabel.anchor(top: nameContainer.topAnchor,
                         left: nameIcon.rightAnchor,
                         paddingLeft: 4)
        
        nameValue.anchor(top: nameContainer.topAnchor,
                         left: nameContainer.rightAnchor,
                         bottom: nameContainer.bottomAnchor,
                         right: contentView.rightAnchor,
                         paddingLeft: 0,
                         paddingRight: 32)
        
        genderContainer.anchor(top: nameContainer.bottomAnchor,
                               left: nameContainer.leftAnchor,
                               paddingTop: 8)
        genderIcon.anchor(top: genderContainer.topAnchor,
                          left: genderContainer.leftAnchor,
                          paddingTop: 2,
                          paddingLeft: 2)
        
        genderLabel.anchor(left: genderIcon.rightAnchor,
                           paddingLeft: 4)
        
        genderLValue.anchor(top: genderContainer.topAnchor,
                            left: genderContainer.rightAnchor,
                            bottom: genderContainer.bottomAnchor,
                            right: contentView.rightAnchor,
                            paddingRight: 32)
        
        diateryContainer.anchor(top: genderContainer.bottomAnchor,
                                left: nameContainer.leftAnchor,
                                bottom: contentView.bottomAnchor,
                                paddingTop: 8,
                                paddingBottom: 16)
        
        diateryIcon.anchor(top: diateryContainer.topAnchor,
                           left: diateryContainer.leftAnchor,
                           paddingTop: 2,
                           paddingLeft: 2)
        
        diateryLabel.anchor(left: diateryIcon.rightAnchor,
                            paddingLeft: 4)
        
        diateryValue.anchor(top: diateryContainer.topAnchor,
                            left: diateryContainer.rightAnchor,
                            bottom: diateryContainer.bottomAnchor,
                            right: contentView.rightAnchor,
                            paddingRight: 32)
        
        profileImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        nameIcon.centerYAnchor.constraint(equalTo: nameContainer.centerYAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: nameContainer.centerYAnchor).isActive = true
        nameValue.centerYAnchor.constraint(equalTo: nameContainer.centerYAnchor).isActive = true
        genderIcon.centerYAnchor.constraint(equalTo: genderContainer.centerYAnchor).isActive = true
        genderLabel.centerYAnchor.constraint(equalTo: genderContainer.centerYAnchor).isActive = true
        genderLValue.centerYAnchor.constraint(equalTo: genderContainer.centerYAnchor).isActive = true
        diateryIcon.centerYAnchor.constraint(equalTo: diateryContainer.centerYAnchor).isActive = true
        diateryLabel.centerYAnchor.constraint(equalTo: diateryContainer.centerYAnchor).isActive = true
        diateryValue.centerYAnchor.constraint(equalTo: diateryContainer.centerYAnchor).isActive = true
    }
}

extension UILabel {
    func makeLargeText(fontSize: Int){
        self.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
    }
}

