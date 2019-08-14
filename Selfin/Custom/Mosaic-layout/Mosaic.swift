//
//  Mosaic.swift
//  self-in
//
//  Created by Marlon Monroy on 4/27/18.
//  Copyright © 2018 Self-in. All rights reserved.
//

import UIKit
enum MosaicCellType {
    case small
    case big
}

protocol MosaicLayoutDelegate: class {
    func cellSizeType(collection: UICollectionView, indexPath: IndexPath) -> MosaicCellType
    func heightForSmallCell() -> CGFloat
    func inset(collection: UICollectionView, layout: MosaicLayout, in section: Int) -> UIEdgeInsets
}

extension MosaicLayoutDelegate where Self: UserProfileCollectionView {
    func cellSizeType(collection _: UICollectionView, indexPath: IndexPath) -> MosaicCellType {
        return indexPath.item % 9 == 0 ? .big : .small
    }

    func heightForSmallCell() -> CGFloat {
        return 111
    }

    func inset(collection _: UICollectionView, layout _: MosaicLayout, in _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 12)
    }
}

struct MosaicColumns {
    var columns: [MosaicColumn]

    var smallestColumn: MosaicColumn { return columns.sorted().last! }

    init() {
        columns = [MosaicColumn](repeating: MosaicColumn(), count: 3)
    }

    subscript(index: Int) -> MosaicColumn {
        get {
            return columns[index]
        }
        set(newColumn) {
            columns[index] = newColumn
        }
    }
}

struct MosaicColumn {
    var columnHeight: CGFloat

    init() {
        columnHeight = 0
    }

    mutating func appendToColumn(with height: CGFloat) {
        columnHeight += height
    }
}

extension MosaicColumn: Equatable {}
extension MosaicColumn: Comparable {}

// MARK: Equatable

func == (lhs: MosaicColumn, rhs: MosaicColumn) -> Bool {
    return lhs.columnHeight == rhs.columnHeight
}

// MARK: Comparable

func <= (lhs: MosaicColumn, rhs: MosaicColumn) -> Bool {
    return lhs.columnHeight <= rhs.columnHeight
}

func > (lhs: MosaicColumn, rhs: MosaicColumn) -> Bool {
    return lhs.columnHeight > rhs.columnHeight
}

func < (lhs: MosaicColumn, rhs: MosaicColumn) -> Bool {
    return lhs.columnHeight < rhs.columnHeight
}

func >= (lhs: MosaicColumn, rhs: MosaicColumn) -> Bool {
    return lhs.columnHeight >= rhs.columnHeight
}

class MosaicLayout: UICollectionViewFlowLayout {
    weak var delegate: MosaicLayoutDelegate!
    var columns = MosaicColumns()
    var cachedLayoutAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    let numberOfColumnsSection = 3
    var contentWidth: CGFloat {
        return collectionView!.bounds.size.width
    }

    override func prepare() {
        super.prepare()
        resetState()
        setupLayout()
    }

    override var collectionViewContentSize: CGSize {
        let height = columns.smallestColumn.columnHeight
        return CGSize(width: contentWidth, height: height)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var rects = [UICollectionViewLayoutAttributes]()
        cachedLayoutAttributes.forEach {
            if rect.intersects($1.frame) {
                rects.append($1)
            }
        }
        return rects
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedLayoutAttributes[indexPath]
    }

    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let currentBounds: CGRect = collectionView!.bounds

        if currentBounds.size.equalTo(newBounds.size) {
            prepare()
            return true
        }

