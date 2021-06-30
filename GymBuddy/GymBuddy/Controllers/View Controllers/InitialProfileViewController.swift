//
//  InitialProfileViewController.swift
//  GymBuddy
//
//  Created by James Chun on 6/21/21.
//

import UIKit

class InitialProfileViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var currentWeightTextField: UITextField!
    @IBOutlet weak var targetWeightTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentWeightTextField.addCornerRadius()
        targetWeightTextField.addCornerRadius()
        fullNameTextField.addCornerRadius()
        nextButton.addCornerRadius(radius: 20)
        nextButton.setBackgroundColor(UIColor.customLightGreen ?? .clear)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //JCHUN - what is the best practice?
        //JCHUN - Maybe make the main storyboard first storyboard and come to this VC when the user opens app for the first time
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
            if UserController.shared.currentUser != nil {
                self.presentTabBarController()
            }
        }
        
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
              
        presentTabBarController()
    }
    
    
    //MARK: - Functions
    fileprivate func presentTabBarController() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let rootVC = storyboard.instantiateInitialViewController() else { return }
            rootVC.modalPresentationStyle = .fullScreen
            
            self.present(rootVC, animated: true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}//End of class
