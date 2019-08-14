//
//  SchedulePostTime.swift
//  Selfin
//
//  Created by cis on 17/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class SchedulePostTime: UIView {
    @IBOutlet var btnOk: UIButton!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var labelCurrentTime: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var viewBackground: UIView!
    let gradient: CAGradientLayer = CAGradientLayer()
    var scheduleDate: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Configure UI
        gradient.frame = UIScreen.main.bounds
        gradient.startPoint = CGPoint(x: 0.7, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0.8)
        gradient.colors = [UIColor(red: 240 / 255, green: 48 / 255, blue: 193 / 255, alpha: 1), UIColor(red: 146 / 255, green: 116 / 255, blue: 221 / 255, alpha: 1)].map { $0.cgColor }
        self.viewBackground.layer.insertSublayer(gradient, at: 0)
        
        //Set datePicker
        datePicker.minimumDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        labelCurrentTime.text = dateFormatter.string(from: Date())
        
        //add gesture
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(removeSchedular))
        self.viewBackground.addGestureRecognizer(tap)
    }

    
    @IBAction func actionScheduleTime(_ sender: UIButton) {
        if sender == btnOk {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let stringScheduleTime = dateFormatter.string(from: datePicker.date)
            self.scheduleDate?(stringScheduleTime)
             self.removeFromSuperview()
            return
        }
        self.removeFromSuperview()
    }
    
    @objc func removeSchedular() {
         self.removeFromSuperview()
    }
}
