//
//  WeightCollectionViewCell.swift
//  GymBuddy
//
//  Created by James Chun on 7/7/21.
//

import UIKit

class HoursCollectionViewCell: UICollectionViewCell, CellRegisterable {
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
//    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var detailLabelContainer: UIView!
    @IBOutlet weak var detailLabel: UILabel!
    
    //MARK: - Properties
    var currentUser: User?
    var itemNumber: Int? {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Functions
    func updateViews() {
        guard let currentUser = currentUser,
              let itemNumber = itemNumber else { return }
        
        self.addCornerRadius(radius: 16, width: 4)
        self.backgroundColor = .customLightGreen
        
        var weeklyHours: Int {
            if let weeklyHours = addHoursForCurrentWeek(currentUser: currentUser) {
                return weeklyHours
            } else {
                return 0
            }
        }
        
        if itemNumber == 0 {
            titleLabel.text = "Hours Worked Out This Week"
            hoursLabel.text = weeklyHours == 1 ? "\(weeklyHours)\nhour" : "\(weeklyHours)\nhours"
//            emojiLabel.isHidden = true
//            let detailText = currentUser.currentDates?.last?.formatDate() == Date().formatDate() && (currentUser.hoursWorkedOut?.last)! > 0 ?
//                "You worked out today 😀" :
//                currentUser.currentDates != nil ?
//                "You haven't worked out since \(currentUser.currentDates?.last?.formatDate() ?? "")" :
//                "Welcome! You can start adding your workout goals."
            
            var detailText: String {
                guard let hoursWorkedOut = currentUser.hoursWorkedOut,
                      let lastHours = hoursWorkedOut.last else { return "error found..."}
                
                if hoursWorkedOut.count == 1 && lastHours == 0 {
                    return "Welcome! Start adding your workout goals."
                } else if currentUser.currentDates?.last?.formatDate() == Date().formatDate() && lastHours > 0 {
                    if lastHours == 1 {
                        return "You worked out \(lastHours) hour today"
                    } else {
                        return "Your worked out \(lastHours) hours today"
                    }
                }
                
                return "You haven't worked out since \(currentUser.currentDates?.last?.formatDate() ?? "")"
            }
            
            detailLabel.text = detailText
        } else if itemNumber == 1 {
            titleLabel.text = "Weekly Target Hours"
            hoursLabel.text = currentUser.targetHours == 1 ? "\(currentUser.targetHours)\nhour" : "\(currentUser.targetHours)\nhours"
//            emojiLabel.isHidden = true
//            let currentWeightD = Double(weeklyHours)
//            let targetWeightD = Double(currentUser.targetHours)
//            let variance: Double = (abs(currentWeightD-targetWeightD) / ((currentWeightD+targetWeightD) / 2)) * 100
//
//            if variance < 5 {
//                emojiLabel.text = "👍"
//            } else if variance < 10 {
//                emojiLabel.text = "👏"
//            } else {
//                emojiLabel.text = "🏋️‍♀️"
//            }
            
            detailLabel.text = "Click here to change your target hours"
        }
        
        titleLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 20)
        titleLabel.textColor = .customDarkGreen
        hoursLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 36)
        hoursLabel.textColor = .white
//        let width = emojiLabel.frame.width
//        emojiLabel.clipsToBounds = true
//        emojiLabel.addCornerRadius(radius: width/2, width: 1, color: .customLightGreen)
//        emojiLabel.backgroundColor = .white
        detailLabel.font = UIFont(name: FontNames.sfRoundedReg, size: 14)
        detailLabel.textColor = .customDarkGreen
        detailLabelContainer.addCornerRadius(color: .customDarkGreen)
    }//end of func
    
    func addHoursForCurrentWeek(currentUser: User) -> Int? {
        guard var index = getFirstDayOfWeekIndex(currentUser: currentUser),
              let numOfHours = currentUser.hoursWorkedOut?.count,
              let hoursWorkedOut = currentUser.hoursWorkedOut else { return nil }
        
        let lastIndex = numOfHours - 1
        
        var totalWeeklyHours = 0
        while index <= lastIndex {
            totalWeeklyHours += hoursWorkedOut[index]
            index += 1
        }
        
        return totalWeeklyHours
    }
    
    func getFirstDayOfWeekIndex(currentUser: User) -> Int? {
        guard let currentDates = currentUser.currentDates,
              let numOfDates = currentUser.currentDates?.count else { return 0 }
        
        let monday = Date().getMonday()
        var lastIndex = numOfDates - 1
        
        //JCHUN - fix the while loop
        while lastIndex >= 0 {
            if monday > currentDates[lastIndex] {
                return currentDates.firstIndex(of: currentDates[lastIndex])! + 1
            }
            lastIndex -= 1
        }
        
        return 0
    }//end of func

}//End of class
