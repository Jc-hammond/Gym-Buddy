//
//  MessagesTableViewCell.swift
//  GymBuddy
//
//  Created by James Chun on 6/22/21.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var newMessageImageView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
    }
    
    //MARK: - Functions
    fileprivate func updateViews() {
        nameLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 20)
        detailLabel.font = UIFont(name: FontNames.sfRoundedUltralight, size: 14)
        timestampLabel.font = UIFont(name: FontNames.sfRoundedUltralight, size: 14)
        
        profileImageView.addCornerRadius(radius: profileImageView.frame.size.width/2-22)
        profileImageView.layer.masksToBounds = true
    }
    

}//End of class
