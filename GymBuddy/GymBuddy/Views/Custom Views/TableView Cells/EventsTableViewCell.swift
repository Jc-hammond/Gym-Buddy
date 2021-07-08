//
//  EventsTableViewCell.swift
//  GymBuddy
//
//  Created by James Chun on 6/23/21.
//

import UIKit
import CloudKit

class EventsTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var attendanceStatusLabel: UILabel!
    @IBOutlet weak var changeableButton: UIButton!
    
    
    //MARK: - Properties
    var sectionNumber: Int?
    
    var event: Event? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Actions
    @IBAction func rsvpButtonTapped(_ sender: UIButton) {
        guard let sectionNumber = sectionNumber,
              sectionNumber == 1,
              let event = event,
              let currentUser = UserController.shared.currentUser else { return }
        
        EventController.shared.acceptInvite(event: event, user: currentUser) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let event):
                    guard let event = event else { return }
                    print("\(currentUser.fullName) is now attending \(event.title)")
                    self.changeableButton.setImage(nil, for: .normal)
                    self.changeableButton.setTitle("attending", for: .normal)
                    self.changeableButton.titleLabel?.font = UIFont(name: FontNames.sfRoundedReg, size: 10)
                    self.changeableButton.addCornerRadius(color: .gray)
                    self.changeableButton.setBackgroundColor(.gray)
                case .failure(let error):
                    print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
        
    }

    //MARK: - Functions
    fileprivate func updateViews() {
        guard let sectionNumber = sectionNumber,
              let event = event else { return }
        eventTitleLabel.text = event.title
        emojiLabel.text = event.emoji
        eventDateLabel.text = event.date.formatDate()
        eventTimeLabel.text = event.date.formatTime()
        ownerLabel.isHidden = event.userRef == UserController.shared.currentUser?.recordID ? false : true
        attendanceStatusLabel.text = "\(event.attendeeRefs?.count ?? 0) attending"
        
        eventTitleLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 20)
        eventDateLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        eventTimeLabel.font = UIFont(name: FontNames.sfRoundedUltralight, size: 14)
        attendanceStatusLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 14)
        attendanceStatusLabel.textColor = .gray
        ownerLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 12)
        ownerLabel.textColor = .customLightGreen
        changeableButton.tintColor = .customLightGreen
        changeableButton.setTitleColor(.white, for: .normal)
        
        if sectionNumber == 0 || changeableButton.titleLabel?.text == "attending" {
            if event.userRef.recordID == UserController.shared.currentUser?.recordID {
                ownerLabel.isHidden = false
                changeableButton.setImage(#imageLiteral(resourceName: "icons8-chevron_right-40"), for: .normal)
                changeableButton.isEnabled = false
            } else {
                ownerLabel.isHidden = true
                self.changeableButton.setImage(nil, for: .normal)
                self.changeableButton.setTitle("attending", for: .normal)
                self.changeableButton.titleLabel?.font = UIFont(name: FontNames.sfRoundedReg, size: 10)
                self.changeableButton.addCornerRadius(color: .gray)
                self.changeableButton.setBackgroundColor(.gray)
                changeableButton.isEnabled = false
            }
        } else {
            ownerLabel.isHidden = true
            changeableButton.setImage(#imageLiteral(resourceName: "rsvp"), for: .normal)
            changeableButton.isEnabled = true
        }
    }
    
}//End of class
