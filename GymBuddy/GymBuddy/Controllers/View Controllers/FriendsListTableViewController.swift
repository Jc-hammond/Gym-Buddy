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
    var originVC: String?
    var event: Event?
    var attendees: [User]?
    var invitees: [User]?
    var blockedUsers: [User]?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .customLightGreen
        
        fetchAllUsersAndMyFriendReqs()
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
                    self.tableView.reloadData()

                    self.fetchBlockedUsers(sortedUsers: sortedUsers)
      
                case .failure(_):
                    print("No user found in publicDB")
                }
            }
        }
    }
    
    func fetchBlockedUsers(sortedUsers: [User]) {
        guard let user = UserController.shared.currentUser,
              let blockedRefs = user.blockedUserRefs else {return}
        
        EventController.shared.fetchEventAttendees(attendeeRefs: blockedRefs) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let blockedUsers):
                    guard let blockedUsers = blockedUsers else {return}
                    self.blockedUsers = blockedUsers
                    var sortedUsers = sortedUsers

                    for user in sortedUsers {
                        guard let blockedUsers = self.blockedUsers else {return}
                        if blockedUsers.contains(user) {
                            guard let index = sortedUsers.firstIndex(of: user) else {return}
                            sortedUsers.remove(at: index)
                        }
                    }
                    self.allUsers = sortedUsers
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
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
        
        guard let allUsers = allUsers else { return UITableViewCell() }
        
        let user = allUsers[indexPath.row]
        
        if originVC == "EventDetailVC" {
            cell.buttonTitle = "invite"
        }
        
        if let event = event {
            cell.event = event
        }
        
        cell.user = user
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/16
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        func handleBlockUser () {
            guard let allUsers = allUsers else {return}
            let user = allUsers[indexPath.row]
            guard let currentUser = UserController.shared.currentUser else {return}
            let blockUserRef = CKRecord.Reference(recordID: user.recordID, action: .none)
            if currentUser.blockedUserRefs != nil {
                currentUser.blockedUserRefs?.append(blockUserRef)
            } else {
                currentUser.blockedUserRefs = [blockUserRef]
            }
            UserController.shared.saveUserUpdates(currentUser: currentUser) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        guard let index = self.allUsers?.firstIndex(of: user) else {return}
                        self.allUsers?.remove(at: index)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        self.tableView.reloadData()
                    case .failure(let error):
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    }
                }
            }
            print("user blocked")
        }
        let action = UIContextualAction(style: .destructive, title: "Block") { action, view, completion in
            handleBlockUser()
            completion(true)
        }
        action.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
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

