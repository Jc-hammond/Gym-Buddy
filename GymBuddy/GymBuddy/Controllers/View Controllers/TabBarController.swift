//
//  TabBarViewController.swift
//  GymBuddy
//
//  Created by James Chun on 6/21/21.
//

import UIKit
import CloudKit

class TabBarController: UITabBarController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserController.shared.fetchAppleUserReference { result in
            switch result {
            case .success(let reference):
                let predicate = NSPredicate(format: "%K==%@", argumentArray: [UserStrings.appleUserRefKey, reference!])
                UserController.shared.fetchProfile(predicate: predicate) { result in
                    switch result {
                    case .success(let users):
                        guard let user = users?.first else { return }
                        UserController.shared.currentUser = user
                    case .failure(_):
                        print("No user found in publicDB")
                        self.presentInitialProfileVC()
                    }
                }
                
            case .failure(let error):
                print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        
        CKContainer.default().accountStatus { status, error in
            if let error = error {
                print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                //Alertcontroller?
            } else {
                DispatchQueue.main.async {
                    switch status {
                    case .available:
                        print("successfully fetched apple user ref")
                    case .noAccount:
                        self.presentAlertController(title: "No Account", message: "Please make sure your device is logged into iCloud")
                    case .couldNotDetermine:
                        self.presentAlertController(title: "Could not determine", message: "Please check your iCloud account")
                    case .restricted:
                        self.presentAlertController(title: "Restricted", message: "Your iCloud account is restricted")
                    @unknown default:
                        self.presentAlertController(title: "Unknown Error", message: "Unknown error found while launching the app")
                    }
                }
            }
        }
        
    }//end of func
    
    func presentInitialProfileVC() {
        DispatchQueue.main.async {
            if UserController.shared.currentUser == nil {
                let storyboard = UIStoryboard(name: "InitialProfile", bundle: nil)
                guard let rootVC = storyboard.instantiateInitialViewController() else { return }
                rootVC.modalPresentationStyle = .fullScreen
                
                self.present(rootVC, animated: true, completion: nil)
            }
        }
    }
    
    func presentAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
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
