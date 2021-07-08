//
//  HeaderCollectionReusableView.swift
//  GymBuddy
//
//  Created by James Chun on 6/23/21.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView, CellRegisterable {
    //MARK: - Outlet
    @IBOutlet weak var headerLabel: UILabel!
//    @IBOutlet weak var headerButton: UIButton!
    
    var sectionNumber: Int? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateViews()
    }
    
    //MARK: - Actions
//    @IBAction func headerButtonTapped(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Friends", bundle: nil)
//        guard let destinationVC = storyboard.instantiateViewController(identifier: "FriendsListTableViewController") as? FriendsListTableViewController else { return }
//        //destinationVC.buttonTitles = ["friend request", "added"]
//        self.parentViewContoller?.navigationController?.pushViewController(destinationVC, animated: true)
//    }
    
    
    //MARK: - Functions
    fileprivate func updateViews() {
        headerLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 20)
        headerLabel.textColor = .white
        headerLabel.backgroundColor = .customGreen
        headerLabel.underline()
        self.addCornerRadius(color: .customGreen)
        self.backgroundColor = .customGreen
        
//        headerButton.isHidden = sectionNumber == 0 ? false : true
//        headerButton.addCornerRadius()
//        headerButton.setBackgroundColor(.customLightGreen!)
//        headerButton.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 14)
//        headerButton.setTitleColor(.white, for: .normal)
//        headerButton.setTitle("Add Friend", for: .normal)
    }
    
}//End of class
