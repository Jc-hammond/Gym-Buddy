//
//  PhotoSelectorViewController.swift
//  GymBuddy
//
//  Created by Connor Hammond on 7/6/21.
//

import UIKit

class PhotoSelectorViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var selectPhotoButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    //MARK: - Properties
    weak var delegate: PhotoSelectorViewControllerDelegate?
    
    
    
    //MARK: - Lifecycle
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        photoImageView.image = nil
        selectPhotoButton.setTitle("Select Photo", for: .normal)
    }
    
    //MARK: - Actions
    @IBAction func selectPhotoButtonTapped(_ sender: Any) {
        presentImagePickerActionSheet()
    }
    
    
    
    //MARK: - Functions
    
    
    
    
    //MARK: - Table View Data Source
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension PhotoSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            selectPhotoButton.setTitle("", for: .normal)
            photoImageView.image = photo
            delegate?.photoSelectorViewControllerSelected(image: photo)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func presentImagePickerActionSheet() {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Select a Photo", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            actionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (_) in
                
                imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                
                imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
}//End of extension
