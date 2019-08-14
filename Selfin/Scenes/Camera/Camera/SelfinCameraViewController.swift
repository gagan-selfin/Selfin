//
//  SelfinCameraViewController.swift
//  Selfin
//
//  Created by cis on 03/01/2019.
//  Copyright © 2019 Selfin. All rights reserved.
//

import UIKit

class SelfinCameraViewController: UIViewController {
    @IBOutlet var cameraView: CameraView!
    let picker = UIImagePickerController()
    var delegate: CameraDelegate?
    var overlayImage : UIImageView?
    let viewModel = CameraViewModel()
    var timer : Timer?
    var labelSwipeUp = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    fileprivate func setup() {
        cameraView.didCaptureImage = didCaptureImage
        picker.allowsEditing = false
        picker.delegate = self
        cameraView.startSession()
        viewModel.fetchPhotos()
        addButtonsOverCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        if !labelSwipeUp.isDescendant(of: cameraView) && UserDefaults.standard.object(forKey: "isOverlayRemoved") != nil {
            animateSwipeUp()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer?.invalidate()
        labelSwipeUp.removeFromSuperview()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.rotateCamera(bounds: self.view.bounds)
    }
    
    @IBAction func actionFlashTouched(_ sender: UIButton) {
        if sender.isSelected {
            cameraView.flashMode = .off
            sender.isSelected = false
        } else {
            cameraView.flashMode = .on
            sender.isSelected = true
        }
    }
    
    @objc func actionCancel(){delegate?.didPerformNavigationActionOnCamera(action: .shouldDismissCamera())}
    
    @objc func actionGallery(){
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @objc func actionCamera(){cameraView.flip()}
    
    // capture Image
    func didCaptureImage(image: UIImage?) {
        if let captureIimage = image {
            //to show overlay for first time
            overlayImage?.removeFromSuperview()
            UserDefaults.standard.set(true, forKey: "isOverlayRemoved")
            let resized = captureIimage.resizeImageUsingVImage(size: resizeInAspectRation(image: captureIimage, isCaptured: false))
            if let resized = resized {
            delegate?.didPerformNavigationActionOnCamera(action: .didMoveToFilter(image: resized))
           }
        }
    }
    
    func animateSwipeUp() {
        labelSwipeUp.backgroundColor = .clear
        labelSwipeUp.textColor = .white
        labelSwipeUp.text = "Swipe up to take picture"
        labelSwipeUp.numberOfLines = 2
        let maxsize = CGSize.init(width: 220, height: 80)
        let size = labelSwipeUp.sizeThatFits(maxsize)
        labelSwipeUp.frame = CGRect.init(origin: CGPoint.init(x: (UIScreen.main.bounds.width/2-(size.width/2)), y: UIScreen.main.bounds.height-40), size: size)
        labelSwipeUp.textAlignment = .center
        cameraView.addSubview(labelSwipeUp)
        labelSwipeUp.alpha = 0.0
        
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { (timer) in
            UIView.animate(withDuration: 3.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2.0, options: [.curveEaseInOut], animations: {
                 self.labelSwipeUp.alpha = 1.0
                 self.labelSwipeUp.frame = CGRect.init(origin: CGPoint.init(x: (UIScreen.main.bounds.width/2-(size.width/2)), y: UIScreen.main.bounds.height-80), size: size)
            }, completion: { (true) in
                UIView.animate(withDuration: 0.4, animations: {
                    self.labelSwipeUp.alpha = 0.0
                }, completion: { (true) in
                    self.labelSwipeUp.frame = CGRect.init(origin: CGPoint.init(x: (UIScreen.main.bounds.width/2-(size.width/2)), y: UIScreen.main.bounds.height-40), size: size)
                })
            })
        })
    }
    
    func displayDemo() {
         if UserDefaults.standard.object(forKey: "isOverlayRemoved") == nil {
            let overlayImage = UIImageView(image: #imageLiteral(resourceName: "swipeUp"))
            overlayImage.frame = CGRect(x: UIScreen.main.bounds.width/2-100, y: (UIScreen.main.bounds.height-(UIScreen.main.bounds.width/4)), width: 200, height: 150)
            overlayImage.contentMode = .scaleAspectFit
            cameraView.addSubview(overlayImage)
            overlayImage.alpha = 0.0
            
            UIView.animate(withDuration: 1.0, delay: 0.25, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [.curveEaseInOut], animations: {
                overlayImage.alpha = 1.0
                overlayImage.frame = CGRect(x: UIScreen.main.bounds.width/2-100, y: UIScreen.main.bounds.height/1.8-75, width: 200, height: 150)
            }, completion: nil)
         }else {animateSwipeUp()}
    }
    
    // Need to be added after adding custom camera
    //So that they appear over Camera
    func addButtonsOverCamera() {
        let buttonFlash = UIButton()
        buttonFlash.addTarget(self, action: #selector(actionFlashTouched(_:)), for: .touchUpInside)
        buttonFlash.setImage(#imageLiteral(resourceName: "flashOff"), for: .normal)
        buttonFlash.setImage(#imageLiteral(resourceName: "thunder"), for: .selected)
        buttonFlash.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonCancel = UIButton()
        buttonCancel.addTarget(self, action: #selector(actionCancel), for: .touchUpInside)
        buttonCancel.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        buttonCancel.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonGallery = UIButton()
        buttonGallery.addTarget(self, action: #selector(actionGallery), for: .touchUpInside)
        if viewModel.images.count > 0 { buttonGallery.setImage(viewModel.images.first, for: .normal)}else { buttonGallery.setImage(#imageLiteral(resourceName: "gallery"), for: .normal)}
        buttonGallery.translatesAutoresizingMaskIntoConstraints = false
        buttonGallery.layer.cornerRadius = 5.0
        buttonGallery.clipsToBounds = true
        
        let buttonCamera = UIButton()
        buttonCamera.addTarget(self, action: #selector(actionCamera), for: .touchUpInside)
        buttonCamera.setImage(UIImage.init(named: "Loading"), for: .normal)
        buttonCamera.translatesAutoresizingMaskIntoConstraints = false
        
        cameraView.addSubview(buttonFlash)
        cameraView.addSubview(buttonCamera)
        cameraView.addSubview(buttonCancel)
        cameraView.addSubview(buttonGallery)
        
        if #available(iOS 11.0, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                
                buttonFlash.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
                buttonFlash.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
                buttonFlash.widthAnchor.constraint(equalToConstant:  40),
                buttonFlash.heightAnchor.constraint(equalToConstant: 40),
                
                buttonCancel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
                buttonCancel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
                buttonCancel.widthAnchor.constraint(equalToConstant:  40),
                buttonCancel.heightAnchor.constraint(equalToConstant: 40),
                
                buttonGallery.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -20),
                buttonGallery.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
                buttonGallery.widthAnchor.constraint(equalToConstant:  55),
                buttonGallery.heightAnchor.constraint(equalToConstant: 55),
                
                buttonCamera.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -20),
                buttonCamera.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
                buttonCamera.widthAnchor.constraint(equalToConstant:  40),
                buttonCamera.heightAnchor.constraint(equalToConstant: 40),
                ])
        } else {// Fallback on earlier versions
        }
        displayDemo()//Swipe up to take picture view
    }
}

extension SelfinCameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @available(iOS 2.0, *)
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        
        let updatedImage = image.updateImageOrientionUpSide()
        
        let resized = updatedImage.resizeImageUsingVImage(size: resizeInAspectRation(image: updatedImage, isCaptured: false))
        if let resized = resized {
            delegate?.didPerformNavigationActionOnCamera(action: .didMoveToFilter(image: resized))
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @available(iOS 2.0, *)
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func resizeInAspectRation(image : UIImage, isCaptured : Bool) -> CGSize {
        let size = image.size
        let targetSize:CGSize!
        
        if isCaptured {targetSize = CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }else {targetSize = CGSize.init(width: 800, height: 800)}
        
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
}
// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
