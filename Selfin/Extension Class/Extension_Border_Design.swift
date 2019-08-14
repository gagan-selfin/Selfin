//
//  Extension_Border_Design.swift
//  MY ACTIPAL
//
//  Created by cis on 1/4/18.
//  Copyright © 2017 cis. All rights reserved.

import Foundation
import SVProgressHUD
import UIKit

let viewOverlay = UIView()

extension UIViewController {
    func getCountryPhonceCode(_ country: String) -> String {
        var countryDictionary = ["AF": "93",
                                 "AL": "355",
                                 "DZ": "213",
                                 "AS": "1",
                                 "AD": "376",
                                 "AO": "244",
                                 "AI": "1",
                                 "AG": "1",
                                 "AR": "54",
                                 "AM": "374",
                                 "AW": "297",
                                 "AU": "61",
                                 "AT": "43",
                                 "AZ": "994",
                                 "BS": "1",
                                 "BH": "973",
                                 "BD": "880",
                                 "BB": "1",
                                 "BY": "375",
                                 "BE": "32",
                                 "BZ": "501",
                                 "BJ": "229",
                                 "BM": "1",
                                 "BT": "975",
                                 "BA": "387",
                                 "BW": "267",
                                 "BR": "55",
                                 "IO": "246",
                                 "BG": "359",
                                 "BF": "226",
                                 "BI": "257",
                                 "KH": "855",
                                 "CM": "237",
                                 "CA": "1",
                                 "CV": "238",
                                 "KY": "345",
                                 "CF": "236",
                                 "TD": "235",
                                 "CL": "56",
                                 "CN": "86",
                                 "CX": "61",
                                 "CO": "57",
                                 "KM": "269",
                                 "CG": "242",
                                 "CK": "682",
                                 "CR": "506",
                                 "HR": "385",
                                 "CU": "53",
                                 "CY": "537",
                                 "CZ": "420",
                                 "DK": "45",
                                 "DJ": "253",
                                 "DM": "1",
                                 "DO": "1",
                                 "EC": "593",
                                 "EG": "20",
                                 "SV": "503",
                                 "GQ": "240",
                                 "ER": "291",
                                 "EE": "372",
                                 "ET": "251",
                                 "FO": "298",
                                 "FJ": "679",
                                 "FI": "358",
                                 "FR": "33",
                                 "GF": "594",
                                 "PF": "689",
                                 "GA": "241",
                                 "GM": "220",
                                 "GE": "995",
                                 "DE": "49",
                                 "GH": "233",
                                 "GI": "350",
                                 "GR": "30",
                                 "GL": "299",
                                 "GD": "1",
                                 "GP": "590",
                                 "GU": "1",
                                 "GT": "502",
                                 "GN": "224",
                                 "GW": "245",
                                 "GY": "595",
                                 "HT": "509",
                                 "HN": "504",
                                 "HU": "36",
                                 "IS": "354",
                                 "IN": "91",
                                 "ID": "62",
                                 "IQ": "964",
                                 "IE": "353",
                                 "IL": "972",
                                 "IT": "39",
                                 "JM": "1",
                                 "JP": "81",
                                 "JO": "962",
                                 "KZ": "77",
                                 "KE": "254",
                                 "KI": "686",
                                 "KW": "965",
                                 "KG": "996",
                                 "LV": "371",
                                 "LB": "961",
                                 "LS": "266",
                                 "LR": "231",
                                 "LI": "423",
                                 "LT": "370",
                                 "LU": "352",
                                 "MG": "261",
                                 "MW": "265",
                                 "MY": "60",
                                 "MV": "960",
                                 "ML": "223",
                                 "MT": "356",
                                 "MH": "692",
                                 "MQ": "596",
                                 "MR": "222",
                                 "MU": "230",
                                 "YT": "262",
                                 "MX": "52",
                                 "MC": "377",
                                 "MN": "976",
                                 "ME": "382",
                                 "MS": "1",
                                 "MA": "212",
                                 "MM": "95",
                                 "NA": "264",
                                 "NR": "674",
                                 "NP": "977",
                                 "NL": "31",
                                 "AN": "599",
                                 "NC": "687",
                                 "NZ": "64",
                                 "NI": "505",
                                 "NE": "227",
                                 "NG": "234",
                                 "NU": "683",
                                 "NF": "672",
                                 "MP": "1",
                                 "NO": "47",
                                 "OM": "968",
                                 "PK": "92",
                                 "PW": "680",
                                 "PA": "507",
                                 "PG": "675",
                                 "PY": "595",
                                 "PE": "51",
                                 "PH": "63",
                                 "PL": "48",
                                 "PT": "351",
                                 "PR": "1",
                                 "QA": "974",
                                 "RO": "40",
                                 "RW": "250",
                                 "WS": "685",
                                 "SM": "378",
                                 "SA": "966",
                                 "SN": "221",
                                 "RS": "381",
                                 "SC": "248",
                                 "SL": "232",
                                 "SG": "65",
                                 "SK": "421",
                                 "SI": "386",
                                 "SB": "677",
                                 "ZA": "27",
                                 "GS": "500",
                                 "ES": "34",
                                 "LK": "94",
                                 "SD": "249",
                                 "SR": "597",
                                 "SZ": "268",
                                 "SE": "46",
                                 "CH": "41",
                                 "TJ": "992",
                                 "TH": "66",
                                 "TG": "228",
                                 "TK": "690",
                                 "TO": "676",
                                 "TT": "1",
                                 "TN": "216",
                                 "TR": "90",
                                 "TM": "993",
                                 "TC": "1",
                                 "TV": "688",
                                 "UG": "256",
                                 "UA": "380",
                                 "AE": "971",
                                 "GB": "44",
                                 "US": "1",
                                 "UY": "598",
                                 "UZ": "998",
                                 "VU": "678",
                                 "WF": "681",
                                 "YE": "967",
                                 "ZM": "260",
                                 "ZW": "263",
                                 "BO": "591",
                                 "BN": "673",
                                 "CC": "61",
                                 "CD": "243",
                                 "CI": "225",
                                 "FK": "500",
                                 "GG": "44",
                                 "VA": "379",
                                 "HK": "852",
                                 "IR": "98",
                                 "IM": "44",
                                 "JE": "44",
                                 "KP": "850",
                                 "KR": "82",
                                 "LA": "856",
                                 "LY": "218",
                                 "MO": "853",
                                 "MK": "389",
                                 "FM": "691",
                                 "MD": "373",
                                 "MZ": "258",
                                 "PS": "970",
                                 "PN": "872",
                                 "RE": "262",
                                 "RU": "7",
                                 "BL": "590",
                                 "SH": "290",
                                 "KN": "1",
                                 "LC": "1",
                                 "MF": "590",
                                 "PM": "508",
                                 "VC": "1",
                                 "ST": "239",
                                 "SO": "252",
                                 "SJ": "47",
                                 "SY": "963",
                                 "TW": "886",
                                 "TZ": "255",
                                 "TL": "670",
                                 "VE": "58",
                                 "VN": "84",
                                 "VG": "284",
                                 "VI": "340"]
        if countryDictionary[country] != nil {
            return countryDictionary[country]!
        } else {
            return ""
        }
    }

