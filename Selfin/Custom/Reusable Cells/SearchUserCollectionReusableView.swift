//
//  SearchUserCollectionReusableView.swift
//  Selfin
//
//  Created by cis on 20/11/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class SearchUserCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet var textfieldSearch: UITextField!
    var performSearch:((_ searchstr : String) ->())?
    var timer: Timer?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        textfieldSearch.delegate = self
        textfieldSearch.setLeftPadding(8)
    }
    
    //MARK:- UI Action
    @IBAction func actionPerformSearch(_ sender: Any) {
        timer?.invalidate()
        performSearch?(textfieldSearch.text ?? "")
    }
}

extension SearchUserCollectionReusableView : UITextFieldDelegate {
    @objc func searchUser(timer: Timer) {
        if timer.userInfo as! String == "" {
            timer.invalidate()
            performSearch?("")
        } else {
            performSearch?(timer.userInfo as! String)
        }
    }
    
    @available(iOS 2.0, *)
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var searchString = String()
        if string != "" {
            searchString = textField.text! + string
        } else {
            searchString = String(textField.text!.dropLast())
        }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(searchUser(timer:)), userInfo: searchString, repeats: false)
        return true
    }
    
    @available(iOS 2.0, *)
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    @available(iOS 2.0, *)
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        textField.resignFirstResponder()
        timer?.invalidate()
        performSearch?("")
        return false
    }
}
