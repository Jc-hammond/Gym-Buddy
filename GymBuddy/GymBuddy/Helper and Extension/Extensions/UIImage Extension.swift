//
//  UIImage Extension.swift
//  GymBuddy
//
//  Created by James Chun on 6/24/21.
//

import UIKit

extension UIImage {
    static func gradientImage(with bounds: CGRect) -> UIImage? {

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.customLightGreen?.cgColor ?? UIColor.cyan.cgColor, UIColor.customGreen?.cgColor ?? UIColor.green.cgColor]
        
        // This makes it horizontal
        gradientLayer.startPoint = CGPoint(x: 0.0,
                                        y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0,
                                        y: 0.5)

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
}
