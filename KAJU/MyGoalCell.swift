//
//  MyGoalCell.swift
//  KAJU
//
//  Created by kadir on 21.02.2023.
//

import UIKit

class MyGoalCell: UITableViewCell {
    
    static var identifier = "MyGoalCell"
    var myViewController: UIViewController!
    let backGroundColor = ThemesOptions.backGroundColor
    
    let title = {
        let label = UILabel()
        label.text = "My Goals"
        label.font = UIFont.boldSystemFont(ofSize: 22)
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
        button.titleLabel?.makeLargeText(fontSize: 16)
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
        caloriesValue.text = model.calories
    }
    
    @objc func tapped() {
        myViewController.navigationController?.pushViewController(MyGoalSettingsController(), animated: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 16 ,paddingLeft: 16)
        editButton.anchor(top: title.topAnchor, bottom: title.bottomAnchor, right: contentView.rightAnchor, paddingRight: 16)
        editButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        goal.anchor(top: title.bottomAnchor, left: title.leftAnchor, paddingTop: 16, paddingLeft: 8, width: 45)
        goalValue.anchor(top: goal.topAnchor, left: goal.rightAnchor, right: contentView.rightAnchor, paddingLeft: 4, paddingRight: 8)
        weight.anchor(top: goal.bottomAnchor, left: title.leftAnchor, paddingTop: 8, paddingLeft: 8, width: 65)
        weightValue.anchor(top: weight.topAnchor, left: weight.rightAnchor, right: goalValue.rightAnchor, paddingLeft: 4, paddingRight: 8)
        calories.anchor(top: weight.bottomAnchor, left: title.leftAnchor, paddingTop: 8, paddingLeft: 8, width: 75)
        caloriesValue.anchor(top: calories.topAnchor, left: calories.rightAnchor, bottom: contentView.bottomAnchor, right: goalValue.rightAnchor, paddingLeft: 4, paddingBottom: 16, paddingRight: 8)
    }
}

