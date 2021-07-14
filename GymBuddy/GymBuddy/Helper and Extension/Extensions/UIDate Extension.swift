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
    
    func formatTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        return formatter.string(from: self)
    }
    
    func getMonday() -> Date {
        let cal = Calendar.current
        var comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: self)
        comps.weekday = 2 // Monday
        let mondayInWeek = cal.date(from: comps)!
        return mondayInWeek
    }
    
}//End of extension
