//
//  CardDetailsCell.swift
//  Toast Delivery
//

import UIKit
import SnapKit
import CoreUI
import Combine

extension Translations.Card {
    struct CardDetailsEntry {
        var number: String = "Credit card number"
        var expiryMonth: String = "MM"
        var expiryYear: String = "YY"
        var cvv: String = "CVV"
        var name: String = "Holder's name"
        var zipCode: String = "Zip Code"
    }
}

class CardDetailsCell: UITableViewCell {
    
    var bindings = Set<AnyCancellable>()
    
    weak var numberField: UITextField!
    weak var expiryMonthField: UITextField!
    weak var expiryYearField: UITextField!
    weak var cvvField: UITextField!
    weak var nameField: UITextField!
    weak var zipCodeField: UITextField!
    
    var card: CardViewModel {
        CardViewModel(
            number: numberField.text,
            expiryYear: expiryYearField.text,
            expiryMonth: expiryMonthField.text,
            cvv: cvvField.text,
            ownersName: nameField.text,
            zipCode: zipCodeField.text
        )
    }
    
    var allFields: [UITextField] {
        [numberField, expiryMonthField, expiryYearField, cvvField, nameField, zipCodeField]
    }
    
    private let horizontalMargin: CGFloat = 20
    private let interlineMargin: CGFloat = 20
    private let expiryFieldWidth: CGFloat = 64
    
    static var prefferedHeight: CGFloat = 192
    
    var translations: Translations.Card.CardDetailsEntry {
        env.translations.card.detailsEntry
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        selectionStyle = .none
        
        setupNumberField()
        setupExpiryMonthField()
        setupExpiryYearField()
        setupCVVField()
        setupNameField()
        setupZipCodeField()
    }
    
    private func setupNumberField() {
        numberField = makeFieldWithConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(horizontalMargin)
            make.right.equalToSuperview().offset(-horizontalMargin)
        }
        numberField.placeholder = translations.number
        numberField.becomeFirstResponder()
        numberField.textContentType = .creditCardNumber
    }
    
    private func setupExpiryMonthField() {
        expiryMonthField = makeFieldWithConstraints { make in
            make.top.equalTo(numberField.snp.bottom).offset(interlineMargin)
            make.left.equalToSuperview().offset(horizontalMargin)
            make.width.equalTo(expiryFieldWidth)
        }
        expiryMonthField.placeholder = translations.expiryMonth
    }
    
    private func setupExpiryYearField() {
        expiryYearField = makeFieldWithConstraints { make in
            make.top.equalTo(expiryMonthField)
            make.left.equalTo(expiryMonthField.snp.right)
            make.width.equalTo(expiryFieldWidth)
        }
        expiryYearField.placeholder = translations.expiryYear
    }
    
    private func setupCVVField() {
        cvvField = makeFieldWithConstraints { make in
            make.right.equalToSuperview().offset(-horizontalMargin)
            make.top.equalTo(numberField.snp.bottom).offset(interlineMargin)
            make.width.equalTo(74)
        }
        cvvField.placeholder = translations.cvv
    }
    
    private func setupNameField() {
        nameField = makeFieldWithConstraints { make in
            make.top.equalTo(expiryMonthField.snp.bottom).offset(interlineMargin * 2)
            make.left.equalToSuperview().offset(horizontalMargin)
            make.right.equalToSuperview().offset(-horizontalMargin)
        }
        nameField.keyboardType = .default
        nameField.textContentType = .name
        nameField.autocapitalizationType = .words
        nameField.placeholder = translations.name
    }
    
    private func setupZipCodeField() {
        zipCodeField = makeFieldWithConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(interlineMargin)
            make.left.equalToSuperview().offset(horizontalMargin)
            make.right.equalToSuperview().offset(-horizontalMargin)
        }
        zipCodeField.placeholder = translations.zipCode
    }
    
    private func makeFieldWithConstraints(_ constraints: (ConstraintMaker) -> Void) -> UITextField {
        let field = UITextField()
        field.keyboardType = .numberPad
        contentView.addSubview(field)
        
        field.snp.makeConstraints(constraints)
        
        return field
    }
}
