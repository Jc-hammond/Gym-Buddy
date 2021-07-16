//
//  AddGoalViewController.swift
//  GymBuddy
//
//  Created by James Chun on 6/21/21.
//

import UIKit

class AddGoalViewController: UIViewController {
    //MARK: - Outlets
    //labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationDetailLabel: UILabel!
    @IBOutlet weak var durationUnitLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceDetailLabel: UILabel!
    @IBOutlet weak var distanceUnitLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var caloriesDetailLabel: UILabel!
    @IBOutlet weak var caloriesUnitLabel: UILabel!
    
    //buttons
    @IBOutlet weak var exerciseButton: UIButton!
    @IBOutlet weak var selectDurationButton: UIButton!
    @IBOutlet weak var durationUnitButton: UIButton!
    @IBOutlet weak var selectDistanceButton: UIButton!
    @IBOutlet weak var distanceUnitButton: UIButton!
    @IBOutlet weak var selectCaloriesButton: UIButton!
    @IBOutlet weak var caloriesUnitButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var durationUpButton: UIButton!
    @IBOutlet weak var durationDownButton: UIButton!
    @IBOutlet weak var distanceUpButton: UIButton!
    @IBOutlet weak var distanceDownButton: UIButton!
    @IBOutlet weak var caloriesUpButton: UIButton!
    @IBOutlet weak var caloriesDownButton: UIButton!
    
    var exerciseTypeButtons: [UIButton] = []
    var durationMetricButtons: [UIButton] = []
    var distanceMetricButtons: [UIButton] = []
        
    //StackViews
    @IBOutlet weak var distanceStackView: UIStackView!
    
    //MARK: - Properties
    let exerciseTypes: [String] = ["Strength Training", "Run", "Walk", "Basketball", "Soccer", "Cycling", "HIIT", "Hiking", "Yoga", "Dance", "Swimming", "Other"]
    
