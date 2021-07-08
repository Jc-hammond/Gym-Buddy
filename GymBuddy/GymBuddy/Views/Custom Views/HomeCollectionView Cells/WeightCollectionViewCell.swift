//
//  WeightCollectionViewCell.swift
//  GymBuddy
//
//  Created by James Chun on 7/7/21.
//

import UIKit

class WeightCollectionViewCell: UICollectionViewCell, CellRegisterable {
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    //MARK: - Properties
    var currentUser: User? {
        didSet {
            updateViews()
        }
    }
    var itemNumber: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateViews() {
        guard let currentUser = currentUser,
              let currentWeight = currentUser.currentWeights?.last,
              let itemNumber = itemNumber else { return }
        self.addCornerRadius(radius: 16, width: 4)
        
        if itemNumber == 0 {
            titleLabel.text = "Current Weight"
            weightLabel.text = "\(currentWeight) lbs"
            emojiLabel.isHidden = true
            let detailText = currentUser.currentDates?.last == Date() ?
                "You added your weight today" :
                "You haven't added your weight since \(currentUser.currentDates?.last?.formatDate() ?? "")"
            detailLabel.text = detailText
        } else if itemNumber == 1 {
            titleLabel.text = "Target Weight"
            weightLabel.text = "\(currentUser.targetWeight) lbs"
            emojiLabel.isHidden = false
            let variance = (abs(currentWeight-currentUser.targetWeight) / ((currentWeight+currentUser.targetWeight) / 2)) * 100
            
            if variance < 5 {
                emojiLabel.text = "👍"
            } else if variance < 10 {
                emojiLabel.text = "👏"
            } else {
                emojiLabel.text = "🏋️‍♀️"
            }
            
            detailLabel.text = "You are within \(variance)% of your target weight"
        }
        
        titleLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 24)
        titleLabel.textColor = .customDarkGreen
        weightLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 36)
        weightLabel.textColor = .customLightGreen
        let width = emojiLabel.frame.width
        emojiLabel.addCornerRadius(radius: width/2, width: 1, color: .customDarkGreen)
        detailLabel.font = UIFont(name: FontNames.sfRoundedReg, size: 12)
        
        
    }//end of func

}//End of class