    func showLoader() {
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.purple)
    }

    func hideLoader() {
        SVProgressHUD.dismiss()
    }

    func showAlert(str: String) {
        let alert = UIAlertController(title: Constants.alertTitle.rawValue, message: str, preferredStyle: UIAlertController.Style.alert)

        let ok = UIAlertAction(title: "Ok", style: .default) { (_: UIAlertAction!) -> Void in

            self.dismiss(animated: true, completion: nil)
        }

        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

    func showPermissionAlert(str: String, permitted: @escaping () -> Void) {
        let alert = UIAlertController(title: Constants.alertTitle.rawValue, message: str, preferredStyle: UIAlertController.Style.alert)

        let ok = UIAlertAction(title: "Yes", style: .default) { _ in
            permitted()
            self.dismiss(animated: true, completion: nil)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }

        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    func showAlert(str: String, perform: @escaping () -> Void) {
        let alert = UIAlertController(title: Constants.alertTitle.rawValue, message: str, preferredStyle: UIAlertController.Style.alert)

        let ok = UIAlertAction(title: "Ok", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
             perform()
            //self.dismiss(animated: true, completion: {
            
            //})
        }

        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func isPortraitMode() -> Bool {
        switch UIApplication.shared.statusBarOrientation {
        case .portrait,.portraitUpsideDown:
            return true
        default:
            return true
        }
    }
    
    func isDevicePortraitMode()-> Bool {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            return false
        } else if UIDevice.current.orientation.isPortrait {
            print("Portrait")
            return true
        }
        return true
    }
}

extension UIView {
    func applyGradient(colours: [UIColor]) {
        applyGradient(colours: colours, locations: [0])
    }

    func applyGradient(colours: [UIColor], locations: [NSNumber]?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.insertSublayer(gradient, at: 0)
    }
}

extension UIImage {
    func updateImageOrientionUpSide() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        }
        UIGraphicsEndImageContext()
        return self
    }
}


