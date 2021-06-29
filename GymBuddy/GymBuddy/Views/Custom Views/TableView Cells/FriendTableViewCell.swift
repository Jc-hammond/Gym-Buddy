//
//  FriendTableViewCell.swift
//  GymBuddy
//
//  Created by James Chun on 6/29/21.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var cellButton: UIButton!
    
    //MARK: - Properties
    var buttonTitles: [String]? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Functions
    fileprivate func updateViews() {
        guard let buttonTitles = buttonTitles else { return }
        profileImageView.addCornerRadius(radius: profileImageView.frame.height/2, width: 1)
        friendNameLabel.font = UIFont(name: FontNames.sfRoundedReg, size: 20)
//        friendNameLabel.text =
        cellButton.addCornerRadius(color: .clear)
        cellButton.setTitleColor(.white, for: .normal)
        
        if let randomInt = [0,1].shuffled().first {
            cellButton.setTitle(buttonTitles[randomInt], for: .normal)
            if randomInt == 0 {
                cellButton.setBackgroundColor(.customLightGreen!)
            } else {
                cellButton.setBackgroundColor(.gray)
            }
        }
        
    }

}//End of class
