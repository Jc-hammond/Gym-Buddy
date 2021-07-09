//
//  HomeViewController.swift
//  GymBuddy
//
//  Created by James Chun on 6/21/21.
//

import UIKit
import CloudKit

class HomeViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var profileNameButton: UIButton!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var disclaimerButton: UIBarButtonItem!
    
    //MARK: - Properties
    private lazy var homeDataSource = {
        HomeDataSource(collectionView: homeCollectionView)
    }()
    let activeFetchGroup = DispatchGroup()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserController.shared.currentUser == nil {
            fetchUser()
        } else {
            fetchData()
        }
        
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = homeDataSource
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if UserController.shared.currentUser == nil {
                self.fetchUser()
            } else {
                self.fetchData()
            }
        }
        
    }
    
    //MARK: - Actions
    @IBAction func profileButtonsTapped(_ sender: UIButton) {
        guard let destinationVC = storyboard?.instantiateViewController(identifier: "ProfileViewController") as? ProfileViewController else { return }
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @IBAction func disclaimerButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "DISCLAIMER", message: "This is not medical or health advice. Weight data is only visible to you and not to any other users. The features on this page are not medical or health suggestions. Please consult a doctor or medical professional before engaging in any type of workout and/or exercise, and before using this app. See app description for more details.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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
                                self.fetchData()
                            case .failure(_):
                                print("No user found in publicDB")
                                self.presentInitialProfileVC()
                            }
                        }
                    }
                    
                case .failure(let error):
                    print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                    self.checkAccountStatus()
                }
                
            }
        }
        
    }//end of func
    
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
    }
    
    func fetchData() {
        guard let currentUser = UserController.shared.currentUser else { return }
        WorkoutController.shared.fetchWorkout(for: currentUser) { result in
            DispatchQueue.main.async {
                self.activeFetchGroup.enter()
                switch result {
                case .success(_):
                    print("successfully fetched workouts")
                    //self.refresh.endRefreshing()
                    self.homeCollectionView.reloadData()
                case .failure(let error):
                    print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                }
                self.activeFetchGroup.leave()
                self.activeFetchGroup.notify(queue: .main) {
                    self.homeDataSource.applyData()
                }
            }
        }
        
        activeFetchGroup.notify(queue: .main) {
            self.updateViews()
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
        let okAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {return}
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
    
    
    func updateViews() {
        guard let currentUser = UserController.shared.currentUser else { return }
        profileNameButton.tintColor = .clear
        profileNameButton.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 28)
        profileNameButton.setTitle(currentUser.fullName, for: .normal)
        
        profileImageButton.tintColor = .clear
        profileImageButton.addCornerRadius()
    }
    
}//End of class

//MARK: - Extensions
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                self.tabBarController?.selectedIndex = 1
            } else if indexPath.row == 1 {
                guard let destinationVC = storyboard?.instantiateViewController(identifier: "ProfileViewController") as? ProfileViewController else { return }
                navigationController?.pushViewController(destinationVC, animated: true)
            }
        }
    }//end of func
}//End of extension
