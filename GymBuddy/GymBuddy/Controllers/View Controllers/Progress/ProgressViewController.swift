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
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressCollectionView.delegate = self
        progressCollectionView.dataSource = progressDataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        progressDataSource.applyData()
    }
    
}//End of class

//MARK: - Extensions
extension ProgressViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let destinationVC = storyboard?.instantiateViewController(identifier: "ProgressDetailViewController") as? ProgressDetailViewController else { return }
        
        if indexPath.section == 1 {
            let itemToSend = progressDataSource.mockWorkoutData[indexPath.row]
            destinationVC.workout = itemToSend
        } else if indexPath.section == 3 {
            let itemToSend = progressDataSource.mockCompletedWorkoutData[indexPath.row]
            destinationVC.workout = itemToSend
        }
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }//end of func
    
    
}//End of extension

