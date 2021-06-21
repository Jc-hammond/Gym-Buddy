//
//  StyleGuide.swift
//  GymBuddy
//
//  Created by James Chun on 6/21/21.
//

import UIKit

extension UIColor {
    static let customDarkGreen = UIColor(named: "custom dark green")
    static let customGreen = UIColor(named: "custom green")
    static let customLightGreen = UIColor(named: "custom light green")
    static let customWhite = UIColor(named: "custom white")
}

struct FontNames {
    static let sfRoundedReg = "SF Pro Rounded Regular"
    static let sfRoundedSemiBold = "SF Pro Rounded Semibold"
    static let sfRoundedUltralight = "SF Pro Rounded Ultralight"
}

extension UIImage {
    //MARK: Tabbar Icons
    static let home = UIImage(named: "icons8-home_page")
    static let homeFilled = UIImage(named: "icons8-home_page_filled")
    static let progress = UIImage(named: "icons8-goal")
    static let progressFilled = UIImage(named: "icons8-goal_filled")
    static let addGoal = UIImage(named: "icons8-ingredients_list")
    static let addGoalFilled = UIImage(named: "icons8-ingredients_list_filled")
    static let events = UIImage(named: "icons8-tear_off_calendar")
    static let eventsFilled = UIImage(named: "icons8-tear_off_calendar_filled")
    static let message = UIImage(named: "icons8-filled_chat")
    static let messageFilled = UIImage(named: "icons8-filled_chat_filled")
    
    //MARK: Other Icons
    static let addMessage = UIImage(named: "icons8-add_to_chat")
    static let addMessageFilled = UIImage(named: "icons8-add_to_chat_filled")
    static let chevronUp = UIImage(named: "icons8-chevron_up_filled")
    static let chevronDown = UIImage(named: "icons8-chevron_down_filled")
    static let chvronLeft = UIImage(named: "icons8-chevron_left")
    static let chevronRight = UIImage(named: "icons8-chevron_right")
    static let add = UIImage(named: "icons8-plus_filled")
    static let search = UIImage(named: "icons8-search_filled")
    static let person = UIImage(named: "icons8-person_male")
}
