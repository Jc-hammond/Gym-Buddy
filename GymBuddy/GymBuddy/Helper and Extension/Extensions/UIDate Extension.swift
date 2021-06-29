//
//  UIDate Extension.swift
//  GymBuddy
//
//  Created by Connor Hammond on 6/29/21.
//

import Foundation

extension Date {
    
    //Format a date into string using dataStyle.short & timeStyle.short
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        return formatter.string(from: self)
    }
}//End of extension
