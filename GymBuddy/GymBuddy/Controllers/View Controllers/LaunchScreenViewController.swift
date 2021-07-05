//
//  LaunchScreenViewController.swift
//  GymBuddy
//
//  Created by James Chun on 7/5/21.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        logoImageView.blink()
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
