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
    var goal: Int = 0
    var current: Int = 0
    let activeGroup = DispatchGroup()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .customLightGreen
        
        guard let workout = workout else { return }
        goal = workout.goal
        current = workout.current
        
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 4)
        updateViews()
    }
    
    //MARK: - Actions
    @IBAction func upDownButtonsTapped(_ sender: UIButton) {
        //button tags 1,3 are up & 2,4 are down
        switch sender.tag {
        case 1:
            goal += 1
            goalQuantityLabel.text = "\(goal)"
        case 2:
            if goal > current {
                goal -= 1
                goalQuantityLabel.text = "\(goal)"
            }
        case 3:
            if current < goal {
                current += 1
                currentQuantityLabel.text = "\(current)"
            }
        case 4:
            if current > 0 {
                current -= 1
                currentQuantityLabel.text = "\(current)"
            }
        default:
            print("unknown button found")
        }
        
        let progress = Float(current)/Float(goal)
        updateProgressView(progress: progress)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard var workout = workout,
              let goalText = goalQuantityLabel.text,
              let goal = Int(goalText),
              let currentText = currentQuantityLabel.text,
              let current = Int(currentText) else { return }
        
        workout.current = current
        workout.goal = goal
        
        WorkoutController.shared.updateWorkout(workout: workout) { result in
            DispatchQueue.main.async {
                self.activeGroup.enter()
                switch result {
                case .success(let workout):
                    print("successfully saved workout: \(String(describing: workout?.title))")
                case .failure(let error):
                    print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                }
                self.activeGroup.leave()
                self.activeGroup.notify(queue: .main) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        // maybe change text to "you've completed" when goal == current
    }
    
    
    //MARK: - Functions
    fileprivate func updateViews() {
        guard let workout = workout else { return }

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
        
        updateProgressView(progress: progress)
        
    }//end of func
    
    fileprivate func updateProgressView(progress: Float) {
        guard let gradientImage = UIImage.gradientImage(with: progressView.frame) else { return }
        
        // completion label
        completionLabel.text = progress == 1 ? "COMPLETED" : "\(Int(progress*100))% complete"

        // progressView
        progressView.addCornerRadius(radius: 4, width: 1, color: .customLightGreen)
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            
            self.progressView.progressImage = gradientImage
            self.progressView.setProgress(progress, animated: true)
        }
    }
    
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
