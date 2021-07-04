//
//  HomeViewController.swift
//  GymBuddy
//
//  Created by James Chun on 6/21/21.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var profileNameButton: UIButton!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    //MARK: - Properties
    private lazy var homeDataSource = {
        HomeDataSource(collectionView: homeCollectionView)
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = homeDataSource
        
        activeDispatchGroup.notify(queue: .main) {
            self.updateViews()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activeDispatchGroup.notify(queue: .main) {
            self.updateViews()
        }
                
        homeDataSource.applyData()
    }
    
    //MARK: - Actions
    @IBAction func profileButtonsTapped(_ sender: UIButton) {
        //JCHUN - Segue to profileDetailVC
        guard let destinationVC = storyboard?.instantiateViewController(identifier: "ProfileViewController") as? ProfileViewController else { return }
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    //MARK: - Functions
    func updateViews() {
        guard let currentUser = UserController.shared.currentUser else { return }
        profileNameButton.tintColor = .clear
        profileNameButton.titleLabel?.font = UIFont(name: FontNames.sfRoundedSemiBold, size: 36)
        profileNameButton.setTitle(currentUser.fullName, for: .normal)
        
        profileImageButton.tintColor = .clear
        profileImageButton.addCornerRadius()
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

extension HomeViewController: UICollectionViewDelegate {
    
}
