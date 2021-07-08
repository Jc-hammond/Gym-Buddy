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

extension UIView {
    //JCHUN - Always use an anchor func for programatic constraints!
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingBottom: CGFloat, paddingLeading: CGFloat, paddingTrailing: CGFloat, width: CGFloat? = nil, height: CGFloat? = nil) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let leading = leading {
            self.leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
        }
        
        if let trailing = trailing {
            self.trailingAnchor.constraint(equalTo: trailing, constant: -paddingTrailing).isActive = true //constant must be negative for trailing
            
        }
        
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }//end of func
    
    func anchorCenter(x: NSLayoutXAxisAnchor?, y: NSLayoutYAxisAnchor?, paddingX: CGFloat, paddingY: CGFloat, width: CGFloat? = nil, height: CGFloat? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let x = x {
            self.centerXAnchor.constraint(equalTo: x, constant: paddingX).isActive = true
        }
        
        if let y = y {
            self.centerYAnchor.constraint(equalTo: y, constant: -paddingY).isActive = true
        }
        
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
}//End of extension

extension UIView {
    var parentViewContoller: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as? UIViewController
            }
        }
        
        return nil
    }//end of func
    
}//End of extension

extension UIView {
    func blink(duration: Double = 1.5) {
        let blinkAnimation = CABasicAnimation(keyPath: "opacity")
        blinkAnimation.fromValue = 0.5
        blinkAnimation.toValue = 1.0
        blinkAnimation.isCumulative = true
        blinkAnimation.duration = duration
        blinkAnimation.repeatCount = Float.infinity
        
        layer.add(blinkAnimation, forKey: nil)
    }

}
