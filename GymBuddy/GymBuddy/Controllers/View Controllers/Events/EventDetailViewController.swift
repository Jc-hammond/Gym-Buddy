//
//  EventDetailViewController.swift
//  GymBuddy
//
//  Created by James Chun on 6/23/21.
//

import UIKit

class EventDetailViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventEmojiLabel: UILabel!
    @IBOutlet weak var eventDetailLabel: UILabel!
    @IBOutlet weak var whenLabel: UILabel!
    @IBOutlet weak var whereLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var exerciseTypeLabel: UILabel!
    @IBOutlet weak var eventInfoLabel: UILabel!
    @IBOutlet weak var inviteesLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var event: Event? {
        didSet {
            fetchAttendees()
        }
    }
    var attendees = [User]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .customLightGreen

        tableView.delegate = self
        tableView.dataSource = self
        
        updateViews()
    }
    
    //MARK: - Function
    fileprivate func fetchAttendees() {
        guard let event = event,
              let attendeeRefs = event.attendeeRefs else { return }
        
        EventController.shared.fetchEventUsers(attendeeRefs: attendeeRefs) { result in
            switch result {
            case .success(let attendees):
                guard let attendees = attendees else { return }
                self.attendees = attendees
            case .failure(let error):
                print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        
        
    }//end of func
    
    //MARK: - Actions
    @IBAction func addInviteeButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Friends", bundle: nil)
        guard let destinationVC = storyboard.instantiateViewController(identifier: "FriendsListTableViewController") as? FriendsListTableViewController else { return }
        destinationVC.buttonTitles = ["invite", "attending"]
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    //MARK: - Functions
    fileprivate func updateViews() {
        guard let event = event else { return }
        tableView.addCornerRadius()
        eventTitleLabel.text = event.title
        eventEmojiLabel.text = event.emoji
        dateLabel.text = event.date.formatDate()
        timeLabel.text = event.date.formatTime()
        locationLabel.text = event.location
        exerciseTypeLabel.text = event.type
        eventInfoLabel.text = event.info
        
        eventTitleLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 24)
        eventDetailLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 22)
        inviteesLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 22)
        whenLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 16)
        whereLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 16)
        typeLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 16)
        infoLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 16)
        dateLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 16)
        timeLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 16)
        locationLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 16)
        exerciseTypeLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 16)
        eventInfoLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 16)
        eventInfoLabel.addCornerRadius(color: .customDarkGreen)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}//End of class

//MARK: - Extensions
extension EventDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendees.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "inviteeCell") as? InviteeTableViewCell else { return UITableViewCell() }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 14
    }
    
}//End of extension
