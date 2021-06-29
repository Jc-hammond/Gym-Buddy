//
//  ProgressDetailViewController.swift
//  GymBuddy
//
//  Created by James Chun on 6/29/21.
//

import UIKit

class ProgressDetailViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var workoutTitleLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalQuantityLabel: UILabel!
    @IBOutlet weak var goalUnitLabel: UILabel!
    @IBOutlet weak var goalSelectedUnitLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var currentQuantityLabel: UILabel!
    @IBOutlet weak var currentUnitLabel: UILabel!
    @IBOutlet weak var currentSelectedUnitLabel: UILabel!
    @IBOutlet weak var completionLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var saveButton: UIButton!
    
    //MARK: - Properties
    var workout: Workout?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .customLightGreen
        
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 4)
        updateViews()
    }
    
    //MARK: - Actions
    @IBAction func upDownButtonsTapped(_ sender: Any) {
        //button tags 1,3 are up & 2,4 are down
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        // maybe change text to "you've completed" when goal == current
    }
    
    
    //MARK: - Functions
    fileprivate func updateViews() {
        guard let gradientImage = UIImage.gradientImage(with: progressView.frame),
              let workout = workout else { return }

        let progress = Float(workout.current) / Float(workout.goal)
        
        // title labels
        workoutTitleLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 24)
        workoutTitleLabel.textColor = .customLightGreen
        workoutTitleLabel.text = workout.title
        goalLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 20)
        goalLabel.underline()
        currentLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 20)
        currentLabel.underline()
        completionLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 20)
        completionLabel.underline()
        completionLabel.text = progress == 1 ? "Completed" : "\(Int(progress*100))% complete"
        
        // quantity labels
        goalQuantityLabel.addCornerRadius()
        goalQuantityLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        goalQuantityLabel.text = String(workout.goal)
        currentQuantityLabel.addCornerRadius()
        currentQuantityLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        currentQuantityLabel.text = String(workout.current)
        
        // unit labels
        goalUnitLabel.font = UIFont(name: FontNames.sfRoundedReg, size: 18)
        currentUnitLabel.font = UIFont(name: FontNames.sfRoundedReg, size: 18)
        goalSelectedUnitLabel.addCornerRadius()
        goalSelectedUnitLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        goalSelectedUnitLabel.text = workout.unit
        currentSelectedUnitLabel.addCornerRadius()
        currentSelectedUnitLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        currentSelectedUnitLabel.text = workout.unit
        
        // save button
        saveButton.addCornerRadius()
        saveButton.setBackgroundColor(.customLightGreen!)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 20)
        
        // progressView
        progressView.addCornerRadius(radius: 1, width: 1, color: .customLightGreen)
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in

            self.progressView.progressImage = gradientImage
            self.progressView.setProgress(progress, animated: true)
        }
        
    }//end of func
    
//    fileprivate func setProgressView() {
//        guard let gradientImage = UIImage.gradientImage(with: progressView.frame),
//              let workout = workout else { return }
//
//        let progress = Float(workout.current) / Float(workout.goal)
//
//        // progressView
//        progressView.transform = progressView.transform.scaledBy(x: 1, y: 8)
//        progressView.addCornerRadius(radius: 4, width: 1, color: .customLightGreen)
//
//        Timer.scheduledTimer(withTimeInterval: 0.0, repeats: false) { timer in
//
//            self.progressView.progressImage = gradientImage
//            self.progressView.setProgress(progress, animated: true)
//        }
//    }
    
        
}//End of class