        return false
    }

    func setupLayout() {
        var smallCellIndexPathBuffered = [IndexPath]()
        var lastBigCellOnLeftSide = false
        for cellIndex in 0 ..< collectionView!.numberOfItems(inSection: 0) {
            (lastBigCellOnLeftSide, smallCellIndexPathBuffered) = createCellLayout(with: cellIndex, bigCellSide: lastBigCellOnLeftSide, cellBuffer: smallCellIndexPathBuffered)
        }

        if !smallCellIndexPathBuffered.isEmpty {
            addSmallCellLayout(at: smallCellIndexPathBuffered[0], for: smallest())
            smallCellIndexPathBuffered.removeAll()
        }
    }

    func resetState() {
        columns = MosaicColumns()
        cachedLayoutAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    }

    func createCellLayout(with index: Int, bigCellSide: Bool, cellBuffer: [IndexPath]) -> (Bool, [IndexPath]) {
        let indexCellPath = IndexPath(item: index, section: 0)
        let cellType = mosaicCellType(index: indexCellPath)
        var newBuffer = cellBuffer
        var newSide = bigCellSide
        if cellType == .big {
            newSide = creatBigCellLayout(with: indexCellPath, and: bigCellSide)
        }
        if cellType == .small {
            newBuffer = createSmallCellLayout(with: indexCellPath, and: newBuffer)
        }
        return (newSide, newBuffer)
    }

    func smallest() -> Int {
        var index = 0
        for i in 1 ..< numberOfColumnsSection {
            if columns[i] < columns[index] {
                index = i
            }
        }
        return index
    }

    func creatBigCellLayout(with index: IndexPath, and cellSide: Bool) -> Bool {
        addBigCellLayout(at: index, for: cellSide ? 1 : 0)
        return !cellSide
    }

    func createSmallCellLayout(with indexPath: IndexPath, and buffer: [IndexPath]) -> [IndexPath] {
        var newBuffer = buffer
        newBuffer.append(indexPath)
        if newBuffer.count >= 2 {
            addSmallCellLayout(at: newBuffer[0], for: smallest())
            addSmallCellLayout(at: newBuffer[1], for: smallest())
            newBuffer.removeAll()
        }
        return newBuffer
    }

    func addSmallCellLayout(at indexPath: IndexPath, for column: Int) {
        let height = layoutAttributes(with: .small, and: indexPath, at: column)
        columns[column].appendToColumn(with: height)
    }

    func addBigCellLayout(at indexPath: IndexPath, for column: Int) {
        let height = layoutAttributes(with: .big, and: indexPath, at: column)
        columns[column].appendToColumn(with: height)
        columns[column + 1].appendToColumn(with: height)
    }

    func layoutAttributes(with cellType: MosaicCellType, and indexPath: IndexPath, at column: Int) -> CGFloat {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let frame = cellRect(with: cellType, and: indexPath, at: column)
        attributes.frame = frame
        let height = attributes.frame.size.height + insets().top
        cachedLayoutAttributes[indexPath] = attributes
        return height
    }

    func cellRect(with type: MosaicCellType, and _: IndexPath, at column: Int) -> CGRect {
        let inset = insets()
        let x = CGFloat(column) * (contentWidth / CGFloat(numberOfColumnsSection)) + inset.left
        let y = columns[column].columnHeight + inset.top
        let height = cellContenHeight(for: type) - inset.right
        let width = cellContentWidth(for: type) - inset.bottom

        return CGRect(x: x, y: y, width: width, height: height)
    }

    func insets() -> UIEdgeInsets {
        return delegate.inset(collection: collectionView!, layout: self, in: 0)
    }

    func cellContenHeight(for cellType: MosaicCellType) -> CGFloat {
        let height = delegate.heightForSmallCell()
        // let height = contentWidth / 3
        return cellType == .big ? height * 2 : height
    }

    func cellContentWidth(for cellType: MosaicCellType) -> CGFloat {
        let width = contentWidth / 3

        return cellType == .big ? width * 2 : width
    }

    func mosaicCellType(index indexPath: IndexPath) -> MosaicCellType {
        return delegate.cellSizeType(collection: collectionView!, indexPath: indexPath)
    }
}

