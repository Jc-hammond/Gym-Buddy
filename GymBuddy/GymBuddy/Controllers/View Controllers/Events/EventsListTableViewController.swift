//
//  EventsTableViewController.swift
//  GymBuddy
//
//  Created by James Chun on 6/21/21.
//

import UIKit

class EventsListTableViewController: UITableViewController {
    //MARK: - Outlets

    //MARK: - Properties
    let sections: [String] = ["My Events", "Invited"]
    var allEvents: [[Event]] = [[], []]
    
    var refresh: UIRefreshControl = UIRefreshControl()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        //fetchAllEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchAllEvents()
    }
        
    //MARK: - Function
    fileprivate func fetchAllEvents() {
        guard let currentUserRef = UserController.shared.currentUserRef else { return }
        allEvents = [[], []]

        let ownerPredicate = NSPredicate(format: "%K == %@", EventStrings.userRefKey, currentUserRef)
        
        EventController.shared.fetchEvent(predicate: ownerPredicate) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let myEents):
                    guard let myEvents = myEents else { return }
                    self.allEvents[0] = myEvents
                    self.fetchAttendingEvents()
                    
                case .failure(let error):
                    print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                    self.fetchAttendingEvents()
                }
            }
        }
    }//end of func
    
    func fetchAttendingEvents() {
        guard let currentUserRef = UserController.shared.currentUserRef else { return }
        let attendeesPredicate = NSPredicate(format: "%K CONTAINS %@", EventStrings.attendeeRefsKey, currentUserRef)
        
        EventController.shared.fetchEvent(predicate: attendeesPredicate) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let attendingEvents):
                    guard let attendingEvents = attendingEvents else { return }
                    attendingEvents.forEach { self.allEvents[0].append($0) }
                    self.fetchInvitedEvents()
                    
                case .failure(let error):
                    print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                    self.fetchInvitedEvents()
                }
            }
        }
    }//end of func
    
    func fetchInvitedEvents() {
        guard let currentUserRef = UserController.shared.currentUserRef else { return }
        let inviteesPredicate = NSPredicate(format: "%K CONTAINS %@", EventStrings.inviteeRefsKey, currentUserRef)
        
        EventController.shared.fetchEvent(predicate: inviteesPredicate) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let invitedEvents):
                    guard let invitedEvents = invitedEvents else { return }
                    self.allEvents[1] = invitedEvents
                    self.tableView.reloadData()
                    self.refresh.endRefreshing()

                case .failure(let error):
                    print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                    self.tableView.reloadData()
                    self.refresh.endRefreshing()
                }
            }
        }
    }//end of func
    
    func setupViews() {
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh events")
        refresh.addTarget(self, action: #selector(loadEvents), for: .valueChanged)
        tableView.addSubview(refresh)
    }
    
    @objc func loadEvents() {
        allEvents = [[], []]
        self.tableView.reloadData()
        fetchAllEvents()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return allEvents.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allEvents[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventsTableViewCell else { return UITableViewCell() }
        
        let sectionNumber = indexPath.section
        let event = allEvents[sectionNumber][indexPath.row]
        cell.sectionNumber = sectionNumber
        cell.event = event

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 10
    }

//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "My Event"
//        } else {
//            return "Invitations"
//        }
//
//    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60))
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width - 16, height: 40))
        
        headerView.addSubview(textLabel)
        
        textLabel.anchor(top: headerView.topAnchor, bottom: headerView.bottomAnchor, leading: headerView.leadingAnchor, trailing: nil, paddingTop: 8, paddingBottom: 8, paddingLeading: 8, paddingTrailing: 0, width: tableView.bounds.width - 16, height: 40)
        
        textLabel.text = section == 0 ? "My Event" : "Invitations"
        textLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 24)
        textLabel.textColor = .customLightGreen
        textLabel.underline()
        headerView.backgroundColor = UIColor.white
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
        
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let eventToDelete = allEvents[indexPath.section][indexPath.row]
            EventController.shared.deleteEvent(event: eventToDelete) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        print("Successfully deleted event")
                        if self.allEvents[0].contains(eventToDelete) {
                            guard let index = self.allEvents[0].firstIndex(of: eventToDelete) else {return}
                            self.allEvents[0].remove(at: index)
                        } else {
                            guard let index = self.allEvents[1].firstIndex(of: eventToDelete) else {return}
                            self.allEvents[1].remove(at: index)
                        }
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    case .failure(let error):
                        print("Failed to delete event. Error \n----\n \(error.localizedDescription)")
                        
                    }
                }
            }
        }
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //IIDOO
        if segue.identifier == "toEventDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? EventDetailViewController else { return }
            
            guard let cell = tableView.cellForRow(at: indexPath) as? EventsTableViewCell else { return }
            if cell.ownerLabel.isHidden == true {
                destinationVC.isOwner = false
            }
            
            let eventToSend = allEvents[indexPath.section][indexPath.row]
            
            destinationVC.event = eventToSend
        }
        
        if segue.identifier == "toEventCreateVC" {
            guard let destinationVC = segue.destination as? EventCreateViewController else { return }
            destinationVC.event = nil
        }
    }

}//End of class
