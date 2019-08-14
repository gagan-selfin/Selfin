//
//  CustomSegmentedControl.swift
//  Selfin
//
//  Created by Kenish on 2018-07-20.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
@IBDesignable

class CustomSegmentedControl: UIControl {
    var buttons = [UIButton]()
    var selector: UIView!

    var indexPos: ((Int) -> Void)?

    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable
    var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable
    var commaSeparatedButtonTitles: String = "" {
        didSet {
            updateView()
        }
    }

    // Default Color
    @IBInspectable
    var textColor: UIColor = .black {
        didSet {
            updateView()
        }
    }

    // Selector Color
    @IBInspectable
    var selectorColor: UIColor = .red {
        didSet {
            updateView()
        }
    }

    @IBInspectable
    var selectorTextColor: UIColor = .blue {
        didSet {
            updateView()
        }
    }

    func updateView() {
        buttons.removeAll()

        subviews.forEach { $0.removeFromSuperview() }

        let buttonTitles = commaSeparatedButtonTitles.components(separatedBy: ",")

        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.font = UIFont(name: "Helvetica", size: 11)
            button.contentHorizontalAlignment = .center

            // Button action
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)

            buttons.append(button)
        }

        let selectorWidth = frame.width / CGFloat(buttonTitles.count)
        selector = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: frame.height))
        selector.layer.cornerRadius = frame.height / 2
        selector.backgroundColor = selectorColor

        // Adding shadow (needs tweaking)
        selector.layer.shadowColor = UIColor(red: 228.0 / 255.0, green: 35.0 / 255.0, blue: 174.0 / 255.0, alpha: 1.0).cgColor
        selector.layer.shadowOpacity = 0.4
        selector.layer.shadowOffset = CGSize.zero
        selector.layer.shadowRadius = 4

        addSubview(selector)

        buttons[0].setTitleColor(selectorTextColor, for: .normal)

        let sv = UIStackView(arrangedSubviews: buttons)
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillEqually
        addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sv.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        sv.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        sv.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    // MARK: SUGGESTION by Marlon, draw rect is expensive, should consider update

    // the views on a different life cycle method.
    override func draw(_: CGRect) {
        layer.cornerRadius = frame.height / 2
        updateView()
    }

    // Button function
    @objc func buttonTapped(button: UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)

            if btn == button {
                let selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.3, animations: {
                    self.selector.frame.origin.x = selectorStartPosition
                })

                btn.setTitleColor(selectorTextColor, for: .normal)
                indexPos!(buttonIndex)
            }
        }
        // Actions
        sendActions(for: .valueChanged)
    }

    // End of class
}
