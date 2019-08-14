//
//  HSImageSlider.swift
//  HSImageSlider
//
//  Created by cis on 29/03/18.
//  Copyright © 2018 cis. All rights reserved.
//

import Nuke
import UIKit

class HSImageSlider: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: Variables

    var imageStringUrl: [String] = []
    private var imageData: [String] = []
    var selectedIndex: Int = 0
    @IBOutlet var collectionView: UICollectionView!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "cell_HSImageSlider", bundle: nil), forCellWithReuseIdentifier: "cell")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageData = imageStringUrl
        collectionView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.scrollToItem(at: IndexPath(row: selectedIndex, section: 0), at: .left, animated: true)
    }

    // MARK: Delegate

    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return imageData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! cell_HSImageSlider
        let stringURL = imageData[indexPath.row]
        if stringURL == "" {
            cell.HSImageView.image = #imageLiteral(resourceName: "Placeholder_image")
        } else {
            let imageURLProfile = stringURL
            if let urlProfile = URL(string: imageURLProfile) {
                Nuke.loadImage(with: urlProfile, into: cell.HSImageView)
            }
        }
        return cell
    }

    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt _: IndexPath) {
        // self.lbl_PageDetail.text = "\(indexPath.row)/\(self.imageData.count)"
    }

    func collectionView(_: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt _: IndexPath) {
        if let isCell = cell as? cell_HSImageSlider {
            isCell.scrollView.setZoomScale(1.0, animated: false)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }

    // MARK: Buttons

    @IBAction func btn_Dismiss(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func btn_ReportImage(_: UIButton) {}
}
