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
    var friendRequest: FriendRequest?
    
    var event: Event?
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Actions
    @IBAction func cellButtonTapped(_ sender: UIButton) {
        guard let user = user,
              let currentUser = UserController.shared.currentUser else { return }
        
        if sender.titleLabel?.text == "accept" {
            guard let friendRequest = friendRequest else { return }
            FriendRequestController.shared.toggleFriendAcceptance(response: true, request: friendRequest) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        
                        self.updateButtons(buttonTitle: "added")
                        print("Successfully accepted friend request")
                    case .failure(let error):
                        print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                    }
                }
            }
        }
        
        if sender.titleLabel?.text == "add friend" {
            FriendRequestController.shared.createFriendRequest(friendUser: user) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let friendRequests):
                        guard let friendRequests = friendRequests,
                              let senderRequestRef = friendRequests[0].siblingRef,
                              let receiverRequestRef = friendRequests[1].siblingRef else { return }
                        
                        user.friendRequestRefs?.append(senderRequestRef)
                        currentUser.friendRequestRefs?.append(receiverRequestRef)
                        self.saveUser(user: user)
                        self.saveUser(user: currentUser)

                        self.updateButtons(buttonTitle: "pending")
                        print("Successfully sent friend request")
                        
                    case .failure(let error):
                        print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                    }
                }
            }
        }
        
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
        

        
//        if let randomInt = [0,1].shuffled().first {
//            cellButton.setTitle(buttonTitles[randomInt], for: .normal)
//            if randomInt == 0 {
//                cellButton.setBackgroundColor(.customLightGreen!)
//            } else {
//                cellButton.setBackgroundColor(.gray)
//            }
//        }
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