protocol GridLayoutDelegate: class {
    func scaleForItem(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, atIndexPath indexPath: IndexPath) -> UInt
    func itemFlexibleDimension(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat
    func headerFlexibleDimension(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat
}

extension GridLayoutDelegate {
    func scaleForItem(inCollectionView _: UICollectionView, withLayout _: UICollectionViewLayout, atIndexPath _: IndexPath) -> UInt {
        return 1
    }

    func itemFlexibleDimension(inCollectionView _: UICollectionView, withLayout _: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat {
        return fixedDimension
    }

    func headerFlexibleDimension(inCollectionView _: UICollectionView, withLayout _: UICollectionViewLayout, fixedDimension _: CGFloat) -> CGFloat {
        return 0
    }
}

class GridLayout: UICollectionViewLayout, GridLayoutDelegate {
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    // User-configurable 'knobs'
    var scrollDirection: UICollectionView.ScrollDirection = .vertical

    // Spacing between items
    var itemSpacing: CGFloat = 0

    // Prevent the user from giving an invalid fixedDivisionCount
    var fixedDivisionCount: UInt {
        get {
            return UInt(intFixedDivisionCount)
        }
        set {
            intFixedDivisionCount = newValue == 0 ? 1 : Int(newValue)
        }
    }

    weak var delegate: GridLayoutDelegate?

    /// Backing variable for fixedDivisionCount, is an Int since indices don't like UInt
    private var intFixedDivisionCount = 1
    private var contentWidth: CGFloat = 0
    private var contentHeight: CGFloat = 0
    private var itemFixedDimension: CGFloat = 0
    private var itemFlexibleDimension: CGFloat = 0

    /// This represents a 2 dimensional array for each section, indicating whether each block in the grid is occupied
    /// It is grown dynamically as needed to fit every item into a grid
    private var sectionedItemGrid: Array<Array<Array<Bool>>> = []

    /// The cache built up during the `prepare` function
    private var itemAttributesCache: Array<UICollectionViewLayoutAttributes> = []

    /// The header cache built up during the `prepare` function
    private var headerAttributesCache: Array<UICollectionViewLayoutAttributes> = []

    /// A convenient tuple for working with items
    private typealias ItemFrame = (section: Int, flexibleIndex: Int, fixedIndex: Int, scale: Int)

    // MARK: - UICollectionView Layout

    override func prepare() {
        // On rotation, UICollectionView sometimes calls prepare without calling invalidateLayout
        guard itemAttributesCache.isEmpty, headerAttributesCache.isEmpty, let collectionView = collectionView else { return }

        let fixedDimension: CGFloat
        if scrollDirection == .vertical {
            fixedDimension = collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)
            contentWidth = fixedDimension
        } else {
            fixedDimension = collectionView.frame.height - (collectionView.contentInset.top + collectionView.contentInset.bottom)
            contentHeight = fixedDimension
        }

        var additionalSectionSpacing: CGFloat = 0
        let headerFlexibleDimension = (delegate ?? self).headerFlexibleDimension(inCollectionView: collectionView, withLayout: self, fixedDimension: fixedDimension)

        itemFixedDimension = (fixedDimension - (CGFloat(fixedDivisionCount) * itemSpacing) + itemSpacing) / CGFloat(fixedDivisionCount)
        itemFlexibleDimension = (delegate ?? self).itemFlexibleDimension(inCollectionView: collectionView, withLayout: self, fixedDimension: itemFixedDimension)

        for section in 0 ..< collectionView.numberOfSections {
            let itemCount = collectionView.numberOfItems(inSection: section)

            // Calculate header attributes
            if headerFlexibleDimension > 0.0 && itemCount > 0 {
                if headerAttributesCache.count > 0 {
                    additionalSectionSpacing += itemSpacing
                }

                let frame: CGRect
                if scrollDirection == .vertical {
                    frame = CGRect(x: 0, y: additionalSectionSpacing, width: fixedDimension, height: headerFlexibleDimension)
                } else {
                    frame = CGRect(x: additionalSectionSpacing, y: 0, width: headerFlexibleDimension, height: fixedDimension)
                }
                let headerLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: section))
                headerLayoutAttributes.frame = frame

                headerAttributesCache.append(headerLayoutAttributes)
                additionalSectionSpacing += headerFlexibleDimension
            }

            if headerFlexibleDimension > 0.0 || section > 0 {
                additionalSectionSpacing += itemSpacing
            }

            // Calculate item attributes
            let sectionOffset = additionalSectionSpacing
            sectionedItemGrid.append([])

            var flexibleIndex = 0, fixedIndex = 0
            for item in 0 ..< itemCount {
                if fixedIndex >= intFixedDivisionCount {
                    // Reached end of row in .vertical or column in .horizontal
                    fixedIndex = 0
                    flexibleIndex += 1
                }

                let itemIndexPath = IndexPath(item: item, section: section)
                let itemScale = indexableScale(forItemAt: itemIndexPath)
                let intendedFrame = ItemFrame(section, flexibleIndex, fixedIndex, itemScale)

                // Find a place for the item in the grid
                let (itemFrame, didFitInOriginalFrame) = nextAvailableFrame(startingAt: intendedFrame)

                reserveItemGrid(frame: itemFrame)
                let itemAttributes = layoutAttributes(for: itemIndexPath, at: itemFrame, with: sectionOffset)

                itemAttributesCache.append(itemAttributes)

                // Update flexible dimension
                if scrollDirection == .vertical {
                    if itemAttributes.frame.maxY > contentHeight {
                        contentHeight = itemAttributes.frame.maxY
                    }
                    if itemAttributes.frame.maxY > additionalSectionSpacing {
                        additionalSectionSpacing = itemAttributes.frame.maxY
                    }
                } else {
                    // .horizontal
                    if itemAttributes.frame.maxX > contentWidth {
                        contentWidth = itemAttributes.frame.maxX
                    }
                    if itemAttributes.frame.maxX > additionalSectionSpacing {
                        additionalSectionSpacing = itemAttributes.frame.maxX
                    }
                }

                if didFitInOriginalFrame {
                    fixedIndex += 1 + itemFrame.scale
                }
            }
        }
        sectionedItemGrid = [] // Only used during prepare, free up some memory
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let headerAttributes = headerAttributesCache.filter {
            $0.frame.intersects(rect)
        }
        let itemAttributes = itemAttributesCache.filter {
            $0.frame.intersects(rect)
        }

        return headerAttributes + itemAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributesCache.first {
            $0.indexPath == indexPath
        }
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard elementKind == UICollectionView.elementKindSectionHeader else { return nil }

        return headerAttributesCache.first {
            $0.indexPath == indexPath
        }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if scrollDirection == .vertical, let oldWidth = collectionView?.bounds.width {
            return oldWidth != newBounds.width
        } else if scrollDirection == .horizontal, let oldHeight = collectionView?.bounds.height {
            return oldHeight != newBounds.height
        }

        return false
    }

