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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateViews()
    }
    
    fileprivate func updateViews() {
        headerLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 20)
        headerLabel.textColor = .white
        headerLabel.backgroundColor = .customGreen
        headerLabel.underline()
        self.addCornerRadius(color: .customGreen)
    }
    
}//End of class
