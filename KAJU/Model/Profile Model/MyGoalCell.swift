//
//  MyGoalCell.swift
//  KAJU
//
//  Created by kadir on 21.02.2023.
//

import UIKit

class MyGoalCell: UITableViewCell {
    
    static var identifier = "MyGoalCell"
    static var myGoalSettings: MyGoalSettingsController!
    var myViewController: UIViewController!
    let backGroundColor = ThemesOptions.backGroundColor
    
    let title = {
        let label = UILabel()
        label.text = "My Goals"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .white
        return label
    }()
    let goal = {
        let label = UILabel()
        label.text = "Goal:"
        label.makeLargeText(fontSize: 18)
        label.textColor = .white
        return label
    }()
    let goalValue = {
        let label = UILabel()
        label.textColor = .systemGray
        return label
        
    }()
    let weight = {
        let label = UILabel()
        label.text = "Weight:"
        label.makeLargeText(fontSize: 18)
        label.textColor = .white
        return label
    }()
    let weightValue = {
        let label = UILabel()
        label.textColor = .systemGray
        return label
        
    }()
    let calories = {
        let label = UILabel()
        label.text = "Calories:"
        label.makeLargeText(fontSize: 18)
        label.textColor = .white
        return label
    }()
    let caloriesValue = {
        let label = UILabel()
        label.textColor = .systemGray
        return label
        
    }()
    let editButton = {
        let button = UIButton()
        button.setTitle("EDIT", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.backgroundColor = ThemesOptions.buttonBackGColor
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        linkViews()
        layoutSubviews()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func linkViews(){
        contentView.addSubview(title)
        contentView.addSubview(editButton)
        contentView.addSubview(goal)
        contentView.addSubview(weight)
        contentView.addSubview(calories)
        contentView.addSubview(goalValue)
        contentView.addSubview(weightValue)
        contentView.addSubview(caloriesValue)
    }
    
    func configureView(){
        editButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    func setGoalCell(model: GoalCellModel){
        goalValue.text = model.goalType
        weightValue.text = model.weight
        caloriesValue.text = model.calorie
        MyGoalCell.myGoalSettings = MyGoalSettingsController(goalValue: model.goalType , weightValue: model.weight, caloriesValue: model.calorie)
    }
    
    @objc func tapped() {
        myViewController.navigationController?.pushViewController(MyGoalCell.myGoalSettings, animated: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 16 ,paddingLeft: 24)
        editButton.anchor(top: title.topAnchor, bottom: title.bottomAnchor, right: contentView.rightAnchor, paddingRight: 16)
        editButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        
        goal.anchor(top: title.bottomAnchor, left: title.leftAnchor, paddingTop: 16, paddingLeft: 0, width: 45)
        goalValue.anchor(top: goal.topAnchor, left: goal.rightAnchor, right: contentView.rightAnchor, paddingLeft: 4, paddingRight: 8)
        
        weight.anchor(top: goal.bottomAnchor, left: title.leftAnchor, paddingTop: 8, paddingLeft: 0, width: 65)
        weightValue.anchor(top: weight.topAnchor, left: weight.rightAnchor, right: goalValue.rightAnchor, paddingLeft: 4, paddingRight: 8)
        calories.anchor(top: weight.bottomAnchor, left: title.leftAnchor, bottom: contentView.bottomAnchor, paddingTop: 8, paddingBottom: 16, width: 75)
        caloriesValue.anchor(top: calories.topAnchor, left: calories.rightAnchor, bottom: calories.bottomAnchor, right: goalValue.rightAnchor, paddingLeft: 4)
    }
}

