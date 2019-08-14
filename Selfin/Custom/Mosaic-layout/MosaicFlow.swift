//
//  MosaicFlow.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/7/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
    func dividedIntegral(fraction: CGFloat, from fromEdge: CGRectEdge) -> (first: CGRect, second: CGRect) {
        let dimension: CGFloat

        switch fromEdge {
        case .minXEdge, .maxXEdge:
            dimension = size.width
        case .minYEdge, .maxYEdge:
            dimension = size.height
        }

        let distance = (dimension * fraction).rounded(.up)
        var slices = divided(atDistance: distance, from: fromEdge)

        switch fromEdge {
        case .minXEdge, .maxXEdge:
            slices.remainder.origin.x += 1
            slices.remainder.size.width -= 1
        case .minYEdge, .maxYEdge:
            slices.remainder.origin.y += 1
            slices.remainder.size.height -= 1
        }

        return (first: slices.slice, second: slices.remainder)
    }
}

enum MosaicSegmentStyle {
    case fullWidth
    case fiftyFifty
    case twoThirdsOneThird
    case oneThirdTwoThirds
}

// UICollectionViewFlowLayout
// UICollectionViewLayout
class MosaicLayoutFlow: UICollectionViewLayout {
    var contentBounds = CGRect.zero
    var cachedAttributes = [UICollectionViewLayoutAttributes]()
    var scrollDirection: UICollectionView.ScrollDirection = .horizontal
    var lastframetest = CGRect()

    /// - Tag: PrepareMosaicLayout
    override func prepare() {
        super.prepare()
        if scrollDirection == .vertical {
            prepareForVertical()
        } else {
            prepareForHorizontal()
        }
    }

    func prepareForVertical() {
        guard let collectionView = collectionView else { return }
        // Reset cached information.
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        // For every item in the collection view:
        //  - Prepare the attributes.
        //  - Store attributes in the cachedAttributes array.
        //  - Combine contentBounds with attributes.frame.
        let count = collectionView.numberOfItems(inSection: 0)
        var currentIndex = 0
        var segment: MosaicSegmentStyle = .fullWidth
        var lastFrame: CGRect = .zero

        let cvWidth = collectionView.bounds.size.width

        while currentIndex < count {
            let segmentFrame = CGRect(x: 0, y: lastFrame.maxY + 1.0, width: cvWidth, height: 200.0)
            var segmentRects = [CGRect]()
            switch segment {
            case .fullWidth:
                segmentRects = [segmentFrame]

            case .fiftyFifty:
                let horizontalSlices = segmentFrame.dividedIntegral(fraction: 0.5, from: .minXEdge)
                segmentRects = [horizontalSlices.first, horizontalSlices.second]

            case .twoThirdsOneThird:
                let horizontalSlices = segmentFrame.dividedIntegral(fraction: (2.0 / 3.0), from: .minXEdge)
                let verticalSlices = horizontalSlices.second.dividedIntegral(fraction: 0.5, from: .minYEdge)
                segmentRects = [horizontalSlices.first, verticalSlices.first, verticalSlices.second]

            case .oneThirdTwoThirds:
                let horizontalSlices = segmentFrame.dividedIntegral(fraction: (1.0 / 3.0), from: .minXEdge)
                let verticalSlices = horizontalSlices.first.dividedIntegral(fraction: 0.5, from: .minYEdge)
                segmentRects = [verticalSlices.first, verticalSlices.second, horizontalSlices.second]
            }

            // Create and cache layout attributes for calculated frames.
            for rect in segmentRects {
                let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: currentIndex, section: 0))
                attributes.frame = rect
                cachedAttributes.append(attributes)
                lastFrame = rect
                contentBounds = contentBounds.union(lastFrame)
                currentIndex += 1
               
                lastframetest = lastFrame
            }

