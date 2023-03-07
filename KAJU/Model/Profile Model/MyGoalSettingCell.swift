//
//  MyGoalSettingCell.swift
//  KAJU
//
//  Created by kadir on 28.02.2023.
//

import UIKit
import DropDown

class MyGoalSettingCell: UITableViewCell {
    
    static let identifier = "MyGoalSettingCell"
    var myViewController: UIViewController!
    var dropDown = ThemesOptions.dropDown
    let activityLevel = ["Low", "Moderate", "High", "Very High"]
    let goal = ["Lose Weight", "Build Muscle", "Maintain Weight"]
    let cellBackgColor = ThemesOptions.cellBackgColor
    
    let pSettingLabel = {
        let label = UILabel()
        label.font = UIFont(name: "Copperplate Bold", size: 25)
        label.textColor = ThemesOptions.buttonBackGColor
        return label
    }()
    let pValueLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    let editButton = {
        let button = UIButton()
        let size = CGFloat(42)
        button.backgroundColor = ThemesOptions.cellBackgColor
        button.layer.cornerRadius = size / 2
        return button
    }()
    let iconView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "pencil")
        imageView.tintColor = ThemesOptions.figureColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        linkViews()
        configureView()
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func linkViews(){
        contentView.addSubview(pSettingLabel)
        contentView.addSubview(pValueLabel)
        contentView.addSubview(editButton)
        editButton.addSubview(iconView)
    }
    
    func configureView(){
        editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
    }
    
    func setProfileSetting(model: SettingModel){
        editButton.accessibilityIdentifier = model.textLabel        
        pSettingLabel.text = "\(model.textLabel)"
        pValueLabel.text = "\(model.textValue)"
    }
    
    @objc func edit(){        
        switch editButton.accessibilityIdentifier{
        case "Goal":
            dropDown = setDropDown(dataSource: goal, anchorView: pSettingLabel, bottomOffset: CGPoint(x: 0, y:(pSettingLabel.plainView.bounds.height ) + 36))
            dropDown.show()
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                pValueLabel.text = item
            }
        case "Starting Weight":
            myViewController.present(Editor(textLabel: pSettingLabel, textValue: pValueLabel), animated: true)
            
        case "Goal Weight":
            myViewController.present(Editor(textLabel: pSettingLabel, textValue: pValueLabel), animated: true)
            
        case "Activity Level":
            dropDown = setDropDown(dataSource: activityLevel, anchorView: pSettingLabel, bottomOffset: CGPoint(x: 0, y:(pSettingLabel.plainView.bounds.height ) + 36))
            dropDown.show()
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                pValueLabel.text = item
            }
            
        case "Weekly Goal":
            myViewController.present(Editor(textLabel: pSettingLabel, textValue: pValueLabel), animated: true)

        case "Calory Goal":
            myViewController.present(Editor(textLabel: pSettingLabel, textValue: pValueLabel), animated: true)

        default:
            return
        }
     }
     
    override func layoutSubviews() {
        pSettingLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: pValueLabel.topAnchor, paddingTop: 16,
            paddingLeft: 16, paddingBottom: 8)
        pValueLabel.anchor(top: pSettingLabel.bottomAnchor, left: pSettingLabel.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor)
        editButton.anchor(top: pSettingLabel.topAnchor, bottom: pSettingLabel.bottomAnchor, right: contentView.rightAnchor, paddingTop: 16, paddingRight: 24)
        iconView.anchor(top: editButton.topAnchor, left: editButton.leftAnchor, bottom: editButton.bottomAnchor, right: editButton.rightAnchor,paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 28, height: 28)
    }
}
