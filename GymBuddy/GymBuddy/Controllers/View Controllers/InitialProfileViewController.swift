//
//  InitialProfileViewController.swift
//  GymBuddy
//
//  Created by James Chun on 6/21/21.
//

import UIKit
import CloudKit

class InitialProfileViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var currentWeightTextField: UITextField!
    @IBOutlet weak var targetWeightTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentWeightTextField.delegate = self
        targetWeightTextField.delegate = self
        
        currentWeightTextField.addCornerRadius()
        targetWeightTextField.addCornerRadius()
        fullNameTextField.addCornerRadius()
        nextButton.addCornerRadius(radius: 20)
        nextButton.setBackgroundColor(UIColor.customLightGreen ?? .clear)
                
    }
    
    
    //MARK: - Actions
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard let currentWeight = currentWeightTextField.text,
              let currentWeightInt = Int(currentWeight),
              let targetWeight = targetWeightTextField.text,
              let targetWeightInt = Int(targetWeight),
              let fullName = fullNameTextField.text else { return }
                
        UserController.shared.createUser(fullName: fullName, currentWeight: currentWeightInt, targetWeight: targetWeightInt) { result in
            switch result {
            case .success(let user):
                UserController.shared.currentUser = user
            case .failure(let error):
                print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
              
        self.dismiss(animated: true, completion: nil)
    }
    
}//End of class

//MARK: - Extension
extension InitialProfileViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
}//End of class
