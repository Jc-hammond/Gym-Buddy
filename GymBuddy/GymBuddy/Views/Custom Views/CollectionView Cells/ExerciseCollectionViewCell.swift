//
//  ExerciseCollectionViewCell.swift
//  GymBuddy
//
//  Created by James Chun on 6/23/21.
//

import UIKit

class ExerciseCollectionViewCell: UICollectionViewCell, CellRegisterable {
    //MARK: - Outlets
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var completionDatelabel: UILabel!
    @IBOutlet weak var goalUnitLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    //MARK: - Properties
    //JCHUN - Need to update landing pad to the actual model
    
    var workout: Workout? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //adjust progressView thickness
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 3)
        updateViews()
    }
    
    fileprivate func updateViews() {
        guard let workout = workout else { return }
        
        containerView.addCornerRadius()
        titleLabel.font = UIFont(name: FontNames.sfRoundedReg, size: 20)
        titleLabel.textColor = .customDarkGreen
        completionDatelabel.font = UIFont(name: FontNames.sfRoundedReg, size: 12)
        completionDatelabel.textColor = .gray
        goalUnitLabel.font = UIFont(name: FontNames.sfRoundedReg, size: 16)
        goalUnitLabel.textColor = .gray
        
        let progress = Float(workout.current / workout.goal)
        setProgress(with: progress)
    }
    
    fileprivate func setProgress(with progress: Float) {
        guard let gradientImage = UIImage.gradientImage(with: progressView.frame) else { return }

        progressView.addCornerRadius(radius: 4, width: 1, color: .customLightGreen)
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
            
//            guard let progress = self.progress else {
//                timer.invalidate()
//                return
//            }
            
            self.progressView.progressImage = gradientImage
            self.progressView.setProgress(progress, animated: true)
        }
    }
    
    override func prepareForReuse() {
        self.prepareForReuse()
        progressView.progress = 0
        titleLabel.text = nil
        completionDatelabel.text = nil
        goalUnitLabel.text = nil
    }

}//End of class
