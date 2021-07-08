//
//  UILabel Extension.swift
//  GymBuddy
//
//  Created by James Chun on 6/22/21.
//

import UIKit

extension UILabel {
    
    func underline() {
        if let text = self.text {
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
            let underlineAttributedString = NSAttributedString(string: text, attributes: underlineAttribute)
            self.attributedText = underlineAttributedString
        }
    }
    
    func startBlink() {
        self.alpha = 0.0;
        UIView.animate(withDuration: 0.8, //Time duration you want,
                            delay: 0.0,
                            options: [.curveEaseInOut, .autoreverse, .repeat],
                       animations: { [weak self] in self?.alpha = 1.0 },
                       completion: { [weak self] _ in self?.alpha = 0.0 })
    }

    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }

    
}//End of extension
