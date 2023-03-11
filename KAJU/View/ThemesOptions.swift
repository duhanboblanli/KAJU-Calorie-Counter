//
//  ThemesOptions.swift
//  KAJU
//
//  Created by kadir on 3.03.2023.
//

import UIKit
import DropDown

struct ThemesOptions{
    static let backGroundColor = UIColor(red: 0.10, green: 0.18, blue: 0.29, alpha: 1.00)
    static let cellBackgColor = UIColor(red: 0.16, green: 0.28, blue: 0.36, alpha: 1.00)
    static let buttonBackGColor = UIColor(red: 0.18, green: 0.53, blue: 0.53, alpha: 1.00)
    static let figureColor = UIColor(red: 0.52, green: 0.78, blue: 0.61, alpha: 1.00)
    static let dropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.backgroundColor = cellBackgColor
        dropDown.textColor = .white
        dropDown.cornerRadius = 10
        return dropDown
    }()
}
