//
//  EventsTableViewCell.swift
//  GymBuddy
//
//  Created by James Chun on 6/23/21.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var attendanceStatusLabel: UILabel!
    @IBOutlet weak var changeableImageView: UIImageView!
    
    //MARK: - Properties
    var sectionNumber: Int? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        //updateViews()
    }


    //MARK: - Functions
    fileprivate func updateViews() {
        guard let sectionNumber = sectionNumber else { return }
        
        eventTitleLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 20)
        eventDateLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        eventTimeLabel.font = UIFont(name: FontNames.sfRoundedUltralight, size: 14)
        attendanceStatusLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 14)
        attendanceStatusLabel.textColor = .gray
        ownerLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 12)
        ownerLabel.textColor = .customLightGreen
        
        if sectionNumber == 0 {
            ownerLabel.isHidden = false
            changeableImageView.image = #imageLiteral(resourceName: "icons8-chevron_right-40")
        } else {
            ownerLabel.isHidden = true
            changeableImageView.image = #imageLiteral(resourceName: "rsvp")
        }
    }
    
}//End of class
