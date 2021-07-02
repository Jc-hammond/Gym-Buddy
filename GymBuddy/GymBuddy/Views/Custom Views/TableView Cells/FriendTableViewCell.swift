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
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Actions
    @IBAction func cellButtonTapped(_ sender: UIButton) {
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
            guard let user = user else { return }
            FriendRequestController.shared.createFriendRequest(friendUser: user) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let friendRequests):
                        guard let friendRequest = friendRequests?.first else { return }
                        guard let currentUser = UserController.shared.currentUser else { return }
                        currentUser.friendRequests?.append(friendRequest)
                        self.updateButtons(buttonTitle: "pending")
                        print("Successfully sent friend request")
                    case .failure(let error):
                        print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                    }
                }
            }
        }
    }//end of func
    
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
        } else if buttonTitle == "pending" {
            cellButton.setBackgroundColor(.gray)
            cellButton.setTitleColor(.black, for: .normal)
            cellButton.isEnabled = false
        } else if buttonTitle == "accept" {
            cellButton.setBackgroundColor(.customLightGreen!)
            cellButton.isEnabled = true
        } else if buttonTitle == "add friend" {
            cellButton.setBackgroundColor(.customLightGreen!)
            cellButton.isEnabled = true
        }
    }

}//End of class