extension UITextField {
    func setLeftPadding(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

extension UITableViewCell {
    func round(corners: UIRectCorner, withRadius radius: CGFloat) {
        let mask = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.frame = bounds
        shape.path = mask.cgPath
        layer.mask = shape
    }
}

extension UICollectionViewCell {
    func round(corners: UIRectCorner, withRadius radius: CGFloat) {
        let mask = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.frame = bounds
        shape.path = mask.cgPath
        layer.mask = shape
    }
}

extension UICollectionView {
    
    func setEmptyMessage(_ message: String, image: UIImage, headerViewHeight : CGFloat) {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let imageView = UIImageView.init(frame: CGRect.init(x: self.bounds.size.width/2 - 40, y: headerViewHeight + 20, width: 80, height: 80))
        
        imageView.image = image
        
        let messageLabel = UILabel(frame: CGRect(x: 10, y: headerViewHeight + 100, width: self.bounds.size.width - 20, height: self.bounds.size.width - headerViewHeight))
        
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "SF-Pro-Text-Medium", size: 24)
        
        view.addSubview(imageView)
        view.addSubview(messageLabel)
        self.backgroundView = view
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

struct AppUtility {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation: UIInterfaceOrientation) {
        lockOrientation(orientation)

        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
}

extension UIBarButtonItem {
    convenience init(badge: String?, button: UIButton, target: AnyObject?, action: Selector) {
        button.addTarget(target, action: action, for: .touchUpInside)
        button.sizeToFit()
        
        let badgeLabel = UILabel()
        badgeLabel.text = badge
        button.addSubview(badgeLabel)
        button.addConstraint(NSLayoutConstraint(item: badgeLabel, attribute: .top, relatedBy: .equal, toItem: button, attribute: .top, multiplier: 1, constant: 0))
        button.addConstraint(NSLayoutConstraint(item: badgeLabel, attribute: .centerX, relatedBy: .equal, toItem: button, attribute: .trailing, multiplier: 1, constant: 0))
        if nil == badge {
            badgeLabel.isHidden = true
        }
        badgeLabel.tag = UIBarButtonItem.badgeTag
        
        self.init(customView: button)
    }
    
    convenience init(badge: String?, image: UIImage, target: AnyObject?, action: Selector) {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        button.setBackgroundImage(image, for: .normal)
        
        self.init(badge: badge, button: button, target: target, action: action)
    }
    
    convenience init(badge: String?, title: String, target: AnyObject?, action: Selector) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        self.init(badge: badge, button: button, target: target, action: action)
    }
    
    var badgeLabel: UILabel? {
        return customView?.viewWithTag(UIBarButtonItem.badgeTag) as? UILabel
    }
    
    var badgedButton: UIButton? {
        return customView as? UIButton
    }
    
    var badgeString: String? {
        get { return badgeLabel?.text?.trimmingCharacters(in: .whitespaces) }
        set {
            if let badgeLabel = badgeLabel {
                badgeLabel.text = nil == newValue ? nil : " \(newValue!) "
                badgeLabel.sizeToFit()
                badgeLabel.isHidden = nil == newValue
            }
        }
    }
    
    var badgedTitle: String? {
        get { return badgedButton?.title(for: .normal) }
        set { badgedButton?.setTitle(newValue, for: .normal); badgedButton?.sizeToFit() }
    }
    
    private static let badgeTag = 7373
}
