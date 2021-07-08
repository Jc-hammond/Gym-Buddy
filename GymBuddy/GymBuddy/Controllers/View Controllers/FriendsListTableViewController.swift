//
//  FriendsListTableViewController.swift
//  GymBuddy
//
//  Created by James Chun on 6/21/21.
//

import UIKit
import CloudKit

class FriendsListTableViewController: UITableViewController {
    //MARK: - Properties
    //var buttonTitles: [String]?
    var allUsers: [User]?
    var friendRequests: [FriendRequest]?
    var originVC: String?
    var event: Event?
    var attendees: [User]?
    var invitees: [User]?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .customLightGreen
        
//        fetchFriendRequests()
//        fetchAllUsers()
        fetchAllUsersAndMyFriendReqs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        fetchFriendRequests()
        //fetchAllUsersAndMyFriendReqs()
    }
    
    //MARK: - Functions
    func fetchAllUsersAndMyFriendReqs() {
        let predicate = NSPredicate(value: true)
        UserController.shared.fetchProfile(predicate: predicate) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    guard let users = users else { return }
                    let excludedUsers = users.filter { $0 != UserController.shared.currentUser }
                    var sortedUsers = excludedUsers.sorted{ $0.fullName < $1.fullName }
//                    guard let event = self.event else {return}
//                    let containsInviteeIDs = event.
//                    users.removeAll(where: {$0 == containsInviteeIDs)
                    for user in sortedUsers {
                        guard let attendees = self.attendees else {return}
                        if attendees.contains(user) {
                            guard let index = sortedUsers.firstIndex(of: user) else {return}
                            sortedUsers.remove(at: index)
                        }
                    }
                    
                    for user in sortedUsers {
                        guard let invitees = self.invitees else {return}
                        if invitees.contains(user) {
                            guard let index = sortedUsers.firstIndex(of: user) else {return}
                            sortedUsers.remove(at: index)
                        }
                    }
                    
                    self.allUsers = sortedUsers
//                    self.fetchFriendRequests()
                    self.tableView.reloadData()
                case .failure(_):
                    print("No user found in publicDB")
                }
            }
        }
    }
    
    func fetchFriendRequests() {
        guard let currentUser = UserController.shared.currentUser,
              let friendRequestRefs = currentUser.friendRequestRefs else { return }
        
        FriendRequestController.shared.fetchFriendRequests(friendRequestRefs: friendRequestRefs) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let friendRequests):
                    print("successfully fetched friendRequests")
                    self.friendRequests = friendRequests
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let allUsers = allUsers else { return 0 }
        return allUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendTableViewCell else { return UITableViewCell() }
        
        guard let allUsers = allUsers,
              let currentUser = UserController.shared.currentUser else { return UITableViewCell() }
        
        let user = allUsers[indexPath.row]
        let userRef = CKRecord.Reference(recordID: user.recordID, action: .none)
        let friendRequestForUser = friendRequests?.filter{ $0.friendUserRef == userRef }.first
        
        if originVC == "EventDetailVC" {
            cell.buttonTitle = "invite"
            
        } else {
            if let friendRefs = currentUser.friendRefs,
               friendRefs.contains(userRef) {
                
                cell.buttonTitle = "added"
                
            } else if let friendRequestRefs = currentUser.friendRequestRefs,
                      friendRequestRefs.contains(userRef) {
                
            }
            
            else if friendRequestForUser != nil {
                if friendRequestForUser!.ownerDidSend == true {
                    cell.buttonTitle = "pending"
                } else {
                    cell.buttonTitle = "accept"
                }
            }
            
            else {
                cell.buttonTitle = "add friend"
            }
        }
        
        if let event = event {
            cell.event = event
        }
        
        
        cell.friendRequest = friendRequestForUser
        cell.user = user
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/16
    }
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
}//End of class


























//        for user in allUsers {
//            if currentUser.friends.contains(user) {
//                cell.buttonTitle = "added"
//            }
//
//            let userRef = CKRecord.Reference(recordID: user.recordID, action: .none)
//            if currentUser.friendRequestRefs?.contains(userRef) {
//
//            }
//

//            else if let currentUserFriendRequests = currentUser.friendRequests {
//
//
//
//                for friendRequest in currentUserFriendRequests {
//
//                    if friendRequest.friendUserRef.recordID == user.recordID && friendRequest.accepted == false {
//                        cell.buttonTitle = "pending"
//                    }
//
//                    else if



//                    if friendRequest.accepted == false && friendRequest.ownerDidSend == true {
//                        cell.buttonTitle = "pending"
//                    } else if friendRequest.accepted == false && friendRequest.ownerDidSend == false {
//                        cell.buttonTitle = "accept"
//                    }

//
//                }
//            } else {
//                cell.buttonTitle = "add friend"
//            }
//        }

