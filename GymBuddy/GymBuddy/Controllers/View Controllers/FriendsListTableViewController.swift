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

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .customLightGreen
        
        fetchAllUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchAllUsers()
    }

    //MARK: - Functions
    func fetchAllUsers() {
        let predicate = NSPredicate(value: true)
        UserController.shared.fetchProfile(predicate: predicate) { result in
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
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let allUsers = allUsers else { return 0 }
        return allUsers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendTableViewCell else { return UITableViewCell() }
        
        guard let allUsers = allUsers,
              let currentUser = UserController.shared.currentUser else { return UITableViewCell() }
                
        for user in allUsers {
            if currentUser.friends.contains(user) {
                cell.buttonTitle = "added"
            } else if let currentUserFriendRequests = currentUser.friendRequests {
                for friendRequest in currentUserFriendRequests {
                    if friendRequest.accepted == false && friendRequest.ownerDidSend == true {
                        cell.buttonTitle = "pending"
                    } else if friendRequest.accepted == false && friendRequest.ownerDidSend == false {
                        cell.buttonTitle = "accept"
                    }
                }
            } else {
                cell.buttonTitle = "add friend"
            }
        }
        
        let user = allUsers[indexPath.row]
        
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
