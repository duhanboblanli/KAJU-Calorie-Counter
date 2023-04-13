//
//  Constants.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 8.04.2023.
//

import Foundation
import UIKit

// Color Usage
// For UIColor --> ThemeColors.ColorLightGreen.associatedColor
// For CGColor --> ThemeColors.ColorLightGreen.CGColorTyoe

enum ThemeColors {
    case colorLightGreen
    case colorGreen
    case colorDarkGreen
    case colorHardDarkGreen
    
    //If using color with type UIcolor.
    var associatedColor: UIColor {
        switch self {
            //rgb(132, 198, 155)
        case .colorLightGreen:
            return UIColor(named: "ColorLightGreen") ?? .white
            //rgb(47, 136, 134)
        case .colorGreen:
            return UIColor(named: "ColorGreen") ?? .white
            //rgb(40, 71, 92)
        case .colorDarkGreen:
            return UIColor(named: "ColorDarkGreen") ?? .white
            //rgb(26, 47, 75)
        case .colorHardDarkGreen:
            return UIColor(named: "ColorHardDarkGreen") ?? .white
        }
    }
    
    //If using color with type CGcolor.
    var CGColorType: CGColor {
        switch self {
            //rgb(132, 198, 155)
        case .colorLightGreen:
            return UIColor(named: "ColorLightGreen")?.cgColor ?? CGColor(red: 1, green: 1, blue: 1, alpha: 1)
            //rgb(47, 136, 134)
        case .colorGreen:
            return UIColor(named: "ColorGreen")?.cgColor ?? CGColor(red: 1, green: 1, blue: 1, alpha: 1)
            //rgb(40, 71, 92)
        case .colorDarkGreen:
            return UIColor(named: "ColorDarkGreen")?.cgColor ?? CGColor(red: 1, green: 1, blue: 1, alpha: 1)
            //rgb(26, 47, 75)
        case .colorHardDarkGreen:
            return UIColor(named: "ColorHardDarkGreen")?.cgColor ?? CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}

enum SpecialColors {
    case strokeColorDarkGreen
    //If using color with type UIcolor.
    var associatedColor: UIColor {
        switch self {
            //rgb(47, 160, 134)
        case .strokeColorDarkGreen:
            return UIColor( red: 47/255, green: 160/255, blue: 134/255, alpha: 1)
        }
    }
    //If using color with type CGcolor.
    var CGColorType: CGColor {
        switch self {
            //rgb(47, 160, 134)
        case .strokeColorDarkGreen:
            return UIColor( red: 47/255, green: 160/255, blue: 134/255, alpha: 1).cgColor
        }
    }
}
