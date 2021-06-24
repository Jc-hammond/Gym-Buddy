//
//  UITextField Extension.swift
//  GymBuddy
//
//  Created by James Chun on 6/23/21.
//

import UIKit

extension UITextField {
    func updatePlaceHolder(fontName: String, size: CGFloat) {
        let currentPlaceHolderText = self.placeholder
        self.attributedPlaceholder = NSAttributedString(string: currentPlaceHolderText ?? "",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray,
                         NSAttributedString.Key.font : UIFont(name: fontName, size: size)!])
    }
}