    override func invalidateLayout() {
        super.invalidateLayout()

        itemAttributesCache = []
        headerAttributesCache = []
        contentWidth = 0
        contentHeight = 0
    }

    // MARK: - Private

    private func indexableScale(forItemAt indexPath: IndexPath) -> Int {
        var itemScale = (delegate ?? self).scaleForItem(inCollectionView: collectionView!, withLayout: self, atIndexPath: indexPath)
        if itemScale > fixedDivisionCount {
            itemScale = fixedDivisionCount
        }
        return Int(itemScale - 1) // Using with indices, want 0-based
    }

    private func nextAvailableFrame(startingAt originalFrame: ItemFrame) -> (frame: ItemFrame, fitInOriginalFrame: Bool) {
        var flexibleIndex = originalFrame.flexibleIndex, fixedIndex = originalFrame.fixedIndex
        var newFrame = ItemFrame(originalFrame.section, flexibleIndex, fixedIndex, originalFrame.scale)
        while !isSpaceAvailable(for: newFrame) {
            fixedIndex += 1

            // Reached end of fixedIndex, restart on next flexibleIndex
            if fixedIndex + originalFrame.scale >= intFixedDivisionCount {
                fixedIndex = 0
                flexibleIndex += 1
            }

            newFrame = ItemFrame(originalFrame.section, flexibleIndex, fixedIndex, originalFrame.scale)
        }

        // Fits iff we never had to walk the grid to find a position
        return (newFrame, flexibleIndex == originalFrame.flexibleIndex && fixedIndex == originalFrame.fixedIndex)
    }

    /// Checks the grid from the origin to the origin + scale for occupied blocks
    private func isSpaceAvailable(for frame: ItemFrame) -> Bool {
        for flexibleIndex in frame.flexibleIndex ... frame.flexibleIndex + frame.scale {
            // Ensure we won't go off the end of the array
            while sectionedItemGrid[frame.section].count <= flexibleIndex {
                sectionedItemGrid[frame.section].append(Array(repeating: false, count: intFixedDivisionCount))
            }

            for fixedIndex in frame.fixedIndex ... frame.fixedIndex + frame.scale {
                if fixedIndex >= intFixedDivisionCount || sectionedItemGrid[frame.section][flexibleIndex][fixedIndex] {
                    return false
                }
            }
        }

        return true
    }

    private func reserveItemGrid(frame: ItemFrame) {
        for flexibleIndex in frame.flexibleIndex ... frame.flexibleIndex + frame.scale {
            for fixedIndex in frame.fixedIndex ... frame.fixedIndex + frame.scale {
                sectionedItemGrid[frame.section][flexibleIndex][fixedIndex] = true
            }
        }
    }

    private func layoutAttributes(for indexPath: IndexPath, at itemFrame: ItemFrame, with sectionOffset: CGFloat) -> UICollectionViewLayoutAttributes {
        let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        let fixedIndexOffset = CGFloat(itemFrame.fixedIndex) * (itemSpacing + itemFixedDimension)
        let longitudinalOffset = CGFloat(itemFrame.flexibleIndex) * (itemSpacing + itemFlexibleDimension) + sectionOffset
        let itemScaledTransverseDimension = itemFixedDimension + (CGFloat(itemFrame.scale) * (itemSpacing + itemFixedDimension))
        let itemScaledLongitudinalDimension = itemFlexibleDimension + (CGFloat(itemFrame.scale) * (itemSpacing + itemFlexibleDimension))

        if scrollDirection == .vertical {
            layoutAttributes.frame = CGRect(x: fixedIndexOffset, y: longitudinalOffset, width: itemScaledTransverseDimension, height: itemScaledLongitudinalDimension)
        } else {
            layoutAttributes.frame = CGRect(x: longitudinalOffset, y: fixedIndexOffset, width: itemScaledLongitudinalDimension, height: itemScaledTransverseDimension)
        }

        return layoutAttributes
    }
}
