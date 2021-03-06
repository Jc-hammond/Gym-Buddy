//
//  EventCreateViewController.swift
//  GymBuddy
//
//  Created by James Chun on 6/23/21.
//

import UIKit

class EventCreateViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var eventEmojiButton: UIButton!
    @IBOutlet weak var eventDetailLabel: UILabel!
    @IBOutlet weak var whenLabel: UILabel!
    @IBOutlet weak var whereLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var whereTextField: UITextField!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var createEventButton: UIButton!
    
    //MARK: - Properties
    let emojis: [[String]] = [
        ["💪","🏃","🚶"],
        ["🏀","⚽️","🚴‍♀️"],
        ["😵","🥾","🧘‍♀️"],
        ["💃","🏊‍♂️","❓"]
    ]
    
    let workoutTypes: [String] = [
        "Strengh Training",
        "Run",
        "Walk",
        "Basketball",
        "Soccer",
        "Cycling",
        "HIIT",
        "Hiking",
        "Yoga",
        "Dance",
        "Swimming",
        "Other"
    ]
    
    var emojiButtons: [UIButton] = []
    var workoutButtons: [UIButton] = []
    var event: Event?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .customLightGreen
        
        eventTitleTextField.delegate = self
        whereTextField.delegate = self
        infoTextView.delegate = self
        
        setupEmojiButtons()
        setupWorkoutTypeButtons()
    }
    
    override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        
        updateViews()
    }
    
    //MARK: - Actions
    @IBAction func disclaimerButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "DISCLAIMER", message: "These features are not health or medical advice or suggestions. If none of the presented Types are suitable for you please select \"Other\"; please consult a doctor or medical professional before engaging in any type of workout and/or exercise, and before using this app.  See app description for more details.\n Provided workout names and types are intended to align with those suggested by Apple on the Fitness app. https://support.apple.com/en-us/HT207934", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func eventEmojiButtonTapped(_ sender: UIButton) {
        emojiButtons.forEach{ $0.isHidden.toggle() }
    }
    
    @IBAction func typeButtonTapped(_ sender: Any) {
        workoutButtons.forEach{ $0.isHidden.toggle() }
    }
    
    @IBAction func creatEventButtonTapped(_ sender: Any) {
        guard let title = eventTitleTextField.text,
              let emoji = eventEmojiButton.titleLabel?.text,
              let location = whereTextField.text,
              let type = typeButton.titleLabel?.text,
              let currentUser = UserController.shared.currentUser else { return }
              
        let info = infoTextView.text
        let date = datePicker.date
        
        if let event = event {
            EventController.shared.updateEvent(for: event) { result in
                switch result {
                case .success(_):
                    print("Event: \(event.title) successfully saved")
                case .failure(let error):
                    print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        } else {
            EventController.shared.createEvent(with: title, emoji: emoji, date: date, location: location, type: type, info: info, user: currentUser) { result in
                switch result {
                case .success(let event):
                    guard let event = event else { return }
                    print("\(event.title) is successfully saved")
                case .failure(let error):
                    print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
        
        self.navigationController?.popViewController(animated: true)
        
    }//end of func
    
    //MARK: - Functions
    fileprivate func updateViews() {
        if let event = event {
            eventTitleTextField.text = event.title
            eventEmojiButton.setImage(nil, for: .normal)
            eventEmojiButton.setTitle(event.emoji, for: .normal)
            datePicker.date = event.date
            whereTextField.text = event.location
            typeButton.setTitle(event.type, for: .normal)
            infoTextView.text = event.info
            createEventButton.setTitle("Save Event", for: .normal)
        }
        
        eventTitleTextField.addCornerRadius()
        eventTitleTextField.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 22)
        eventTitleTextField.updatePlaceHolder(fontName: FontNames.sfRoundedSemiBold, size: 22)
        eventEmojiButton.addCornerRadius()
        eventEmojiButton.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 50)
        eventDetailLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 22)
        eventDetailLabel.underline()
        whenLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        whereLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        typeLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        infoLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        whereTextField.addCornerRadius()
        whereTextField.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 18)
        whereTextField.updatePlaceHolder(fontName: FontNames.sfRoundedSemiBold, size: 18)
        typeButton.addCornerRadius()
        infoTextView.addCornerRadius()
        infoTextView.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 15)
        createEventButton.addCornerRadius()
        guard let customLightGreen = UIColor.customLightGreen else { return }
        createEventButton.setBackgroundColor(customLightGreen)
        createEventButton.setTitleColor(.white, for: .normal)
        createEventButton.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 30)
    }
    
    fileprivate func setupEmojiButtons() {
        var j: CGFloat = 0
        
        for row in emojis {
            var i: CGFloat = 0
            
            for emoji in row {
                
                let width = eventEmojiButton.frame.width
                let height = eventEmojiButton.frame.height
                
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: height))
                button.addCornerRadius()
                button.setBackgroundColor(.white)
                button.setTitle(emoji, for: .normal)
                button.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 50)
                
                button.isHidden = true
                view.addSubview(button)
                
                button.anchor(top: eventEmojiButton.bottomAnchor, bottom: nil, leading: eventEmojiButton.leadingAnchor, trailing: nil, paddingTop: height * j, paddingBottom: 0, paddingLeading: -width + (width * i), paddingTrailing: 0, width: width, height: height)
                
                button.addTarget(self, action: #selector(emojiSelected(button:)), for: .touchUpInside)
                emojiButtons.append(button)
                i += 1
            }
            j += 1
        }
        
    }//end of func
    
    @objc func emojiSelected(button: UIButton) {
        guard let emoji = button.titleLabel?.text else { return }
        eventEmojiButton.setTitle(emoji, for: .normal)
        eventEmojiButton.setImage(nil, for: .normal)
        emojiButtons.forEach{ $0.isHidden = true }
    }
    
    fileprivate func setupWorkoutTypeButtons() {
        for i in 0..<workoutTypes.count {
            let width = view.frame.width * 0.65
            let height = width / 9
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: height))
            button.addCornerRadius()
            button.setBackgroundColor(.white)
            button.setTitle(workoutTypes[i], for: .normal)
            button.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 14)
            button.setTitleColor(.customDarkGreen!, for: .normal)
            
            button.isHidden = true
            view.addSubview(button)
            
            button.anchor(top: typeButton.bottomAnchor, bottom: nil, leading: nil, trailing: nil, paddingTop: height * CGFloat(i), paddingBottom: 0, paddingLeading: 0, paddingTrailing: 0, width: width, height: height)
            
            button.anchorCenter(x: typeButton.centerXAnchor, y: nil, paddingX: 0, paddingY: 0)
            
            button.addTarget(self, action: #selector(workoutTypeSelected(button:)), for: .touchUpInside)
            workoutButtons.append(button)
        }
    }//end of func
    
    @objc func workoutTypeSelected(button: UIButton) {
        guard let workoutType = button.titleLabel?.text else { return }
        typeButton.setTitle(workoutType, for: .normal)
        workoutButtons.forEach{ $0.isHidden = true }
    }
    
}//End of class

extension EventCreateViewController: UITextFieldDelegate, UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }

}
