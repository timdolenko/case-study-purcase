//
//  ToastCell.swift
//  Toast Delivery
//

import UIKit

class ToastCell: UICollectionViewCell {
    @IBOutlet
    private weak var imageView: UIImageView?

    @IBOutlet
    private weak var nameLabel: UILabel?

    @IBOutlet
    private weak var priceLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        updateBackgroundColor()
        layer.cornerRadius = 8
        imageView?.layer.cornerRadius = 8
    }

    func configure(for item: ToastItem, price: String) {
        imageView?.image = item.image
        nameLabel?.text = item.name
        priceLabel?.text = price
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        nameLabel?.text = nil
        priceLabel?.text = nil
    }

    override var isSelected: Bool {
        didSet {
            updateBackgroundColor()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            updateBackgroundColor()
        }
    }

    private func updateBackgroundColor() {
        if isSelected || isHighlighted {
            backgroundColor = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1.00)
        } else {
            backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        }
    }

}
