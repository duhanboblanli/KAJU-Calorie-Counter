//
//  SettingsCell.swift
//  KAJU
//
//  Created by kadir on 14.02.2023.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    var settingIcon = UIImageView()
    var settingLabel = UILabel()
    static var identifier = "SettingsCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        linkViews()
        configureSettingIcon()
        configureSettingLabel()
        setIconConstraints()
        setLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func linkViews(){
        contentView.addSubview(settingIcon)
        contentView.addSubview(settingLabel)
    }
    
    func setSetting(setting: ProfileOption){
        settingIcon.image = setting.image
        settingIcon.tintColor = ThemesOptions.buttonBackGColor
        settingLabel.text = setting.title
        settingLabel.font = UIFont.boldSystemFont(ofSize: 16)
        settingLabel.textColor = .white
    }
    
    func configureSettingIcon() {
        settingIcon.layer.cornerRadius = 10
        settingIcon.clipsToBounds = true
    }
    
    func configureSettingLabel() {
        settingLabel.numberOfLines = 0
        settingLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setIconConstraints(){
        settingIcon.translatesAutoresizingMaskIntoConstraints = false
        settingIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        settingIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        settingIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        settingIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setLabelConstraints(){
        settingLabel.translatesAutoresizingMaskIntoConstraints = false
        settingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        settingLabel.leadingAnchor.constraint(equalTo: settingIcon.trailingAnchor, constant: 20).isActive = true
        settingLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        settingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
    }
}
