//
//  ProfileViewController.swift
//  GymBuddy
//
//  Created by James Chun on 6/29/21.
//

import UIKit

class ProfileViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var targetWeightLabel: UILabel!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var targetWeightTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    //MARK: - Properties
    ///need a profile lading pad here
//    var profile: Profile? {
//        didSet {
//            updateViews()
//        }
//    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .customLightGreen
        updateViews()
    }
    
    //MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
    }
    
    @IBAction func deleteAccountButtonTapped(_ sender: Any) {
    }
    
    //MARK: - Functions
    fileprivate func updateViews() {
        profileImageButton.addCornerRadius(radius: profileImageButton.frame.width/2, width: 1, color: .customLightGreen)
        profileImageButton.imageView?.contentMode = .scaleAspectFit
        profileImageButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        nameLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 40)
        infoLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 32)
        infoLabel.textColor = .darkGray
        fullNameLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 16)
        fullNameLabel.textColor = .customGreen
        targetWeightLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 16)
        targetWeightLabel.textColor = .customGreen
        
        fullNameTextField.addCornerRadius()
        targetWeightTextField.addCornerRadius()
        
        saveButton.addCornerRadius()
        saveButton.tintColor = .customLightGreen
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.setBackgroundColor(.customLightGreen!)
        saveButton.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 20)
        cancelButton.addCornerRadius(color: .gray)
        cancelButton.tintColor = .gray
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.setBackgroundColor(.gray)
        cancelButton.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 20)
        deleteAccountButton.addCornerRadius(color: .red)
        deleteAccountButton.tintColor = .red
        deleteAccountButton.setTitleColor(.white, for: .normal)
        deleteAccountButton.setBackgroundColor(.red)
        deleteAccountButton.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 20)
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
