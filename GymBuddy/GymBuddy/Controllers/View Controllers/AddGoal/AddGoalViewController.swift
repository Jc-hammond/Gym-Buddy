//
//  AddGoalViewController.swift
//  GymBuddy
//
//  Created by James Chun on 6/21/21.
//

import UIKit

class AddGoalViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var exerciseButton: UIButton!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    fileprivate func updateViews() {
        exerciseButton.addCornerRadius()
        exerciseButton.setInsets(forContentPadding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), imageTitlePadding: 10)
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
