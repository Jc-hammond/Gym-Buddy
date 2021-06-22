//
//  UIView Extension.swift
//  GymBuddy
//
//  Created by James Chun on 6/21/21.
//

import UIKit

extension UIView {
    
    func addCornerRadius(radius: CGFloat = 8, width: CGFloat = 2, color: UIColor? = UIColor.customLightGreen) {
        guard let color = color else { return }
        self.layer.cornerRadius = radius
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func setBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }
    
    
}//End of extension
