//
//  CellView.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 16.02.2023.
//

import UIKit

class RecipeTableView: UIView {
    
    override func layoutSubviews() {
            super.layoutSubviews()
        roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 20)
        }
    
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

