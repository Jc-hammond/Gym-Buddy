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
    @IBOutlet weak var restartLabel: UILabel!
    
    //MARK: - Properties
    var isLoggedIntoiCloud: Bool?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        targetHoursTextField.delegate = self
        
        targetHoursTextField.addCornerRadius()
        fullNameTextField.addCornerRadius()
        nextButton.addCornerRadius(radius: 20)
        nextButton.setBackgroundColor(UIColor.customLightGreen ?? .clear)
        restartLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            checkAccountStatus()
        }else{
            print("Internet Connection not Available!")
            presentInternetConnectionAlert()
        }
    }
    
    
    //MARK: - Actions
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard let targetHours = targetHoursTextField.text,
              let targetHoursInt = Int(targetHours),
              let fullName = fullNameTextField.text else {
            let alert = UIAlertController(title: "Missing Information", message: "Please enter target hours and nickname.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        if !(Reachability.isConnectedToNetwork()) {
            print("Internet Connection not Available!")
            presentInternetConnectionAlert()
            return
        }
        
        if isLoggedIntoiCloud != nil && isLoggedIntoiCloud == false {
            checkAccountStatus()
        }
        
        UserController.shared.createUser(fullName: fullName, targetHours: targetHoursInt) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    UserController.shared.currentUser = user
                    guard let loadingVC = self.storyboard?.instantiateViewController(identifier: "LoadingViewController") as? LoadingViewController else { return }
                    self.show(loadingVC, sender: nil)
                case .failure(let error):
                    print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                    self.checkAccountStatus()
                }
            }
        }
    }//end of func
    
    //MARK: - Functions
    
    func presentInternetConnectionAlert() {
        let alert = UIAlertController(title: "No internet connnection", message: "Please check your internet connection", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func checkAccountStatus() {
        CKContainer.default().accountStatus { status, error in
            if let error = error {
                print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                //Alertcontroller?
            } else {
                DispatchQueue.main.async {
                    switch status {
                    case .available:
                        print("successfully fetched apple user ref")
                        self.isLoggedIntoiCloud = true
                    case .noAccount:
                        self.presentAlertController(title: "No Account", message: "Please go to settings and make sure your device is logged into iCloud")
                        self.nextButton.isEnabled = false
                        self.nextButton.backgroundColor = .gray
                        self.restartLabel.isHidden = false
                    case .couldNotDetermine:
                        self.presentAlertController(title: "Could not determine", message: "Please check your iCloud account and restart GitFitWithFriends")
                        self.nextButton.isEnabled = false
                        self.nextButton.backgroundColor = .gray
                        self.restartLabel.isHidden = false
                    case .restricted:
                        self.presentAlertController(title: "Restricted", message: "Your iCloud account is restricted")
                        self.nextButton.isEnabled = false
                        self.nextButton.backgroundColor = .gray
                        self.restartLabel.isHidden = false
                    @unknown default:
                        self.presentAlertController(title: "Unknown Error", message: "Unknown error found while launching the app")
                        self.nextButton.isEnabled = false
                        self.nextButton.backgroundColor = .gray
                        self.restartLabel.isHidden = false
                    }
                }
            }
        }
    }
    
    func presentAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsURL = URL(string: /*"App-prefs:Settings"*/UIApplication.openSettingsURLString) else {return}
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL) { success in
                    print("Settings opened: \(success)")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
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
