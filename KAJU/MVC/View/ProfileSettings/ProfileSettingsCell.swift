//
//  ProfileSettingsCell.swift
//  KAJU
//
//  Created by kadir on 22.02.2023.
//

import UIKit
import DropDown
import FirebaseAuth
import FirebaseFirestore

final class ProfileSettingsCell: UITableViewCell {
    
    static let identifier = "ProfileSettingsCell"
    var myViewController: UIViewController!
    private var dropDown = ThemesOptions.dropDown
    private let genders = ["Male".localized(), "Female".localized()]
    private let diateries = ["Vegetarian".localized(), "Vegan".localized(), "Classic".localized()]
    private let cellBackgColor = ThemesOptions.cellBackgColor
    
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
    func setProfileSetting(model: SettingModel){
        editButton.accessibilityIdentifier = model.textLabel
        pSettingLabel.text = "\(model.textLabel)"
        pValueLabel.text = "\(model.textValue)"
    }
    
    @objc func editorButtonTapped(){
        switch editButton.accessibilityIdentifier{
        case "Name".localized():
            myViewController.present(Editor(textLabel: pSettingLabel, textValue: pValueLabel), animated: true)
        case "Gender".localized():
            dropDown = setDropDown(dataSource: genders, anchorView: pSettingLabel, bottomOffset: CGPoint(x: 0, y:(pSettingLabel.plainView.bounds.height ) + 36))
            dropDown.show()
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                pValueLabel.text = item
                updateDBValue(key: "sex", value: item)
            }
        case "Dietary".localized():
            dropDown = setDropDown(dataSource: diateries, anchorView: pSettingLabel, bottomOffset: CGPoint(x: 0, y:(pSettingLabel.plainView.bounds.height ) + 36))
            dropDown.show()
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                pValueLabel.text = item
                updateDBValue(key: "diateryType", value: item)
            }
        case "Height".localized():
            myViewController.present(Editor(textLabel: pSettingLabel, textValue: pValueLabel), animated: true)
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
        
        pValueLabel
            .anchor(top: pSettingLabel.bottomAnchor,
                    left: pSettingLabel.leftAnchor,
                    bottom: contentView.bottomAnchor,
                    right: contentView.rightAnchor)
        
        editButton
            .anchor(top: pSettingLabel.topAnchor,
                    bottom: pSettingLabel.bottomAnchor,
                    right: contentView.rightAnchor,
                    paddingTop: 16,
                    paddingRight: 24)
        
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

