//
//  cell_HSImageSlider.swift
//  HSImageSlider
//
//  Created by cis on 29/03/18.
//  Copyright © 2018 cis. All rights reserved.
//

import UIKit

class cell_HSImageSlider: UICollectionViewCell, UIScrollViewDelegate {
    // MARK: Variable

    @IBOutlet var HSImageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    private var minimumZoomScale: CGFloat = 1.0
    private var maximumZoomScale: CGFloat = 6.0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gesture = UITapGestureRecognizer(target: self, action: #selector(fuction_HandleTapGesture(_:)))
        gesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(gesture)
        scrollView.delegate = self
        scrollView.minimumZoomScale = minimumZoomScale
        scrollView.maximumZoomScale = maximumZoomScale
    }

    @objc func fuction_HandleTapGesture(_: UITapGestureRecognizer) {
        if scrollView.zoomScale == minimumZoomScale {
            scrollView.setZoomScale(maximumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(minimumZoomScale, animated: true)
        }
    }

    func viewForZooming(in _: UIScrollView) -> UIView? {
        return HSImageView
    }
}
