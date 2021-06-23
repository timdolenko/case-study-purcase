//
//  RoundedRectButton.swift
//  Toast Delivery
//

import UIKit

class RoundedRectButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        updateBackgroundColor()
        layer.cornerRadius = 8
        setTitleColor(.white, for: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }

    override var isHighlighted: Bool {
        didSet {
            updateBackgroundColor()
        }
    }

    private func updateBackgroundColor() {
        if isHighlighted {
            backgroundColor = UIColor(red: 0.10, green: 0.21, blue: 0.56, alpha: 1.00)
        } else {
            backgroundColor = UIColor(red: 0.19, green: 0.39, blue: 0.91, alpha: 1.00)
        }
    }

}
