//
//  CustomHeaderCell.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 22.02.2023.
//

import UIKit

// DetailView üst kısmı için kullanılan cell
class CustomHeaderCell: UIView {
    
    static let ColorHardDarkGreen = UIColor( red: 26/255, green: 47/255, blue: 75/255, alpha: 1) //rgb(26, 47, 75)
    static let ColorDarkGreen = UIColor( red: 40/255, green: 71/255, blue: 92/255, alpha: 1) //rgb(40, 71, 92)
    static let ColorGreen = UIColor( red: 47/255, green: 136/255, blue: 134/255, alpha: 1) //rgb(47, 136, 134)
    static let ColorLightGreen = UIColor( red: 132/255, green: 198/255, blue: 155/255, alpha: 1) //rgb(132, 198, 155)
    
    //MARK: - Setup UI Items
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = ContentMode.scaleAspectFill
        return imageView
    }()
    
    let recipeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 27.0)
        label.textAlignment = .center
        label.backgroundColor = ColorHardDarkGreen.withAlphaComponent(0.4)
        label.textColor = .white
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let timingLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = ColorHardDarkGreen
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()
    
    let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = ColorHardDarkGreen
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor( red: 26/255, green: 47/255, blue: 75/255, alpha: 1)
        addSubview(imageView)
        addSubview(recipeTitleLabel)
        addSubview(timingLabel)
        addSubview(ingredientsLabel)
        setupView()
    }
    
    //MARK: - Setup SubView Constraints
    private func setupView() {
        setupImageView()
        setupRecipeTitleLabel()
        setupIngredientsLabel()
        setupTimingLabel()
    }
    
    // Üst,sol,sağ view'e yaslı; alttan timingLabel'a -5 ile yaslı
    //Height: 231, Width:312 json dataya göre ayarlı
    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: timingLabel.topAnchor,constant: 0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 312).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 231).isActive = true
        imageView.contentMode = .scaleToFill
    }
    
    // Üst,sol,sağ view'e yaslı ve centerX'de
    private func setupRecipeTitleLabel() {
        recipeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeTitleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        recipeTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        recipeTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        recipeTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    // Sol,sağ view'e; alt tableView'e yaslı
    // Height:35
    private func setupIngredientsLabel() {
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientsLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 4).isActive = true
        ingredientsLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        ingredientsLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        ingredientsLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    // Nutritions Bilgileri Olarak Değiştirildi
    // Sol,(Sağ -8) view'e yaslı; alttan ingredientsLabel'a yaslı
    // Height: 35
    private func setupTimingLabel() {
        timingLabel.translatesAutoresizingMaskIntoConstraints = false
        timingLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 8).isActive = true
        timingLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -8).isActive = true
        timingLabel.bottomAnchor.constraint(equalTo: ingredientsLabel.topAnchor).isActive = true
        timingLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) as not been implemented")
    }
    
}
