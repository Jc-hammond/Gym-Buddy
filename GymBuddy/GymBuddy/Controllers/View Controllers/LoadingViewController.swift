//
//  LoadingViewController.swift
//  GymBuddy
//
//  Created by James Chun on 7/8/21.
//

import UIKit

class LoadingViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var loadingLabel: UILabel!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        repeat {
            fetchUser()
        } while UserController.shared.currentUser == nil
        presentHomeTab()
    }
    
    override func loadView() {
        super.loadView()
        loadingLabel.blink()
    }
    
    //MARK: - Functions
    func fetchUser() {
        UserController.shared.fetchAppleUserReference { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let reference):
                    let predicate = NSPredicate(format: "%K==%@", argumentArray: [UserStrings.appleUserRefKey, reference!])
                    UserController.shared.fetchProfile(predicate: predicate) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let users):
                                guard let user = users?.first else { return }
                                UserController.shared.currentUser = user
                                self.presentHomeTab()
                            case .failure(_):
                                print("No user found in publicDB")
                            }
                        }
                    }
                    
                case .failure(let error):
                    print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }//end of func
    
    func presentHomeTab() {
        DispatchQueue.main.async {
            if UserController.shared.currentUser != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let rootVC = storyboard.instantiateInitialViewController() else { return }
                rootVC.modalPresentationStyle = .fullScreen
                
                self.present(rootVC, animated: true, completion: nil)
            }
        }
    }

}
