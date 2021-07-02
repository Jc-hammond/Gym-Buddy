//
//  FriendCollectionViewCell.swift
//  GymBuddy
//
//  Created by James Chun on 6/29/21.
//

import UIKit

class FriendCollectionViewCell: UICollectionViewCell, CellRegisterable {
    //MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    
    //MARK: - Properties
    ///need a friend landing pad
//    var friend: Friend? {
//        didSet {
//            updateViews()
//        }
//    }
    
    var friendName: String? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
    }
    
    //MARK: - Functions
    func updateViews() {
        guard let name = friendName else { return }
        self.addCornerRadius()
        profileImageView.addCornerRadius(radius: contentView.frame.height/2, width: 1, color: .clear)
        friendNameLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        friendNameLabel.text = name
    }

}//End of class
