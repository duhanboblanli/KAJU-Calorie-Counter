//
//  CircleButton.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 27.02.2023.
//

import UIKit

@IBDesignable
class CircleButton: UIView {

    private let trackLayer = CAShapeLayer()

    @IBInspectable var lineWidth:   CGFloat = 5          { didSet { updatePath() } }
    @IBInspectable var fillColor:   UIColor = .clear     { didSet { trackLayer.fillColor   = fillColor.cgColor } }
    @IBInspectable var strokeColor: UIColor = .lightGray { didSet { trackLayer.strokeColor = strokeColor.cgColor  } }
    @IBInspectable var strokeStart: CGFloat = 0          { didSet { trackLayer.strokeStart = strokeStart } }
    @IBInspectable var strokeEnd:   CGFloat = 1          { didSet { trackLayer.strokeEnd   = strokeEnd } }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        trackLayer.fillColor   = fillColor.cgColor
        trackLayer.strokeColor = strokeColor.cgColor
        trackLayer.strokeStart = strokeStart
        trackLayer.strokeEnd   = strokeEnd

        layer.addSublayer(trackLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        updatePath()
    }

    private func updatePath() {
        let arcCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) - lineWidth) / 2
        trackLayer.lineWidth = lineWidth
        trackLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath

        // There's no need to rotate it if you're drawing a complete circle.
        // But if you're going to transform, set the `frame`, too.

        trackLayer.transform = CATransform3DIdentity
        trackLayer.frame = bounds
        trackLayer.transform = CATransform3DMakeRotation(-.pi / 2, 0, 0, 1)
    }
}
