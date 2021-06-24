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
    
}//End of extension
