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
    
    var emojiButtons: [UIButton] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
        setupEmojiButtons()
    }
    
    //MARK: - Actions
    @IBAction func eventEmojiButtonTapped(_ sender: UIButton) {
        emojiButtons.forEach{ $0.isHidden.toggle() }
    }
    
    @IBAction func typeButtonTapped(_ sender: Any) {
        //JCHUN - Add dropdown menu...
    }
    
    //MARK: - Functions
    fileprivate func updateViews() {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