    let durationMetrics: [String] = ["hour"/*, "minute"*/]
    let distanceMetrics: [String] = ["mi", "km"]
    var durationQuantity: Int = 0
    var distanceQuantity: Int = 0
    var caloriesQuantity: Int = 0
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        durationOn()
        distanceOff()
        caloriesOff()
        setupExerciseTypeButtons()
        setupDurationUnitButtons()
        setupDistanceUnitButtons()
    }
    
    override func loadView() {
        super.loadView()
        
    }
    
    //MARK: - Functions
    fileprivate func configureViews() {
        //Static Configuration
        titleLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 28)
        titleLabel.textColor = UIColor.customLightGreen
        exerciseLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 22)
        exerciseLabel.textColor = UIColor.customLightGreen
        exerciseLabel.underline()
        detailsLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 22)
        detailsLabel.textColor = UIColor.customLightGreen
        detailsLabel.underline()
        durationLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        distanceLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        caloriesLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        
        durationDetailLabel.text = "\(durationQuantity)"
        distanceDetailLabel.text = "\(distanceQuantity)"
        caloriesDetailLabel.text = "\(caloriesQuantity)"
        
        createButton.addCornerRadius()
        createButton.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 20)
        exerciseButton.addCornerRadius()
        exerciseButton.setInsets(forImagePadding: 4, equalWidthConstant: 0.85, titlePadding: 32)
        exerciseButton.setTitleColor(.customDarkGreen, for: .normal)
        exerciseButton.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        durationUnitButton.setInsets(forImagePadding: 10, equalWidthConstant: 0.7, titlePadding: 12)
        distanceUnitButton.setInsets(forImagePadding: 10, equalWidthConstant: 0.7, titlePadding: 12)
    }
    
    fileprivate func durationOn() {
        selectDurationButton.setImage(UIImage.circleButtonFilled, for: .normal)
        durationDetailLabel.addCornerRadius()
        durationDetailLabel.textColor = .customDarkGreen
        durationUnitButton.addCornerRadius()
        durationUnitButton.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        durationUnitLabel.textColor = .customDarkGreen
        durationUpButton.isEnabled = true
        durationDownButton.isEnabled = true
        durationUnitButton.isEnabled = true
    }
    
    fileprivate func durationOff() {
        selectDurationButton.setImage(UIImage.circleButton, for: .normal)
        durationDetailLabel.addCornerRadius(color: .gray)
        durationDetailLabel.textColor = .gray
        durationUnitButton.addCornerRadius(color: .gray)
        durationUnitButton.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        durationUnitLabel.textColor = .gray
        durationUpButton.isEnabled = false
        durationDownButton.isEnabled = false
        durationUnitButton.isEnabled = false
    }
    
    fileprivate func distanceOn() {
        selectDistanceButton.setImage(UIImage.circleButtonFilled, for: .normal)
        distanceDetailLabel.addCornerRadius()
        distanceDetailLabel.textColor = .customDarkGreen
        distanceUnitButton.addCornerRadius()
        distanceUnitButton.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        distanceUnitLabel.textColor = .customDarkGreen
        distanceUpButton.isEnabled = true
        distanceDownButton.isEnabled = true
        distanceUnitButton.isEnabled = true
    }
    
    fileprivate func distanceOff() {
        selectDistanceButton.setImage(UIImage.circleButton, for: .normal)
        distanceDetailLabel.addCornerRadius(color: .gray)
        distanceDetailLabel.textColor = .gray
        distanceUnitButton.addCornerRadius(color: .gray)
        distanceUnitButton.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        distanceUnitLabel.textColor = .gray
        distanceUpButton.isEnabled = false
        distanceDownButton.isEnabled = false
        distanceUnitButton.isEnabled = false
    }
    
    fileprivate func caloriesOn() {
        selectCaloriesButton.setImage(UIImage.circleButtonFilled, for: .normal)
        caloriesDetailLabel.addCornerRadius()
        caloriesDetailLabel.textColor = .customDarkGreen
        caloriesUnitButton.addCornerRadius()
        caloriesUnitButton.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        caloriesUnitLabel.textColor = .customDarkGreen
        caloriesUpButton.isEnabled = true
        caloriesDownButton.isEnabled = true
        caloriesUnitButton.isEnabled = true
    }
    
    fileprivate func caloriesOff() {
        selectCaloriesButton.setImage(UIImage.circleButton, for: .normal)
        caloriesDetailLabel.addCornerRadius(color: .gray)
        caloriesDetailLabel.textColor = .gray
        caloriesUnitButton.addCornerRadius(color: .gray)
        caloriesUnitButton.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        caloriesUnitLabel.textColor = .gray
        caloriesUpButton.isEnabled = false
        caloriesDownButton.isEnabled = false
        caloriesUnitButton.isEnabled = false
    }
    
    fileprivate func setupDistanceUnitButtons() {
        for i in 0..<distanceMetrics.count {
            let width = distanceUnitButton.frame.width
            let height = distanceUnitButton.frame.height
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: height))
            
            button.addCornerRadius()
            button.backgroundColor = .white
            button.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
            button.setTitleColor(.customDarkGreen, for: .normal)
            button.setTitle(distanceMetrics[i], for: .normal)
            button.isHidden = true
            
            view.addSubview(button)
            
            button.anchor(top: distanceUnitButton.bottomAnchor, bottom: nil, leading: distanceUnitButton.leadingAnchor, trailing: distanceUnitButton.trailingAnchor, paddingTop: height * CGFloat(i), paddingBottom: 0, paddingLeading: 0, paddingTrailing: 0, width: width, height: height)
            
            button.addTarget(self, action: #selector(distanceMetricSelected(button:)), for: .touchUpInside)
            
            distanceMetricButtons.append(button)
        }

    }
    
    @objc func distanceMetricSelected(button: UIButton) {
        guard let title = button.titleLabel?.text else { return }
        distanceUnitButton.setTitle(title, for: .normal)
        distanceMetricButtons.forEach { button in
            button.isHidden = true
        }
    }

    
    fileprivate func setupDurationUnitButtons() {
        for i in 0..<durationMetrics.count {
            let width = durationUnitButton.frame.width
            let height = durationUnitButton.frame.height
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: height))
            
            button.addCornerRadius()
            button.backgroundColor = .white
            button.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
            button.setTitleColor(.customDarkGreen, for: .normal)
            button.setTitle(durationMetrics[i], for: .normal)
            button.isHidden = true
            
            view.addSubview(button)
            
            button.anchor(top: durationUnitButton.bottomAnchor, bottom: nil, leading: durationUnitButton.leadingAnchor, trailing: durationUnitButton.trailingAnchor, paddingTop: height * CGFloat(i), paddingBottom: 0, paddingLeading: 0, paddingTrailing: 0, width: width, height: height)
            
            button.addTarget(self, action: #selector(durationMetricSelected(button:)), for: .touchUpInside)
            
            durationMetricButtons.append(button)
        }
    }
    
    @objc func durationMetricSelected(button: UIButton) {
        guard let title = button.titleLabel?.text else { return }
        durationUnitButton.setTitle(title, for: .normal)
        durationMetricButtons.forEach { button in
            button.isHidden = true
        }
    }
    
    fileprivate func setupExerciseTypeButtons() {
        for i in 0..<exerciseTypes.count {
            let width = exerciseButton.frame.width
            let height = exerciseButton.frame.height
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: height))
            
            button.addCornerRadius()
            button.backgroundColor = .white
            button.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
            button.setTitleColor(.customDarkGreen, for: .normal)
            button.setTitle(exerciseTypes[i], for: .normal)
            button.isHidden = true
            
            view.addSubview(button)
            
            button.anchor(top: exerciseButton.bottomAnchor, bottom: nil, leading: exerciseButton.leadingAnchor, trailing: exerciseButton.trailingAnchor, paddingTop: height * CGFloat(i), paddingBottom: 0, paddingLeading: 0, paddingTrailing: 0, width: width, height: height)
            
            button.addTarget(self, action: #selector(exerciseSelected(button:)), for: .touchUpInside)
            
            exerciseTypeButtons.append(button)
        }
    }//end of func
    
    @objc func exerciseSelected(button: UIButton) {
        guard let title = button.titleLabel?.text else { return }
        exerciseButton.setTitle(title, for: .normal)
        exerciseTypeButtons.forEach { button in
            button.isHidden = true
        }
        if exerciseButton.titleLabel?.text == "Run" || exerciseButton.titleLabel?.text == "Walk" || exerciseButton.titleLabel?.text == "Cycling" || exerciseButton.titleLabel?.text == "Swimming" || exerciseButton.titleLabel?.text == "Hiking" {
            UIView.animate(withDuration: 0.3) {
                self.distanceStackView.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.distanceStackView.isHidden = true
            }
        }
    }

    //MARK: - Actions
    @IBAction func disclaimerButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "DISCLAIMER", message: "These features are not health or medical advice or suggestions. If none of the presented Types are suitable for you please select \"Other\"; please consult a doctor or medical professional before engaging in any type of workout and/or exercise, and before using this app.  See app description for more details.\n Provided workout names and types are intended to align with those suggested by Apple on the Fitness app. https://support.apple.com/en-us/HT207934", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func durationUnitButtonTapped(_ sender: UIButton) {
        durationMetricButtons.forEach { button in
            UIView.animate(withDuration: 0.3) {
                button.isHidden.toggle()
            }
        }
    }
    
    @IBAction func distanceUnitButtonTapped(_ sender: Any) {
        distanceMetricButtons.forEach { button in
            UIView.animate(withDuration: 0.3) {
                button.isHidden.toggle()
            }
        }
    }
    
    @IBAction func exerciseButtonTapped(_ sender: UIButton) {
        exerciseTypeButtons.forEach { button in
            UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseInOut) {
                button.isHidden.toggle()
            }
        }
    }
    
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        if sender.tag == 7 {
            durationOn()
            distanceOff()
            caloriesOff()
        }
        
        if sender.tag == 8 {
            durationOff()
            distanceOn()
            caloriesOff()
        }
        
        if sender.tag == 9 {
            durationOff()
            distanceOff()
            caloriesOn()
        }
    }
    
    @IBAction func upDownButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            durationQuantity += 1
            durationDetailLabel.text = "\(durationQuantity)"
        case 2:
            if durationQuantity > 0 {
                durationQuantity -= 1
                durationDetailLabel.text = "\(durationQuantity)"
            }
        case 3:
            distanceQuantity += 1
            distanceDetailLabel.text = "\(distanceQuantity)"
        case 4:
            if distanceQuantity > 0 {
                distanceQuantity -= 1
                distanceDetailLabel.text = "\(distanceQuantity)"
            }
        case 5:
            caloriesQuantity += 10
            caloriesDetailLabel.text = "\(caloriesQuantity)"
        case 6:
            if caloriesQuantity > 0 {
                caloriesQuantity -= 10
                caloriesDetailLabel.text = "\(caloriesQuantity)"
            }
        default:
            print("unknown button found")
        }
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        guard let currentUser = UserController.shared.currentUser,
              let title = exerciseButton.titleLabel?.text,
              title != "Select Exercise Type" else { return }
        
        var goal: Int = 0
        var unit: String = ""
        
        if durationUpButton.isEnabled {
            guard let durationUnit = durationUnitButton.titleLabel?.text,
                  durationQuantity > 0 else { return }
            goal = durationQuantity
            unit = durationUnit
        }
        
        if distanceUpButton.isEnabled {
            guard let distanceUnit = distanceUnitButton.titleLabel?.text,
                  distanceQuantity > 0 else { return }
            goal = distanceQuantity
            unit = distanceUnit
        }
        
        if caloriesUpButton.isEnabled {
            guard let caloriesUnit = caloriesUnitButton.titleLabel?.text,
                  caloriesQuantity > 0 else { return }
            goal = caloriesQuantity
            unit = caloriesUnit
        }
        
        WorkoutController.shared.addWorkout(title: title, goal: goal, unit: unit, user: currentUser) { result in
            switch result {
            case .success(let workout):
                guard let workout = workout else { return }
                currentUser.workouts.append(workout)
            case .failure(let error):
                print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        
        self.tabBarController?.selectedIndex = 1
        
    }//end of func
    
}//End of class
