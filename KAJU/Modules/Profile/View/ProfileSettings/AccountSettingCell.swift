//
//  AccountSettingCell.swift
//  KAJU
//
//  Created by kadir on 3.03.2023.
//

import UIKit

final class AccountSettingCell: UITableViewCell {
    
    private let cellBackgColor = ThemesOptions.cellBackgColor
    static let identifier = "AccountSettingCell"
    var myViewController: UIViewController!
    
    // MARK: -UI ELEMENTS
    private lazy var pSettingLabel = {
        let label = UILabel()
        label.font = UIFont(name: "Copperplate Bold", size: 25)
        label.textColor = ThemesOptions.buttonBackGColor
        return label
    }()
    private lazy var pValueLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private lazy var editButton = {
        let button = UIButton()
        let size = CGFloat(42)
        button.tintColor = ThemesOptions.figureColor
        button.backgroundColor = ThemesOptions.cellBackgColor
        button.layer.cornerRadius = size / 2
        return button
    }()
    private lazy var iconView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "pencil")
        imageView.tintColor = ThemesOptions.figureColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: -INIT-CELL
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        linkViews()
        configureView()
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -VIEWS CONNECTION
    func linkViews(){
        contentView.addSubview(pSettingLabel)
        contentView.addSubview(pValueLabel)
        contentView.addSubview(editButton)
        editButton.addSubview(iconView)
    }
    
    // MARK: -CONFIGURATION
    func configureView(){
        editButton.addTarget(self, action: #selector(editorButtonTapped), for: .touchUpInside)
    }
    
    // MARK: -FUNCTIONS
    func setAccountSettings(model: SettingModel){
        editButton.accessibilityIdentifier = model.textLabel
        pSettingLabel.text = "\(model.textLabel)"
        
        if(model.textLabel == "Password".localized()){
            pValueLabel.accessibilityIdentifier = model.textValue
            pValueLabel.text = String(repeating: "* ", count: model.textValue.count)
        }else{
            editButton.isHidden = true
            pValueLabel.text = model.textValue
        }
    }
    
    @objc func editorButtonTapped(){
        switch editButton.accessibilityIdentifier {
        case "Password".localized():
            myViewController.present(PasswordEditor(textLabel: pSettingLabel, textValue: pValueLabel), animated: true)
        default:
            return
        }
    }
    
    // MARK: -LAYOUT
    override func layoutSubviews() {
        pSettingLabel
            .anchor(top: contentView.topAnchor,
               left: contentView.leftAnchor,
               bottom: pValueLabel.topAnchor,
               paddingTop: 16,
               paddingLeft: 16,
               paddingBottom: 8)
        
        editButton
            .anchor(top: pSettingLabel.topAnchor,
                    bottom: pSettingLabel.bottomAnchor,
                    right: contentView.rightAnchor,
                    paddingTop: 16,
                    paddingRight: 24)
        
        pValueLabel
            .anchor(top: pSettingLabel.bottomAnchor,
                    left: pSettingLabel.leftAnchor,
                    bottom: contentView.bottomAnchor,
                    right: editButton.rightAnchor,
                    paddingRight: 64)
        
        iconView
            .anchor(top: editButton.topAnchor,
                    left: editButton.leftAnchor,
                    bottom: editButton.bottomAnchor,
                    right: editButton.rightAnchor,
                    paddingTop: 8,
                    paddingLeft: 8,
                    paddingBottom: 8,
                    paddingRight: 8,
                    width: 28,
                    height: 28)
    }
}

