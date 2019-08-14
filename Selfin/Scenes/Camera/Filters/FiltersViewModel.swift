//
//  FiltersViewModel.swift
//  Selfin
//
//  Created by cis on 04/01/2019.
//  Copyright © 2019 Selfin. All rights reserved.
//

import Foundation
import UIKit

final class FiltersViewModel {
    var dictAppliedValues : [String: Float] = ["brightness": 0.0, "contrast": 1.0, "saturation": 1.0]
    var currentEditOption : UIButton?
    
    func performEditing(image : UIImage,brightness : UIButton, contrast:UIButton, saturation: UIButton,sender : UISlider) -> UIImage {
        
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: image)
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        
        switch currentEditOption {
        case brightness: // To adjust brightness
            filter?.setValue(sender.value / 10, forKey: kCIInputBrightnessKey)
            dictAppliedValues["brightness"] = sender.value / 10
        case contrast: // To adjust image contrast
            filter?.setValue(sender.value, forKey: kCIInputContrastKey)
            dictAppliedValues["contrast"] = sender.value
        case saturation: // To adjust image saturation
            filter?.setValue(sender.value, forKey: kCIInputSaturationKey)
            dictAppliedValues["saturation"] = sender.value
        default:
            break
        }
        
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        return UIImage(cgImage: filteredImageRef!)
    }
    
    func allowImageEditing(sender : UIButton,brightness : UIButton, contrast:UIButton, saturation: UIButton,crop : UIButton,  slider:CustomSlide, controller : FiltersViewController ) {
        controller.performEditingUISetup()
        sender.isSelected = true
        currentEditOption = sender
        if controller.cropView!.isDescendant(of: controller.postImage) {            controller.cropView?.removeFromSuperview()}
        switch sender {
        case brightness:
            slider.maximumValue = 1
            slider.minimumValue = 0
            slider.value = dictAppliedValues["brightness"]!
            controller.displayEditingOption.text = "Brightness"
        case contrast:
            slider.maximumValue = 2
            slider.minimumValue = 0
            slider.value = dictAppliedValues["contrast"]!
            controller.displayEditingOption.text = "Contrast"
        case saturation:
            slider.maximumValue = 2
            slider.minimumValue = 0
            slider.value = dictAppliedValues["saturation"]!
            controller.displayEditingOption.text = "Saturation"
        case crop:
            controller.displayEditingOption.text = "Crop"
            controller.performCroppingUISetup()
        default:
            break
        }
    }
    
    func resetEditValues(){
        dictAppliedValues = ["brightness": 0.0, "contrast": 1.0, "saturation": 1.0]
    }
    
    func cropImage(postImage : UIImageView, cropView : UIView) -> UIImage {
        let imsize = postImage.image!.size
        let ivsize = postImage.bounds.size
        
        var scale : CGFloat = ivsize.width / imsize.width
        if imsize.height * scale < ivsize.height {
            scale = ivsize.height / imsize.height
        }
        
        let dispSize = CGSize(width:ivsize.width/scale, height:ivsize.height/scale)
        let dispOrigin = CGPoint(x: (imsize.width-dispSize.width)/2.0,
                                 y: (imsize.height-dispSize.height)/2.0)
        
        let r = cropView.convert(cropView.bounds, to: postImage)
        let cropRect =
            CGRect(x:r.origin.x/scale+dispOrigin.x,
                   y:r.origin.y/scale+dispOrigin.y,
                   width:r.width/scale,
                   height:r.height/scale)
        
        let rend = UIGraphicsImageRenderer(size:cropRect.size)
        let croppedIm = rend.image { _ in
            postImage.image!.draw(at: CGPoint(x:-cropRect.origin.x,
                                                   y:-cropRect.origin.y))
        }
        
        return croppedIm
    }
    
    func addCropView(cropView : UIView , postImage : UIImageView) {
        if !cropView.isDescendant(of: postImage) {
            postImage.addSubview(cropView)
            postImage.isUserInteractionEnabled = true
            cropView.isUserInteractionEnabled = true
            cropView.translatesAutoresizingMaskIntoConstraints = false
            
            switch UIDevice.current.orientation {
            case .portrait, .portraitUpsideDown, .faceUp, .faceDown :
                if #available(iOS 11.0, *) {
                    let guide = postImage.safeAreaLayoutGuide
                    NSLayoutConstraint.activate([
                        cropView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
                        cropView.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
                        cropView.widthAnchor.constraint(equalToConstant:  postImage.frame.width - 60),
                        cropView.heightAnchor.constraint(equalToConstant: postImage.frame.width - 60),
                        ])
                } else {// Fallback on earlier versions
                }
               case .landscapeRight,.landscapeLeft:
                if #available(iOS 11.0, *) {
                    let guide = postImage.safeAreaLayoutGuide
                    NSLayoutConstraint.activate([
                        cropView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
                        cropView.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
                        cropView.widthAnchor.constraint(equalToConstant:  postImage.frame.height - 60),
                        cropView.heightAnchor.constraint(equalToConstant: postImage.frame.height - 60),
                        ])
                } else {// Fallback on earlier versions
                }
            default: break
            }
        }
    }
}
