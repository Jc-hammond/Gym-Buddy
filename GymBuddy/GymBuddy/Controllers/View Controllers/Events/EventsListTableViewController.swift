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
    var allEvents = [[Event]]()
    
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
//        let inviteesPredicate = NSPredicate(format: "%K == %@", EventStrings.inviteeRefsKey, currentUserRef)
//        let allEventPredicate = NSPredicate(value: true)
        
        EventController.shared.fetchEvent(predicate: ownerPredicate) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let events):
                    guard let attendingEvents = events else { return }
                    self.allEvents[0] = attendingEvents
                    self.tableView.reloadData()
                    self.refresh.endRefreshing()
                case .failure(let error):
                    print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                    self.refresh.endRefreshing()

                }
            }
        }
        
//        EventController.shared.fetchEvent(predicate: inviteesPredicate) { result in
//            switch result {
//            case .success(let events):
//                guard let invitedEvents = events else { return }
//                self.allEvents.append(invitedEvents)
//            case .failure(let error):
//                print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
//            }
//        }
        
    }//end of func
    
    func setupViews() {
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh events")
        refresh.addTarget(self, action: #selector(loadEvents), for: .valueChanged)
        tableView.addSubview(refresh)
    }
    
    @objc func loadEvents() {
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

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //IIDOO
        if segue.identifier == "toEventDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? EventDetailViewController else { return }
            
            let eventToSend = allEvents[indexPath.section][indexPath.row]
            
            destinationVC.event = eventToSend
        }
        
        if segue.identifier == "toEventCreateVC" {
            guard let destinationVC = segue.destination as? EventCreateViewController else { return }
            destinationVC.event = nil
        }
    }

}//End of class
