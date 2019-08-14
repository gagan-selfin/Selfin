//
//  TagHeaderView.swift
//  Selfin
//
//  Created by cis on 14/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class TagHeaderView: UIView {
    @IBOutlet var textfiled: UITextField!
    @IBOutlet var collectionView: TagUsersCollectionview!
    @IBOutlet var heightConstrait: NSLayoutConstraint!
    var stringSearch = String()
    var timer: Timer?
    var performSearch:((_ searchstr : String) ->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        heightConstrait.constant = CGFloat(SearchHeaderSize.initailCollectionHeight.rawValue)
        textfiled.delegate = self
        textfiled.setLeftPadding(5)
    }
    
    @IBAction func actionSearch(_ sender: Any) {
    }
    
    func didSelectCollection(user: [FollowingFollowersResponse.User]) {
        collectionView.display(user: user)
    }
}

extension TagHeaderView: UITextFieldDelegate {
    @objc func searchUser(timer: Timer) {
        if timer.userInfo as! String == "" {
            timer.invalidate()
            performSearch?(stringSearch)
        } else {
            performSearch?(stringSearch)
        }
    }
    
    @available(iOS 2.0, *)
    public func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        if string != "" {
            stringSearch = textField.text! + string
        } else {
            stringSearch = String(textField.text!.dropLast())
        }
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(searchUser(timer:)), userInfo: stringSearch, repeats: false)
        return true
    }
    
    @available(iOS 2.0, *)
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    @available(iOS 2.0, *)
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        timer?.invalidate()
        textField.text = ""
        textField.resignFirstResponder()
        performSearch?("")
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.tintColor = UIColor.lightGray
    }
}
