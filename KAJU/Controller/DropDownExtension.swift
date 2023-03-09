//
//  DropDownExtension.swift
//  KAJU
//
//  Created by kadir on 3.03.2023.
//

import UIKit
import DropDown

extension UIViewController {

    func setDropDown(dataSource: [String], anchorView: UIView, bottomOffset: CGPoint) -> DropDown{
        ThemesOptions.dropDown.dataSource = dataSource
        ThemesOptions.dropDown.anchorView = anchorView
        ThemesOptions.dropDown.bottomOffset = bottomOffset
        ThemesOptions.dropDown.cornerRadius = 10
        
        return ThemesOptions.dropDown
    }
}

extension UIView {

    func setDropDown(dataSource: [String], anchorView: UIView, bottomOffset: CGPoint) -> DropDown{
        ThemesOptions.dropDown.dataSource = dataSource
        ThemesOptions.dropDown.anchorView = anchorView
        ThemesOptions.dropDown.bottomOffset = bottomOffset
        ThemesOptions.dropDown.cornerRadius = 10
        
        return ThemesOptions.dropDown
    }

}
