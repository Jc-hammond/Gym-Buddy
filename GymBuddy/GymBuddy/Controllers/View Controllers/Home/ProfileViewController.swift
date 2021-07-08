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
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullNameTextField.delegate = self
        targetWeightTextField.delegate = self

        navigationController?.navigationBar.tintColor = .customLightGreen
        updateViews()
    }
    
    //MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let currentUser = UserController.shared.currentUser,
              let newName = fullNameTextField.text, !newName.isEmpty,
              let newWeight = targetWeightTextField.text, !newWeight.isEmpty,
              let newTargetWeight = Int(newWeight) else { return }
        
        currentUser.fullName = newName
        currentUser.targetWeight = newTargetWeight
        
        UserController.shared.saveUserUpdates(currentUser: currentUser) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("successfully saved current user")
                case .failure(let error):
                    print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteAccountButtonTapped(_ sender: Any) {
        guard let currentUser = UserController.shared.currentUser else { return }
        UserController.shared.deleteUser(for: currentUser) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("successfully deleted current user")
                    self.presentAlertController()
                case .failure(let error):
                    print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                }
                //self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //MARK: - Functions
    func presentAlertController() {
        let alert = UIAlertController(title: "Successfully Deleted your account", message: "We are sad to see you leave...", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Bye", style: .default) { _ in
            self.presentInitialProfileVC()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentInitialProfileVC() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "InitialProfile", bundle: nil)
            guard let rootVC = storyboard.instantiateInitialViewController() else { return }
            rootVC.modalPresentationStyle = .fullScreen
            
            self.present(rootVC, animated: true, completion: nil)
        }
    }
    
    fileprivate func updateViews() {
        
        guard let currentUser = UserController.shared.currentUser else { return }
        
        profileImageButton.addCornerRadius(radius: profileImageButton.frame.width/2, width: 1, color: .customLightGreen)
        profileImageButton.imageView?.contentMode = .scaleAspectFit
        profileImageButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        nameLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 40)
        nameLabel.text = currentUser.fullName
        infoLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 32)
        infoLabel.textColor = .darkGray
        fullNameLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 16)
        fullNameLabel.textColor = .customGreen
        targetWeightLabel.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 16)
        targetWeightLabel.textColor = .customGreen
        
        fullNameTextField.addCornerRadius()
        fullNameTextField.text = currentUser.fullName
        targetWeightTextField.addCornerRadius()
        targetWeightTextField.text = "\(currentUser.targetWeight)"
        
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

extension ProfileViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameTextField {
            targetWeightTextField.becomeFirstResponder()
        }
        return true
    }

}
