//
//  RecipeSearchCell.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 25.02.2023.
//

import UIKit

class RecipeSearchCell: UITableViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Verdana", size: 16)
        return label
    }()
    
    let recipeImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setupRecipeImageView()
        setupRecipeLabel()
    }

    private func setupRecipeImageView() {
        addSubview(recipeImageView)
        
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        recipeImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        recipeImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        recipeImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }
        
    private func setupRecipeLabel() {
        addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
}
