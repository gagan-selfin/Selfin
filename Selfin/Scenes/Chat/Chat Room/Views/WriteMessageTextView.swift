//
//  WriteMessageTextView.swift
//  Selfin
//
//  Created by cis on 22/11/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class WriteMessageTextView: UITextView, UITextViewDelegate {
    fileprivate let placeholderColor = UIColor.lightGray
    fileprivate let messageColor =  UIColor(displayP3Red: 24/255, green: 19/255, blue: 67/255, alpha: 1)
    var viewHeight: NSLayoutConstraint!
    var placeholderText = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        showsVerticalScrollIndicator = true
    }
        
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.tintColor = messageColor
        if textView.text == placeholderText{textView.text = ""}//remove placeholder
    }
    
    @available(iOS 2.0, *)
    public func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        if newSize.height < 120 {
            textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            if textView.frame.size.height > viewHeight.constant && textView.frame.size.height < 120 {
                viewHeight.constant = textView.frame.size.height
            }
        } else {
            textView.isScrollEnabled = true
        }
    }
    
    @available(iOS 2.0, *)
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"  {//To display place holder
            if textView.text == "" {textView.text = placeholderText;textView.tintColor = placeholderColor}
            textView.resignFirstResponder()
            return false
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 300
        //return true
    }
}