            // Determine the next segment style.
            switch count - currentIndex {
            case 1:
                segment = .fullWidth
            case 2:
                segment = .fiftyFifty
            default:
                switch segment {
                case .fullWidth:
                    segment = .fiftyFifty
                case .fiftyFifty:
                    segment = .twoThirdsOneThird
                case .twoThirdsOneThird:
                    segment = .oneThirdTwoThirds
                case .oneThirdTwoThirds:
                    segment = .fiftyFifty
                }
            }
        }
    }

    func prepareForHorizontal() {
        guard let collectionView = collectionView else { return }
        // Reset cached information.
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)

        let count = collectionView.numberOfItems(inSection: 0)

        var currentIndex = 0
        var segment: MosaicSegmentStyle = .fullWidth
        var lastFrame: CGRect = .zero

        let cHeight = collectionView.bounds.size.height

        while currentIndex < count {
           // let segmentFrame = CGRect(x: lastFrame.maxX + 1, y: 40, width: 300, height: cHeight - 50)
            let segmentFrame = CGRect(x: lastFrame.maxX - 1, y: 0, width: 300, height: cHeight - 10)
            var segmentRects = [CGRect]()
            switch segment {
            case .fullWidth:
                segmentRects = [segmentFrame]

            case .fiftyFifty:
                let horizontalSlices = segmentFrame.dividedIntegral(fraction: 0.5, from: .minYEdge)
                segmentRects = [horizontalSlices.first, horizontalSlices.second]

            case .twoThirdsOneThird:
                let horizontalSlices = segmentFrame.dividedIntegral(fraction: (2.0 / 3.0), from: .minYEdge)
                let verticalSlices = horizontalSlices.second.dividedIntegral(fraction: 0.5, from: .minXEdge)
                segmentRects = [horizontalSlices.first, verticalSlices.first, verticalSlices.second]

            case .oneThirdTwoThirds:
                let horizontalSlices = segmentFrame.dividedIntegral(fraction: (1.0 / 3.0), from: .minYEdge)
                let verticalSlices = horizontalSlices.first.dividedIntegral(fraction: 0.5, from: .minXEdge)
                segmentRects = [verticalSlices.first, verticalSlices.second, horizontalSlices.second]
            }

            // Create and cache layout attributes for calculated frames.
            for rect in segmentRects {
                let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: currentIndex, section: 0))
                attributes.frame = rect

                cachedAttributes.append(attributes)
                contentBounds = contentBounds.union(lastFrame)
                currentIndex += 1
                lastFrame = rect
            }

            // Determine the next segment style.
            switch count - currentIndex {
            case 1:
                segment = .fullWidth
            case 2:
                segment = .fiftyFifty
            default:
                switch segment {
                case .fullWidth:
                    segment = .fiftyFifty
                case .fiftyFifty:
                    segment = .twoThirdsOneThird
                case .twoThirdsOneThird:
                    segment = .oneThirdTwoThirds
                case .oneThirdTwoThirds:
                    segment = .fiftyFifty
                }
            }
        }
    }

    /// - Tag: CollectionViewContentSize
    override var collectionViewContentSize: CGSize {
        //return CGSize.init(width: contentBounds.size.width, height: contentBounds.size.height + lastframetest.size.height)
        return contentBounds.size
    }

    /// - Tag: ShouldInvalidateLayout
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }

    /// - Tag: LayoutAttributesForItem
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }

    /// - Tag: LayoutAttributesForElements
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArray = [UICollectionViewLayoutAttributes]()

        // Find any cell that sits within the query rect.
        guard let lastIndex = cachedAttributes.indices.last,
            let firstMatchIndex = binSearch(rect, start: 0, end: lastIndex) else { return attributesArray }

        // Starting from the match, loop up and down through the array until all the attributes
        // have been added within the query rect.
        for attributes in cachedAttributes[..<firstMatchIndex].reversed() {
            guard attributes.frame.maxY >= rect.minY else { break }
            attributesArray.append(attributes)
        }

        for attributes in cachedAttributes[firstMatchIndex...] {
            guard attributes.frame.minY <= rect.maxY else { break }
            attributesArray.append(attributes)
        }

        return attributesArray
    }

    // Perform a binary search on the cached attributes array.
    func binSearch(_ rect: CGRect, start: Int, end: Int) -> Int? {
        if end < start { return nil }

        let mid = (start + end) / 2
        let attr = cachedAttributes[mid]

        if attr.frame.intersects(rect) {
            return mid
        } else {
            if attr.frame.maxY < rect.minY {
                return binSearch(rect, start: (mid + 1), end: end)
            } else {
                return binSearch(rect, start: start, end: (mid - 1))
            }
        }
    }
}
