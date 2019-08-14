//
//  CameraCollectionView.swift
//  Selfin
//
//  Created by cis on 10/10/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Nuke
import UIKit

class CameraCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var labelName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10.0
        clipsToBounds = true
    }
}

class CameraCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var CIFilterNames = [
        ["filter": "CIPhotoEffectChrome", "name": "C"],
        ["filter": "CIPhotoEffectFade", "name": "F"],
        ["filter": "CIPhotoEffectInstant", "name": "I"],
        ["filter": "CIPhotoEffectNoir", "name": "N"],
        ["filter": "CIPhotoEffectProcess", "name": "P"],
        ["filter": "CIPhotoEffectTonal", "name": "To"],
        ["filter": "CIPhotoEffectTransfer", "name": "Tr"],
        ["filter": "CISepiaTone", "name": "ST"],
        ["filter": "CIVignette", "name": "V"],
    ]

    var image = UIImage()
    var selectedIndex = Int()
    let layout = UICollectionViewFlowLayout()


    override func awakeFromNib() {
        delegate = self
        dataSource = self
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown, .faceDown, .faceUp:
            portraitLayout()
        case .landscapeRight, .landscapeLeft: landscapeLayout()
        default:break
        }
    }
    
    func landscapeLayout()  {
        layout.scrollDirection = .vertical
        collectionViewLayout = layout
    }
    
    func portraitLayout()  {
        layout.scrollDirection = .horizontal
        collectionViewLayout = layout
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return CIFilterNames.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CameraCollectionViewCell", for: indexPath) as! CameraCollectionViewCell

        if indexPath.item == selectedIndex {
            cell.imageView.layer.borderColor = UIColor.white.cgColor
            cell.imageView.layer.borderWidth = 5.0
        } else {
            cell.imageView.layer.borderColor = UIColor.clear.cgColor
            cell.imageView.layer.borderWidth = 0.0
        }

        if indexPath.row == 0 {
            cell.imageView.image = image
            cell.labelName.text = "O"
        } else {
            // Create filters
            let ciContext = CIContext(options: nil)
            let coreImage = CIImage(image: image)
            let filter = CIFilter(name: CIFilterNames[indexPath.item - 1]["filter"]!)
            filter!.setDefaults()
            filter!.setValue(coreImage, forKey: kCIInputImageKey)
            let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
            cell.imageView.image = UIImage(cgImage: filteredImageRef!)
            cell.labelName.text = CIFilterNames[indexPath.item - 1]["name"]
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath) as! CameraCollectionViewCell
        cell.imageView.layer.borderColor = UIColor.white.cgColor
        cell.imageView.layer.borderWidth = 5.0
        didSelect?(cell.imageView.image!)
        selectedIndex = indexPath.row
        collectionView.reloadData()
    }

    @available(iOS 6.0, *)
    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 65)
    }

    func display(image: UIImage) {
        self.image = image
        reloadData()
    }

    var didSelect: ((_ image: UIImage) -> Void)?
}
