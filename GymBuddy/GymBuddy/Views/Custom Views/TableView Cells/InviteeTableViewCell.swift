//
//  InviteeTableViewCell.swift
//  GymBuddy
//
//  Created by James Chun on 6/23/21.
//

import UIKit

class InviteeTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileStackView: UIStackView!
    
    //MARK: - Properites
    var attendee: User? {
        didSet {
            updateViews()            
        }
    }
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //MARK: - Functions
    fileprivate func updateViews() {
        guard let attendee = attendee else { return }
        nameLabel.text = attendee.fullName
        
        profileStackView.addCornerRadius()
        profileImageView.addCornerRadius(radius: profileImageView.frame.width / 2, width: 0, color: nil)
    }

}//End of class
