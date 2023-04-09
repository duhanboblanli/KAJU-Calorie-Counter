//
//  Images.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 9.04.2023.
//

import Foundation
import UIKit

enum Images {
    case Placeholder
    
    var associatedImage: UIImage {
        switch self {
        case .Placeholder:
            return UIImage(named: "imagePlaceholder") ?? UIImage.add
            
        }
    }
}
