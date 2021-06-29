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
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        updateViews()
    }
    
    //MARK: - Functions
    fileprivate func updateViews() {
        tableView.addCornerRadius()
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
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "inviteeCell") as? InviteeTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 14
    }
    
}//End of extension
