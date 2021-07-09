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
    
    func updateViews() {
        guard let currentUser = currentUser,
              let currentWeight = currentUser.currentWeights?.last,
              let itemNumber = itemNumber else { return }
        self.addCornerRadius(radius: 16, width: 4)
        self.backgroundColor = .customLightGreen
        
        if itemNumber == 0 {
            titleLabel.text = "Current Weight"
            weightLabel.text = "\(currentWeight) lbs"
            emojiLabel.isHidden = true
            let detailText = currentUser.currentDates?.last?.formatDate() == Date().formatDate() ?
                "You added your weight today" :
                currentUser.currentDates != nil ?
                "You haven't added your weight since \(currentUser.currentDates?.last?.formatDate() ?? "")" :
                "Please add your current weight"
            detailLabel.text = detailText
        } else if itemNumber == 1 {
            titleLabel.text = "Target Weight"
            weightLabel.text = "\(currentUser.targetWeight) lbs"
            emojiLabel.isHidden = true
            let currentWeightD = Double(currentWeight)
            let targetWeightD = Double(currentUser.targetWeight)
            let variance: Double = (abs(currentWeightD-targetWeightD) / ((currentWeightD+targetWeightD) / 2)) * 100
            
            if variance < 5 {
                emojiLabel.text = "👍"
            } else if variance < 10 {
                emojiLabel.text = "👏"
            } else {
                emojiLabel.text = "🏋️‍♀️"
            }
            
            detailLabel.text = "Click here to change your target weight"
            detailLabel.textColor = .white
        }
        
        titleLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 20)
        titleLabel.textColor = .customDarkGreen
        weightLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 36)
        weightLabel.textColor = .white
        let width = emojiLabel.frame.width
        emojiLabel.clipsToBounds = true
        emojiLabel.addCornerRadius(radius: width/2, width: 1, color: .customLightGreen)
        emojiLabel.backgroundColor = .white
        detailLabel.font = UIFont(name: FontNames.sfRoundedReg, size: 14)
        detailLabelContainer.addCornerRadius(color: .customDarkGreen)
    }//end of func

}//End of class
