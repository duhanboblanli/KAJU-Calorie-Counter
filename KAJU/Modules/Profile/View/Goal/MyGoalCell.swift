//
//  MyGoalCell.swift
//  KAJU
//
//  Created by kadir on 21.02.2023.
//

import UIKit

final class MyGoalCell: UITableViewCell {
    
    static var identifier = "MyGoalCell"
    static var myGoalSettings: MyGoalSettingsController!
    var myViewController: UIViewController!
    private let backGroundColor = ThemesOptions.backGroundColor
    
    // MARK: -UI ELEMENTS
    private lazy var title = {
        let label = UILabel()
        label.text = "My Goals".localized()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .white
        return label
    }()
    private lazy var goal = {
        let label = UILabel()
        label.text = "Goal:".localized()
        label.makeLargeText(fontSize: 18)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.textColor = .white
        return label
    }()
    private lazy var goalValue = {
        let label = UILabel()
        label.textColor = .systemGray
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    private lazy var weight = {
        let label = UILabel()
        label.text = "Weight:".localized()
        label.makeLargeText(fontSize: 18)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.textColor = .white
        return label
    }()
    private lazy var weightValue = {
        let label = UILabel()
        label.textColor = .systemGray
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    private lazy var calories = {
        let label = UILabel()
        label.text = "Calories:".localized()
        label.makeLargeText(fontSize: 18)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.textColor = .white
        return label
    }()
    private lazy var caloriesValue = {
        let label = UILabel()
        label.textColor = .systemGray
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    private lazy var editButton = {
        let button = UIButton()
        button.setTitle("EDIT".localized(), for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = ThemesOptions.buttonBackGColor
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    // MARK: -INIT-CELL
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        linkViews()
        layoutSubviews()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -VIEWS CONNECTION
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
    
    // MARK: -CONFIGURATION
    func configureView(){
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    // MARK: -FUNCTIONS
    func setGoalCell(model: GoalCellModel){
        goalValue.text = model.goalType
        weightValue.text = model.weight
        var calorieGoal: String = ""
        if model.isAdviced{
            caloriesValue.text = model.advicedCalorieGoal
            calorieGoal = "Adviced".localized()
        }else{
            caloriesValue.text = model.manuelCalorieGoal
            calorieGoal = "Manuel".localized()
        }
        
        MyGoalCell.myGoalSettings = MyGoalSettingsController(goalValue: model.goalType , weightValue: model.weight, goalCaloryValue: calorieGoal, activenessValue: model.activeness, goalWeightValue: model.goalWeight, weeklyGoalValue: model.weeklyGoal
        )
    }
    
    @objc func editButtonTapped() {
        myViewController.navigationController?.pushViewController(MyGoalCell.myGoalSettings, animated: true)
    }
    
    // MARK: -LAYOUT
    override func layoutSubviews() {
        super.layoutSubviews()
        title
            .anchor(top: contentView.topAnchor,
                    left: contentView.leftAnchor,
                    paddingTop: 16,
                    paddingLeft: 24)
        
        editButton
            .anchor(top: title.topAnchor,
                    bottom: title.bottomAnchor,
                    right: contentView.rightAnchor,
                    paddingRight: 16)
        
        editButton
            .widthAnchor.constraint(equalToConstant: 64).isActive = true
        
        goal
            .anchor(top: title.bottomAnchor,
                    left: title.leftAnchor,
                    paddingTop: 16,
                    paddingLeft: 4)
        
        goalValue
            .anchor(top: goal.topAnchor,
                    left: goal.rightAnchor,
                    right: contentView.rightAnchor,
                    paddingLeft: 8,
                    paddingRight: 8)
        
        weight
            .anchor(top: goal.bottomAnchor,
                    left: title.leftAnchor,
                    paddingTop: 8,
                    paddingLeft: 4)
        
        weightValue
            .anchor(top: weight.topAnchor,
                    left: weight.rightAnchor,
                    right: goalValue.rightAnchor,
                    paddingLeft: 8,
                    paddingRight: 8)
        
        calories
            .anchor(top: weight.bottomAnchor,
                    left: title.leftAnchor,
                    bottom: contentView.bottomAnchor,
                    paddingTop: 8,
                    paddingLeft: 4,
                    paddingBottom: 16)
        
        caloriesValue
            .anchor(top: calories.topAnchor,
                    left: calories.rightAnchor,
                    bottom: calories.bottomAnchor,
                    right: goalValue.rightAnchor,
                    paddingLeft: 8)
    }
}


