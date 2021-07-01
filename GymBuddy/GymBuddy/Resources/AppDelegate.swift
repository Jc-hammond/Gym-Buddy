//
//  AppDelegate.swift
//  GymBuddy
//
//  Created by Connor Hammond on 6/15/21.
//

import UIKit
import CloudKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        UserController.shared.fetchAppleUserReference { result in
//            activeGroup.enter()
//                switch result {
//                case .success(let reference):
//                    let predicate = NSPredicate(format: "%K==%@", argumentArray: [UserStrings.appleUserRefKey, reference!])
//                    UserController.shared.fetchProfile(predicate: predicate) { result in
//                        switch result {
//                        case .success(let users):
//                            guard let user = users?.first else { return }
//                            UserController.shared.currentUser = user
//                            presentTabBarController()
//                        case .failure(let error):
//                            print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
//                        }
//                    }
//
//                case .failure(let error):
//                    print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
//                }
//            activeGroup.leave()
//        }
//
//        func presentTabBarController() {
//            DispatchQueue.main.async {
//                if UserController.shared.currentUser != nil {
//                    let storyboard = UIStoryboard(name: "InitialProfile", bundle: nil)
//                    guard let rootVC = storyboard.instantiateInitialViewController() else { return }
//                    //rootVC.modalPresentationStyle = .fullScreen
//
//                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    guard let tabbarVC = mainStoryboard.instantiateInitialViewController() else { return }
//                    rootVC.present(tabbarVC, animated: true, completion: nil)
//                }
//            }
//        }
//
//        func presentAlertController(title: String, message: String) {
//            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default)
//
//            alertController.addAction(okAction)
//            let storyboard = UIStoryboard(name: "InitialProfile", bundle: nil)
//            guard let rootVC = storyboard.instantiateViewController(identifier: "InitialProfileViewController") as? InitialProfileViewController else { return }
//            rootVC.present(alertController, animated: true, completion: nil)
//        }
//
//
//        CKContainer.default().accountStatus { status, error in
//            if let error = error {
//                print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
//                //Alertcontroller?
//            } else {
//                switch status {
//                case .available:
//                    print("successfully fetched apple user ref")
//                case .noAccount:
//                    presentAlertController(title: "No Account", message: "Please make sure your device is logged into iCloud")
//                case .couldNotDetermine:
//                    presentAlertController(title: "Could not determine", message: "Please check your iCloud account")
//                case .restricted:
//                    presentAlertController(title: "Restricted", message: "Your iCloud account is restricted")
//                @unknown default:
//                    presentAlertController(title: "Unknown Error", message: "Unknown error found while launching the app")
//                }
//            }
//        }
        
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

