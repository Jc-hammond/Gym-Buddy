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
    
    //MARK: - Functions
    fileprivate func updateViews() {
        headerLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 20)
        headerLabel.textColor = .white
        headerLabel.backgroundColor = .customGreen
        headerLabel.underline()
        self.addCornerRadius(color: .customGreen)
        self.backgroundColor = .customGreen
    }
    
}//End of class
