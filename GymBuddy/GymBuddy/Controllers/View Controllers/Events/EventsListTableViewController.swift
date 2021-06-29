//
//  EventsTableViewController.swift
//  GymBuddy
//
//  Created by James Chun on 6/21/21.
//

import UIKit

class EventsListTableViewController: UITableViewController {
    //MARK: - Properties
    let sections: [String] = ["My Events", "Invited"]
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventsTableViewCell else { return UITableViewCell() }
        
        let sectionNumber = indexPath.section
        cell.sectionNumber = sectionNumber

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 10
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60))
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width - 16, height: 40))
        
        headerView.addSubview(textLabel)
        
        textLabel.anchor(top: headerView.topAnchor, bottom: headerView.bottomAnchor, leading: headerView.leadingAnchor, trailing: nil, paddingTop: 8, paddingBottom: 8, paddingLeading: 8, paddingTrailing: 0, width: tableView.bounds.width - 16, height: 40)
        
        textLabel.text = sections[section]
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
        
    }

}//End of class
