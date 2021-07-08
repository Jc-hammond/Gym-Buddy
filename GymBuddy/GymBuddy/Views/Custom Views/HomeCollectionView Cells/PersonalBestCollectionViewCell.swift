//
//  PersonalBestCollectionViewCell.swift
//  GymBuddy
//
//  Created by James Chun on 6/29/21.
//

import UIKit

class PersonalBestCollectionViewCell: UICollectionViewCell, CellRegisterable {
    //MARK: - Outlets
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    
    //MARK: - Properties
    var workout: Workout? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    //MARK: - Functions
    func updateViews() {
        guard let workout = workout else { return }
        
        self.addCornerRadius()
        titleTextView.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        titleTextView.textColor = .customDarkGreen
        titleTextView.text = workout.title
        dateLabel.font = UIFont(name: FontNames.sfRoundedUltralight, size: 16)
        dateLabel.textColor = .customDarkGreen
        dateLabel.text = workout.completionDate
        goalLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        goalLabel.textColor = .customLightGreen
        goalLabel.text = "\(workout.goal) \(workout.unit)"
    }

}//End of class
