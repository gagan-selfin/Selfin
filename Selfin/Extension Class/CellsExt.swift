//
//  CellsExt.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/7/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
extension UITableView {
    private struct AssociatedObjectKey {
        static var registeredCells = "registeredCells"
    }

    private var registeredCells: Set<String> {
        get {
            if objc_getAssociatedObject(self, &AssociatedObjectKey.registeredCells) as? Set<String> == nil {
                self.registeredCells = Set<String>()
            }
            return objc_getAssociatedObject(self, &AssociatedObjectKey.registeredCells) as! Set<String>
        }

        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedObjectKey.registeredCells, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func registerReusable<T: UITableViewCell>(_: T.Type) where T: Reusable {
        let bundle = Bundle(for: T.self)

        if bundle.path(forResource: T.reuseIndentifier, ofType: "nib") != nil {
            let nib = UINib(nibName: T.reuseIndentifier, bundle: bundle)
            register(nib, forCellReuseIdentifier: T.reuseIndentifier)
        } else {
            register(T.self, forCellReuseIdentifier: T.reuseIndentifier)
        }
    }

    func dequeueReusable<T: UITableViewCell>(_ indexPath: IndexPath) -> T where T: Reusable {
        if registeredCells.contains(T.reuseIndentifier) == false {
            registeredCells.insert(T.reuseIndentifier)
            registerReusable(T.self)
        }
        guard let reuseCell = self.dequeueReusableCell(withIdentifier: T.reuseIndentifier, for: indexPath) as? T else { fatalError("Unable to dequeue cell with identifier \(T.reuseIndentifier)") }
        return reuseCell
    }
}

extension UICollectionView {
    private struct AssociatedObjectKey {
        static var registeredCells = "registeredCells"
    }

    private var registeredCells: Set<String> {
        get {
            if objc_getAssociatedObject(self, &AssociatedObjectKey.registeredCells) as? Set<String> == nil {
                self.registeredCells = Set<String>()
            }
            return objc_getAssociatedObject(self, &AssociatedObjectKey.registeredCells) as! Set<String>
        }

        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedObjectKey.registeredCells, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func registerReusable<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
        let bundle = Bundle(for: T.self)

        if bundle.path(forResource: T.reuseIndentifier, ofType: "nib") != nil {
            let nib = UINib(nibName: T.reuseIndentifier, bundle: bundle)
            register(nib, forCellWithReuseIdentifier: T.reuseIndentifier)

        } else {
            register(T.self, forCellWithReuseIdentifier: T.reuseIndentifier)
        }
    }

    func dequeueReusable<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T where T: Reusable {
        if registeredCells.contains(T.reuseIndentifier) == false {
            registeredCells.insert(T.reuseIndentifier)
            registerReusable(T.self)
        }
        guard let reuseCell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIndentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell with identifier \(T.reuseIndentifier)")
        }
        return reuseCell
    }
}
