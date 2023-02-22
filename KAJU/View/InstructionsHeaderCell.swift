//
//  InstructionsHeaderCell.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 22.02.2023.
//

import UIKit

// InstructionView header için kullanılan cell
class InstructionsHeaderCell: UIView {
    
    static let ColorHardDarkGreen = UIColor( red: 26/255, green: 47/255, blue: 75/255, alpha: 1) //rgb(26, 47, 75)
    static let ColorDarkGreen = UIColor( red: 40/255, green: 71/255, blue: 92/255, alpha: 1) //rgb(40, 71, 92)
    static let ColorGreen = UIColor( red: 47/255, green: 136/255, blue: 134/255, alpha: 1) //rgb(47, 136, 134)
    static let ColorLightGreen = UIColor( red: 132/255, green: 198/255, blue: 155/255, alpha: 1) //rgb(132, 198, 155)
    
    //MARK: - Setup UI Items
    let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = ColorHardDarkGreen
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor( red: 26/255, green: 47/255, blue: 75/255, alpha: 1)
        addSubview(ingredientsLabel)
        setupView()
    }
    
    //MARK: - Setup SubView Constraints
    private func setupView() {
        setupIngredientsLabel()
    }

    private func setupIngredientsLabel() {
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientsLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 19).isActive = true
        ingredientsLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        ingredientsLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        ingredientsLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) as not been implemented")
    }
    
}
