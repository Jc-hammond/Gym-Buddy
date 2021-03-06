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
    var buttonTitle: String?
    
    var event: Event?
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Actions
    @IBAction func cellButtonTapped(_ sender: UIButton) {
        guard let user = user else { return }
        
        if sender.titleLabel?.text == "invite", let event = event {
            EventController.shared.inviteTo(event: event, invitee: user) { result in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let event):
                        guard let event = event else {return}
                        print("Successfully invited \(user.fullName) to \(event.title)")
                        self.updateButtons(buttonTitle: "sent")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        if sender.titleLabel?.text == "RSVP", let event = event {
            EventController.shared.acceptInvite(event: event, user: user) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let event):
                        guard let event = event else {return}
                        print("\(user.fullName) is now attendint \(event.title)")
                        self.updateButtons(buttonTitle: "attending")
                    case .failure(let error):
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    }
                }
            }
        }
        
    }//end of func
    
    fileprivate func saveUser(user: User) {
        UserController.shared.saveUserUpdates(currentUser: user) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("successfully saved friendRequestRef for \(user.fullName)")
                case .failure(let error):
                    print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    //MARK: - Functions
    fileprivate func updateViews() {
        guard let buttonTitle = buttonTitle,
              let user = user else { return }
        
        profileImageView.addCornerRadius(radius: profileImageView.frame.height/2, width: 1)
        friendNameLabel.font = UIFont(name: FontNames.sfRoundedReg, size: 20)
        friendNameLabel.text = user.fullName
        cellButton.addCornerRadius(color: .clear)
        cellButton.setTitleColor(.white, for: .normal)
        
        updateButtons(buttonTitle: buttonTitle)
    }
    
    fileprivate func updateButtons(buttonTitle: String) {
        cellButton.setTitle(buttonTitle, for: .normal)
        if buttonTitle == "added" {
            cellButton.setBackgroundColor(.gray)
            cellButton.isEnabled = false
        } else if buttonTitle == "pending" || buttonTitle == "sent" || buttonTitle == "attending" {
            cellButton.setBackgroundColor(.gray)
            cellButton.setTitleColor(.black, for: .normal)
            cellButton.isEnabled = false
        } else if buttonTitle == "accept" || buttonTitle == "invite" || buttonTitle == "RSVP" || buttonTitle == "add friend" {
            cellButton.setBackgroundColor(.customLightGreen!)
            cellButton.isEnabled = true
        }
    }

}//End of class
