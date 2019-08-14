//
//  AttrTextView.swift
//  Norae
//
//  Created by Eliot Han on 1/3/17.
//  Copyright © 2017 Eliot Han. All rights reserved.
//

import UIKit

enum wordType{
    case hashtag
    case mention
    case username
}

//A custom text view that allows hashtags and @ symbols to be separated from the rest of the text and triggers actions upon selection

class AttrTextView: UITextView {
    var textString: NSString?
    var attrString: NSMutableAttributedString?
    var callBack: ((String, wordType) -> Void)?
    let hashtagColor = UIColor(displayP3Red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
    let usernameColor = UIColor(displayP3Red: 24/255, green: 19/255, blue: 67/255, alpha: 1)
    var textFont : UIFont!
    var hashtag = false
    
    public func setText(text: String, type : wordType, andCallBack callBack: @escaping (String, wordType) -> Void) {
        textFont = UIFont.init(name: "HelveticaNeue", size: 14)
        self.callBack = callBack
        self.attrString = NSMutableAttributedString(string: text + " ")
        self.textString = NSString(string: text)
        
        // Set initial font attributes for our string
        attrString?.addAttribute(NSAttributedString.Key.font, value: textFont, range: NSRange(location: 0, length: (textString?.length)!))
        attrString?.addAttribute(NSAttributedString.Key.foregroundColor, value: usernameColor, range: NSRange(location: 0, length: (textString?.length)!))
        
        // Call a custom set Hashtag and Mention Attributes Function
        if type == .username {
            setAttrWithNameUsername(attrName: "Username", wordPrefix: "≠", color: usernameColor, text: text, font: UIFont.init(name: "HelveticaNeue-Bold", size: 14)!)
        }else {
            setAttrWithName(attrName: "Hashtag", wordPrefix: "#", color: hashtagColor, text: text, font: textFont)
            setAttrWithName(attrName: "Mention", wordPrefix: "@", color: hashtagColor, text: text, font: textFont)
        }
        
        // Add tap gesture that calls a function tapRecognized when tapped
        let tapper = UITapGestureRecognizer(target: self, action: #selector(self.tapRecognized(tapGesture:)))
        addGestureRecognizer(tapper)
    }
    
    private func setAttrWithName(attrName: String, wordPrefix: String, color: UIColor, text: String, font: UIFont) {
        //Words can be separated by either a space or a line break
        let charSet = CharacterSet(charactersIn: " \n")
        let words = text.components(separatedBy: charSet)
       
        //Filter to check for the # or @ prefix
        for word in words.filter({$0.hasPrefix(wordPrefix)}) {
            let range = textString!.range(of: word)
            attrString?.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
            attrString?.addAttribute(NSAttributedString.Key(rawValue: attrName), value: 1, range: range)
            attrString?.addAttribute(NSAttributedString.Key(rawValue: "Clickable"), value: 1, range: range)
            attrString?.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        }
        self.attributedText = attrString
    }
    
    private func setAttrWithNameUsername(attrName: String, wordPrefix: String, color: UIColor, text: String, font: UIFont) {
        //Words can be separated by either a space or a line break
        let charSet = CharacterSet(charactersIn: " \n")
        let words = text.components(separatedBy: charSet)
        var str : String = attrString?.string ?? ""
        var mstr: NSMutableAttributedString?
        
        for word in words.filter({$0.hasPrefix(wordPrefix)}) {str = str.replacingOccurrences(of: word, with: word.dropFirst())}
        
        mstr = NSMutableAttributedString.init(string: str)
        mstr?.addAttribute(NSAttributedString.Key.font, value: textFont, range: NSRange(location: 0, length: (str as NSString).length))
        mstr?.addAttribute(NSAttributedString.Key.foregroundColor, value: usernameColor, range: NSRange(location: 0, length: (str as NSString).length))
        
        //Filter to check for the # or @ prefix
        for word in words.filter({$0.hasPrefix(wordPrefix)}) {
            let range = (str as NSString).range(of: String(word.dropFirst()))
            mstr?.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
            mstr?.addAttribute(NSAttributedString.Key(rawValue: attrName), value: 1, range: range)
            mstr?.addAttribute(NSAttributedString.Key(rawValue: "Clickable"), value: 1, range: range)
            mstr?.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        }
        
        self.attributedText = mstr
    }
    
    @objc func tapRecognized(tapGesture: UITapGestureRecognizer) {
        var wordString: String?         // The String value of the word to pass into callback function
        var char: NSAttributedString!   //The character the user clicks on. It is non optional because if the user clicks on nothing, char will be a space or " "
        var word: NSAttributedString?   //The word the user clicks on
        var isHashtag: Bool?
        var isAtMention: Bool?
        var isAtUsername: Bool?
        
        // Gets the range of the character at the place the user taps
        let point = tapGesture.location(in: self)
        let charPosition = closestPosition(to: point)
        let charRange = tokenizer.rangeEnclosingPosition(charPosition!, with: .character, inDirection: UITextDirection(rawValue: 1))
        
        //Checks if the user has tapped on a character.
        if charRange != nil {
            let location = offset(from: beginningOfDocument, to: charRange!.start)
            let length = offset(from: charRange!.start, to: charRange!.end)
            let attrRange = NSMakeRange(location, length)
            char = attributedText.attributedSubstring(from: attrRange)
            
            //If the user has not clicked on anything, exit the function
            if char.string == " "{
                print("User clicked on nothing")
                return
            }
            
            let range : NSRange = NSMakeRange(0, char!.length)
            
            // Checks the character's attribute, if any
            isHashtag = (char)?.attribute(NSAttributedString.Key(rawValue: "Hashtag"), at: 0, longestEffectiveRange: nil, in: range) as? Bool
            
            isAtMention = (char)?.attribute(NSAttributedString.Key(rawValue: "Mention"), at: 0, longestEffectiveRange: nil, in: range) as? Bool
            
            isAtUsername = (char)?.attribute(NSAttributedString.Key(rawValue: "Username"), at: 0, longestEffectiveRange: nil, in: range) as? Bool
        }
        
        // Gets the range of the word at the place user taps
        let wordRange = tokenizer.rangeEnclosingPosition(charPosition!, with: .word, inDirection: UITextDirection(rawValue: 1))
        
        /*
        Check if wordRange is nil or not. The wordRange is nil if:
         1. The User clicks on the "#" or "@"
         2. The User has not clicked on anything. We already checked whether or not the user clicks on nothing so 1 is the only possibility
        */
        if wordRange != nil{
            // Get the word. This will not work if the char is "#" or "@" ie, if the user clicked on the # or @ in front of the word
            let wordLocation = offset(from: beginningOfDocument, to: wordRange!.start)
            let wordLength = offset(from: wordRange!.start, to: wordRange!.end)
            let wordAttrRange = NSMakeRange(wordLocation, wordLength)
            word = attributedText.attributedSubstring(from: wordAttrRange)
            wordString = word!.string
        }else{
            /*
            Because the user has clicked on the @ or # in front of the word, word will be nil as
            tokenizer.rangeEnclosingPosition(charPosition!, with: .word, inDirection: 1) does not work with special characters.
            What I am doing here is modifying the x position of the point the user taps the screen. Moving it to the right by about 12 points will move the point where we want to detect for a word, ie to the right of the # or @ symbol and onto the word's text
            */
            var modifiedPoint = point
            modifiedPoint.x += 12
            let modifiedPosition = closestPosition(to: modifiedPoint)
            let modifedWordRange = tokenizer.rangeEnclosingPosition(modifiedPosition!, with: .word, inDirection: UITextDirection(rawValue: 1))
            if modifedWordRange != nil{
                let wordLocation = offset(from: beginningOfDocument, to: modifedWordRange!.start)
                let wordLength = offset(from: modifedWordRange!.start, to: modifedWordRange!.end)
                let wordAttrRange = NSMakeRange(wordLocation, wordLength)
                word = attributedText.attributedSubstring(from: wordAttrRange)
                wordString = word!.string
            }
        }
        
        if let stringToPass = wordString {
            // Runs callback function if word is a Hashtag or Mention
            if isHashtag != nil && callBack != nil {
                callBack!(stringToPass, wordType.hashtag)
            } else if isAtMention != nil && callBack != nil {
                callBack!(stringToPass, wordType.mention)
            }else if isAtUsername != nil && callBack != nil {
                callBack!(stringToPass, wordType.username)
            }
        }
    }
}

