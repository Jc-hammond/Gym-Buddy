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
    @IBOutlet weak var targetHoursTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        targetHoursTextField.delegate = self
        
        targetHoursTextField.addCornerRadius()
        fullNameTextField.addCornerRadius()
        nextButton.addCornerRadius(radius: 20)
        nextButton.setBackgroundColor(UIColor.customLightGreen ?? .clear)
    }
    
    
    //MARK: - Actions
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard let targetHours = targetHoursTextField.text,
              let targetHoursInt = Int(targetHours),
              let fullName = fullNameTextField.text else { return }
        
        UserController.shared.createUser(fullName: fullName, targetHours: targetHoursInt) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    UserController.shared.currentUser = user
                    guard let loadingVC = self.storyboard?.instantiateViewController(identifier: "LoadingViewController") as? LoadingViewController else { return }
                    self.show(loadingVC, sender: nil)
                case .failure(let error):
                    print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }//end of func
    
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
