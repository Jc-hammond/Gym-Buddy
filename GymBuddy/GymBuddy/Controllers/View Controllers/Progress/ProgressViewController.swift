//
//  ProgressViewController.swift
//  GymBuddy
//
//  Created by James Chun on 6/21/21.
//

import UIKit

class ProgressViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var progressCollectionView: UICollectionView!
    
    //MARK: - Properties
    private lazy var progressDataSource = {
        ProgressDataSource(collectionView: progressCollectionView)
    }()
    
    static let shared = ProgressViewController()
    var activeFetchGroup = DispatchGroup()
    var refresh: UIRefreshControl = UIRefreshControl()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        progressCollectionView.delegate = self
        progressCollectionView.dataSource = progressDataSource
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    //MARK: - Actions
    @IBAction func disclaimerButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "DISCLAIMER", message: "The features on this page are for tracking purposes only. These features are not health or medical advice or suggestions. Please consult a doctor or medical professional before engaging in any type of workout and/or exercise, and before using this app. See app description for more details.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Fetching
    func fetchData() {
        guard let currentUser = UserController.shared.currentUser else { return }
        WorkoutController.shared.fetchWorkout(for: currentUser) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("successfully fetched workouts")
                    self.refresh.endRefreshing()
                    self.progressDataSource.applyData()
                    self.progressCollectionView.reloadData()
                case .failure(let error):
                    print("Error in \(#function) : On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    //MARK: - Refresh
    func setupViews() {
        refresh.attributedTitle = NSAttributedString(string: "Updating data")
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        progressCollectionView.addSubview(refresh)
    }
    
    @objc func loadData() {
        fetchData()
    }
    
}//End of class

//MARK: - Extensions
extension ProgressViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let destinationVC = storyboard?.instantiateViewController(identifier: "ProgressDetailViewController") as? ProgressDetailViewController,
              (indexPath.section == 1 || indexPath.section == 3) else { return }
        
        if indexPath.section == 1 {
            let itemToSend = progressDataSource.inProgress[indexPath.row]
            destinationVC.workout = itemToSend
            destinationVC.section = indexPath.section
        } else if indexPath.section == 3 {
            let itemToSend = progressDataSource.completed[indexPath.row]
            destinationVC.workout = itemToSend
            destinationVC.section = indexPath.section
        }
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }//end of func
    
    
}//End of extension

