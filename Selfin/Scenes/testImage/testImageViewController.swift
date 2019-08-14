//
//  testImageViewController.swift
//  Selfin
//
//  Created by cis on 04/03/19.
//  Copyright © 2019 Selfin. All rights reserved.
//

import UIKit

class testImageViewController: UIViewController {
    @IBOutlet weak var imageview: UIImageView!
    let picker = UIImagePickerController()
    var delegate : testImageCoordinatorProtocol?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.allowsEditing = false
        picker.delegate = self
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func actionNext(_ sender: Any) {
        if let image = imageview.image {
           delegate?.didMoveToCreatePost(image: image)
        }
    }
}
extension testImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @available(iOS 2.0, *)
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        
        let updatedImage = image.updateImageOrientionUpSide()
        
        let resized = updatedImage.resizeImageUsingVImage(size: resizeInAspectRation(image: updatedImage))
        if let resized = resized {
             imageview.image = resized
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func resizeInAspectRation(image : UIImage) -> CGSize {
        let size = image.size
        let targetSize = CGSize.init(width: 800, height: 800)
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize.init(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize.init(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        return newSize
    }
    
    @available(iOS 2.0, *)
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
