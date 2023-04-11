//
//  MyGoalSettingCell.swift
//  KAJU
//
//  Created by kadir on 28.02.2023.
//

import UIKit
import DropDown
import FirebaseAuth
import FirebaseFirestore

final class MyGoalSettingCell: UITableViewCell {
    
    static let identifier = "MyGoalSettingCell"
    var myViewController: UIViewController!
    private let db = Firestore.firestore()
    private var dropDown = ThemesOptions.dropDown
    private let activityLevel = ["Low".localized(), "Moderate".localized(), "High".localized(), "Very High".localized()]
    private var calorie = ["Adviced".localized(), "Manuel".localized()]
    private let goal = ["Lose Weight".localized(), "Build Muscle".localized(), "Maintain Weight".localized()]
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
    
    func setProfileSetting(model: SettingModel){
        editButton.accessibilityIdentifier = model.textLabel
        pSettingLabel.text = "\(model.textLabel)"
        pValueLabel.text = "\(model.textValue)"
    }
    // MARK: -FUNCTIONS
    @objc func editorButtonTapped(){
        switch editButton.accessibilityIdentifier{
        case "Goal".localized():
            dropDown = setDropDown(dataSource: goal, anchorView: pSettingLabel, bottomOffset: CGPoint(x: 0, y:(pSettingLabel.plainView.bounds.height ) + 36))
            dropDown.show()
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                pValueLabel.text = item
                var changeCaloryAmount:Int = 0
                switch item{
                case "Lose Weight".localized():
                    changeCaloryAmount = -400
                case "Build Muscle".localized():
                    changeCaloryAmount = 400
                case "Maintain Weight".localized():
                    changeCaloryAmount = 0
                default: print("error happened while choosing goal type")
                }
                updateDBValue(key: "changeCalorieAmount", value: changeCaloryAmount)
                updateDBValue(key: "goalType", value: item)
            }
        case "Starting Weight".localized():
            myViewController.present(Editor(textLabel: pSettingLabel, textValue: pValueLabel), animated: true)
            
        case "Goal Weight".localized():
            myViewController.present(Editor(textLabel: pSettingLabel, textValue: pValueLabel), animated: true)
            
        case "Activity Level".localized():
            dropDown = setDropDown(dataSource: activityLevel, anchorView: pSettingLabel, bottomOffset: CGPoint(x: 0, y:(pSettingLabel.plainView.bounds.height ) + 36))
            dropDown.show()
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                pValueLabel.text = item
                var bmh:Float = 0.0
                switch item{
                case "Low".localized():
                    bmh = 1.2
                case "Moderate".localized():
                    bmh = 1.3
                case "High".localized():
                    bmh = 1.4
                case "Very High".localized():
                    bmh = 1.5
                default: print("error happened")
                }
                updateDBValue(key: "bmh", value: bmh)
                updateDBValue(key: "activeness", value: item)
            }
            
        case "Weekly Goal".localized():
            myViewController.present(Editor(textLabel: pSettingLabel, textValue: pValueLabel), animated: true)

        case "Calorie Goal".localized():
            dropDown = setDropDown(dataSource: calorie, anchorView: pSettingLabel, bottomOffset: CGPoint(x: 0, y:(pSettingLabel.plainView.bounds.height ) + 36))
            dropDown.show()
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.pValueLabel.text = "Adviced".localized()
                switch item{
                case "Adviced".localized():
                    updateDBValue(key: "adviced", value: true)
                case "Manuel".localized():
                    myViewController.present(Editor(textLabel: pSettingLabel, textValue: pValueLabel, zero: true), animated: true)
                default: print("error happened")
                }
            }
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

extension UIView {
    func updateDBValue(key: String, value: Any){
        if let currentUserEmail = Auth.auth().currentUser?.email {
            let docRef = DatabaseSingleton.db.collection("UserInformations").document("\(currentUserEmail)")
            docRef.updateData([key: value])
        }
    }
}

