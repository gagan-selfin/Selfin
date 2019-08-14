//
//  SearchHeaderCollectionReusableView.swift
//  Selfin
//
//  Created by cis on 13/11/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class SearchHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet var most: UIButton!
    @IBOutlet var people: UIButton!
    @IBOutlet var tags: UIButton!
    @IBOutlet var location: UIButton!
    let selectedColor = UIColor(displayP3Red: 249/255, green: 64/255, blue: 148/255, alpha: 1)
    @IBOutlet var textfiledSearch: UITextField!
    var timer: Timer?
    var onStyleSelected:((_ style:searchCollectionStyle) ->())?
    var performSearchOverSelectedStyle:((_ style:searchCollectionStyle, _ searchstr : String) ->())?
    fileprivate var currentStyle : searchCollectionStyle = .most
    weak var controller:SearchCollectionDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        textfiledSearch.delegate = self
        textfiledSearch.setLeftPadding(5)
    }

    //MARK:- UIActions
    @IBAction func actionSearchStyle(_ sender: UIButton) {
        textfiledSearch.text = ""// clear textfield on tab change
        [most,people,tags,location].forEach {
            $0?.setTitleColor(UIColor(displayP3Red: 24/255, green: 19/255, blue: 67/255, alpha: 1), for: .normal)
            $0?.backgroundColor = .clear
        }
        switch sender {
        case most:
            onStyleSelected?(.most)
            most.setTitleColor(.white, for: .normal)
            most.backgroundColor = selectedColor
            currentStyle = .most
        case people:
            self.onStyleSelected?(.people)
             people.setTitleColor(.white, for: .normal)
             people.backgroundColor = selectedColor
            currentStyle = .people
        case tags:
            onStyleSelected?(.tag)
            tags.setTitleColor(.white, for: .normal)
            tags.backgroundColor = selectedColor
            currentStyle = .tag
        case location:
             self.onStyleSelected?(.location)
             location.setTitleColor(.white, for: .normal)
             location.backgroundColor = selectedColor
              currentStyle = .location
        default:
            break
        }
    }
    
    @IBAction func actionSearch(_ sender: Any) {
        timer?.invalidate()
        performSearchOverSelectedStyle?(currentStyle,textfiledSearch.text ?? "")
    }
}

extension SearchHeaderCollectionReusableView: UITextFieldDelegate {
    
    @objc func searchUser(timer: Timer) {
        print(timer.userInfo ?? "ty")
        
        if timer.userInfo as! String == "" {
            timer.invalidate()
            performSearchOverSelectedStyle?(currentStyle,"")
        } else {
            performSearchOverSelectedStyle?(currentStyle,timer.userInfo as! String)
        }
    }
    
    @available(iOS 2.0, *)
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var searchString = String()
        if string != "" {
            searchString = textField.text! + string
        } else {
            print(string)
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
        timer?.invalidate()
        textField.text = ""
        textField.resignFirstResponder()
        performSearchOverSelectedStyle?(currentStyle,"")
        return false
    }
}
