//
//  XAxisFormatter.swift
//  GymBuddy
//
//  Created by James Chun on 7/8/21.
//

import Foundation
import Charts

final class XAxisNameFormater: NSObject, IAxisValueFormatter {

    func stringForValue( _ value: Double, axis _: AxisBase?) -> String {

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd.MM"

        return formatter.string(from: Date(timeIntervalSince1970: value))
    }

}
