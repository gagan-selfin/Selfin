//
//  MainViewController.swift
//  Selfin
//
//  Created by Marlon Monroy on 6/30/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UITabBarController {
	private let cameraButton = UIButton(type: .system)
	var containerView: UIView!
	var curve = UIImageView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tabImage()
	}
	
	override func viewDidAppear(_: Bool) {
		super.viewDidAppear(true)
		if cameraButton.isDescendant(of: view) {
			cameraButton.removeFromSuperview()}
        if isPortraitMode() {setup(mode: "potrait")}else {setup(mode: "Landscape")}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		tabBar.barStyle = .default
	}
	
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        cameraButton.removeFromSuperview()
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown:
            setup(mode: "potrait")
        default:
            setup(mode: "Landscape")
        }
        view.layoutIfNeeded()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
   
	
	private func setup(mode: String) {
        if mode == "potrait" {
            cameraButton.translatesAutoresizingMaskIntoConstraints = false
            cameraButton.layer.cornerRadius = 50
            cameraButton.contentMode = .scaleAspectFill
            cameraButton.setBackgroundImage(#imageLiteral(resourceName: "camera"), for: .normal)
            view.addSubview(cameraButton)
            
			if #available(iOS 11, *) {
				let guide = view.safeAreaLayoutGuide
				NSLayoutConstraint.activate([
					cameraButton.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 1.0),
					guide.bottomAnchor.constraint(equalToSystemSpacingBelow: cameraButton.bottomAnchor, multiplier: 4.0),
					])
				
			} else {
				NSLayoutConstraint.activate([
					cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
					
					bottomLayoutGuide.topAnchor.constraint(equalTo: cameraButton.bottomAnchor, constant: 30),
					])
			}
        }else{
           
            cameraButton.translatesAutoresizingMaskIntoConstraints = false
            cameraButton.layer.cornerRadius = 50
            cameraButton.contentMode = .scaleAspectFill
            cameraButton.setBackgroundImage(#imageLiteral(resourceName: "camera"), for: .normal)
            view.addSubview(cameraButton)
            
            if #available(iOS 11, *) {
                let guide = view.safeAreaLayoutGuide
                NSLayoutConstraint.activate([
                    
                    guide.rightAnchor.constraint(equalToSystemSpacingAfter: cameraButton.rightAnchor, multiplier: 0.5),
                    
//                    guide.leftAnchor.constraint(equalToSystemSpacingAfter: view.rightAnchor, multiplier: 1),
                    cameraButton.centerYAnchor.constraint(equalToSystemSpacingBelow: view.centerYAnchor, multiplier: 1.0)
                    

                    ])
                
            } else {
                NSLayoutConstraint.activate([
                    cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                    
                    bottomLayoutGuide.topAnchor.constraint(equalTo: cameraButton.bottomAnchor, constant: 30),
                    ])
            }
        }
		view.updateConstraints()
		cameraButton.addTarget(self, action: #selector(didSelectCamera(sender:)), for: .touchUpInside)
	}
	
	func tabImage() {
		curve.image = UIImage(named: "tabbar_curve_image")
		tabBar.addSubview(curve)
		tabBar.unselectedItemTintColor = .black
		tabBar.backgroundImage = UIImage()
		tabBar.shadowImage = UIImage()
		tabBar.backgroundColor = .clear
		tabBar.isTranslucent = false
		curve.translatesAutoresizingMaskIntoConstraints = false
		
        NSLayoutConstraint.activate([
            curve.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor, constant: 0),
            curve.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor, constant: 0),
            curve.heightAnchor.constraint(equalToConstant: 85.0),
            curve.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -28)
        ])
       
		view.layoutIfNeeded()
	}
	
	func hideCamera(hides:Bool) {
		UIView.animate(withDuration: 0.2) {
			self.cameraButton.layer.opacity = hides ? 0 : 1
			self.cameraButton.isHidden = hides
		}
	}
	
	@objc func didSelectCamera(sender _: UIButton) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                if let dele = self.delegate as? CameraCoordinatorDelegate {
                    dele.camereSelected()
                }
            } else {
                self.showAlert(str: "please grant camera permission to Selfin.")
            }
        }

		
	}
}
