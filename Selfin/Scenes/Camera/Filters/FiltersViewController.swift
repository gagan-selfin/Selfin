//
//  FiltersViewController.swift
//  Selfin
//
//  Created by cis on 04/01/2019.
//  Copyright © 2019 Selfin. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {
    var image : UIImage?
    @IBOutlet var postImage: UIImageView!
    
    @IBOutlet var slider: CustomSlide!
    @IBOutlet var sliderWidth: NSLayoutConstraint!
    
    @IBOutlet var buttonFilter: UIButton!
    @IBOutlet var buttonEdit: UIButton!
    
    //Edit Image options
    @IBOutlet var buttonBrighteness: UIButton!
    @IBOutlet var buttonContrast: UIButton!
    @IBOutlet var buttonSaturation: UIButton!
    @IBOutlet var buttonCrop: UIButton!
    
    //**** UI Adjustment ****
    @IBOutlet var editingView: UIView! //Contains editing options, appears when user opt to edit Image
    @IBOutlet var collectionView: CameraCollectionView! //contains filters, appear initially or when user swicth back to add filters
    @IBOutlet var sliderView: UIView! //To perform image editing, appear at the botton when user opt for any Image editing option
    @IBOutlet var actionOnImageView: UIView! //Appears at bottom giving user an option to move next to creat post
    @IBOutlet var buttonReset: UIButton!//To revert crop
    @IBOutlet var viewApplyEditing: UIView! //appear at the top when user opt for any adidting option
    @IBOutlet var displayEditingOption: UILabel!
    @IBOutlet var buttonCancel: UIButton!//Back to camera
    
    //Features
    var imageToEdit: UIImage!
    let viewModel = FiltersViewModel()
    weak var delegate : FiltersViewDelegate?
    var cropView : CroppingFrame?
    var originalImage :UIImage?
    
    //MARK:-
    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()}
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown, .faceUp, .faceDown:
            sliderWidth.constant = UIScreen.main.bounds.width - 40
        default:
            sliderWidth.constant = UIScreen.main.bounds.height - 40
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        handleSliderOrientation()
        cropView?.handleDeviceOrientation()
        view.layoutIfNeeded()}
    
    //MARK:-
    //MARK:- Custome Method
    fileprivate func setup() {
        postImage.image = image
        imageToEdit = image //store the original image to apply filters and edit options
        collectionView.display(image: image!)
        collectionView.didSelect = didSelect
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            cropView = CroppingFrame.init(frame: CGRect(x: 0 , y: 0, width: self.view.frame.height - 60, height: self.view.frame.height - 60))
        case .portrait , .portraitUpsideDown, .faceDown, .faceUp:
            cropView = CroppingFrame.init(frame: CGRect(x: 0 , y: 0, width: self.view.frame.width - 60, height: self.view.frame.width - 60))
        default:break
        }
        initialUISetup()
    }
    
    //Shows Available filters on top
    //Show Edit option button and move to next screen button
    func initialUISetup() {
        //Top views
        collectionView.isHidden = false
        editingView.isHidden = true
        //Bottom views
        buttonReset.isHidden = true
        sliderView.isHidden = true
        actionOnImageView.isHidden = false
        buttonFilter.isSelected = true //Means filters are showing at the top
        buttonEdit.isSelected = false
        viewApplyEditing.isHidden = true
        buttonCancel.isHidden = false
    }
    
    //When user select Editing option
    //Show all editing option on top
    func allowEditingUISetUp() {
        //Top views
        collectionView.isHidden = true
        editingView.isHidden = false
        //Bottom views
        buttonReset.isHidden = true
        sliderView.isHidden = true
        actionOnImageView.isHidden = false
        
        buttonFilter.isSelected = false
        buttonEdit.isSelected = true
        viewApplyEditing.isHidden = true
        buttonCancel.isHidden = false
        cropView?.removeFromSuperview()
        resetFilter()
        viewModel.resetEditValues()
    }
    
    //When user click on any of editing option
    //Show slider in bottom
    func performEditingUISetup() {
        //Top views
        collectionView.isHidden = true
        editingView.isHidden = false
        //Bottom views
        sliderView.isHidden = false
        handleSliderOrientation()
        buttonReset.isHidden = true
        actionOnImageView.isHidden = true
        
        viewApplyEditing.isHidden = false
        buttonCancel.isHidden = true
        resetFilter()
    }
    
    func performCroppingUISetup() {
        buttonReset.isHidden = false
        sliderView.isHidden = true
        actionOnImageView.isHidden = true
        viewModel.addCropView(cropView: cropView!, postImage: postImage)
    }
    
    func resetFilter() {
        buttonBrighteness.isSelected = false
        buttonContrast.isSelected = false
        buttonSaturation.isSelected = false
        buttonCrop.isSelected = false
    }
    
    func handleSliderOrientation()  {
        //Set slider to vertical in landscape mode
        //Back to its original position in potrait mode
        var angle = CGFloat()
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight: angle = .pi/2; collectionView.landscapeLayout()
        case .portrait , .portraitUpsideDown, .faceDown, .faceUp: angle = 0; collectionView.portraitLayout()
        default:break
        }
        let trans : CGAffineTransform = CGAffineTransform.init(rotationAngle: angle)
        slider.transform = trans
        view.layoutIfNeeded()
    }
    
    func didSelect(image: UIImage) {postImage.image = image; imageToEdit = image}
    
    //MARK:-
    //MARK:- UI Action
    
    @IBAction func actionCancel(_ sender: Any) {delegate?.didPerformAction(action: .didCancel())}
    
    @IBAction func actionCancelEditing(_ sender: Any) {
        postImage.image = imageToEdit; allowEditingUISetUp()}
    
    @IBAction func applyEditing(_ sender: Any) {
        if cropView!.isDescendant(of: self.postImage) {
            originalImage = self.postImage.image
            self.postImage.image = viewModel.cropImage(postImage: postImage, cropView: cropView!)
            cropView?.removeFromSuperview()
            imageToEdit = postImage.image
        }else {
            imageToEdit = postImage.image; allowEditingUISetUp()
            collectionView.display(image: postImage.image!)
        }}
    
    @IBAction func actionOnImage(_ sender: UIButton) {
        if sender == buttonFilter {initialUISetup(); return}
        allowEditingUISetUp()}
    
    @IBAction func actionReset(_ sender: Any) {
        if originalImage != nil { postImage.image = originalImage; viewModel.addCropView(cropView: cropView!, postImage: postImage)}
    }
    
    @IBAction func actionEditImage(_ sender: UIButton) {
        viewModel.allowImageEditing(sender: sender, brightness: buttonBrighteness, contrast: buttonContrast, saturation: buttonSaturation, crop: buttonCrop, slider: slider, controller: self)}
    
    @IBAction func sliderValue(_ sender: UISlider) {
        postImage.image = viewModel.performEditing(image: imageToEdit, brightness: buttonBrighteness, contrast: buttonContrast, saturation: buttonSaturation, sender: sender)}
    
    @IBAction func actionNext(_ sender: Any) {
        delegate?.didPerformAction(action: .didMoveToCreatePost(image: postImage.image!))
    }
}
