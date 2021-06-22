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
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentWeightTextField.addCornerRadius()
        targetWeightTextField.addCornerRadius()
        usernameTextField.addCornerRadius()
        nextButton.addCornerRadius(radius: 20)
        nextButton.setBackgroundColor(UIColor.customLightGreen ?? .clear)
    }
    
    //MARK: - Actions
    @IBAction func nextButtonTapped(_ sender: Any) {
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

}
