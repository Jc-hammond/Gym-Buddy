//
//  UIButton Extension.swift
//  GymBuddy
//
//  Created by James Chun on 6/22/21.
//

import UIKit

extension UIButton {
    
    func setInsets(
        forImagePadding imagePadding: CGFloat,
        equalWidthConstant: CGFloat,
        titlePadding: CGFloat
    ) {
        self.imageEdgeInsets = UIEdgeInsets(
            top: imagePadding,
            left: self.frame.width * equalWidthConstant,
            bottom: imagePadding,
            right: imagePadding)
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -titlePadding,
            bottom: 0,
            right: 0
        )
    }
    
}//End of extension
