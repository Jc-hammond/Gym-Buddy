//
//  FriendsListTableViewController.swift
//  GymBuddy
//
//  Created by James Chun on 6/21/21.
//

import UIKit
import CloudKit

class FriendsListTableViewController: UITableViewController {
   
    @IBOutlet weak var userSearchBar: UISearchBar!
    
    //MARK: - Properties
    //var buttonTitles: [String]?
    var allUsers: [User]?
    var friendRequests: [FriendRequest]?
    var friendReqArray: [[FriendRequest]] = [[],[]]
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userSearchBar.delegate = self
        
        navigationController?.navigationBar.tintColor = .customLightGreen
        
        fetchFriendRequestRefs()
//        fetchAllUsers()
        fetchPendingRequests()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchFriendRequestRefs()
//        fetchAllUsers()
    }
    
    //MARK: - Functions
    //FETCH ALL USERS, Only appear on search
    func fetchAllUsers() {
        let predicate = NSPredicate(value: true)
        UserController.shared.fetchUser(predicate: predicate) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    guard let users = users else { return }
                    let excludedUsers = users.filter { $0 != UserController.shared.currentUser }
                    let sortedUsers = excludedUsers.sorted{ $0.fullName < $1.fullName }
                    self.allUsers = sortedUsers
                    self.tableView.reloadData()
                case .failure(_):
                    print("No user found in publicDB")
                }
            }
        }
    }
    
    func fetchUserAndUpdateViews(for user: [User]) {
        guard let searchTerm = userSearchBar.text, !searchTerm.isEmpty else {return}
        UserController.shared.fetchUserFrom(searchTerm: searchTerm) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    guard let users = users else {return}
                    let excludedUsers = users.filter({$0 != UserController.shared.currentUser })
                    let sortedUsers = excludedUsers.sorted{ $0.fullName < $1.fullName }
                    self.allUsers = sortedUsers
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchFriendRequestRefs() {
        guard let currentUser = UserController.shared.currentUser,
              let friendRequestRefs = currentUser.friendRequestRefs else { return }
        
        FriendRequestController.shared.fetchFriendRequests(friendRequestRefs: friendRequestRefs) { result in
            switch result {
            case .success(let friendRequests):
                print("successfully fetched friendRequests")
                self.friendRequests = friendRequests
            case .failure(let error):
                print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    //FETCH PENDING REQUESTS
    func fetchPendingRequests() {
        guard let currentUser = UserController.shared.currentUser else {return}
        let pendingPredicate = NSPredicate(format: "%K==%@", argumentArray: [FriendRequestConstants.ownerUserRefKey, currentUser.recordID])
        
        FriendRequestController.shared.fetchRequestsForUser(predicate: pendingPredicate) { results in
            switch results {
            
            case .success(let requests):
                currentUser.friendRequests = requests
                _ = requests?.compactMap({$0.accepted})
                
               
                
//                guard let friendArray = currentUser.friendRequests else {return}
//                self.friendReqArray = [[], []]
//                for friend in friendArray {
//                    if !friend.accepted {
//                        self.friendReqArray[0].append(friend)
//                    } else {
//                        self.friendReqArray[1].append(friend)
//                    }
//                }
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //FETCH ACCEPTED REQUESTS
    
    func fetchAcceptedRequests() {
        
        
    }
    
    //FETCH SENT REQUESTS
    func fetchSentRequests() {
        
        
    }
    
    // MARK: - Table view data source
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return self.friendReqArray.count
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let allUsers = allUsers else { return 0 }
        return allUsers.count
//        return friendReqArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendTableViewCell else { return UITableViewCell() }
        
        guard let allUsers = allUsers,
              let currentUser = UserController.shared.currentUser else { return UITableViewCell() }
        
        let user = allUsers[indexPath.row]
        let userRef = CKRecord.Reference(recordID: user.recordID, action: .none)
        let friendRequestForUser = friendRequests?.filter{ $0.friendUserRef == userRef }.first
        
        if let friendRefs = currentUser.friendRefs,
           friendRefs.contains(userRef) {
            
            cell.buttonTitle = "added"
            
        } else if friendRequestForUser != nil {
            
            if friendRequestForUser!.ownerDidSend == true {
                cell.buttonTitle = "pending"
            } else {
                cell.buttonTitle = "accept"
            }
            
        } else {
            cell.buttonTitle = "add friend"
        }
        
        cell.friendRequest = friendRequestForUser
        cell.user = user
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/16
    }

    
}//End of class

extension FriendsListTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else {return}
        
        UserController.shared.fetchUserFrom(searchTerm: searchTerm) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    guard let user = user else {return}
                    self.fetchUserAndUpdateViews(for: user)
                    print(user)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
} //End of extension
























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

