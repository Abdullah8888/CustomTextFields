//
//  BJTextField.swift
//  CustomTextFields
//
//  Created by Abdullah on 27/02/2022.
//

import UIKit

private enum placeHolderLabelState {
    case add, remove
}

enum IconPosition {
    case left, right
}

enum FieldStatus {
    case pass, fail
}

final class BJTextField: UIView {
    
    private var messageLabel: Label = {
        let label = Label(alignment: .left)
        label.isHidden = true
        label.textColor = .red
        return label
    }()
    
    private lazy var alertIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "alert_icon_2"))
        imageView.accessibilityIdentifier = "Alert icon 2"
        return imageView
    }()
    
    var field: TextField = {
        let textField = TextField()
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 7
        textField.font = .helveticaNeueMedium(size: 15)
        textField.applyShadow(shadowOffset: .init(width: 0, height: 0))
        textField.backgroundColor = .white
        return textField
    }()
    
    private var fieldBorderColor: CGColor? {
        didSet {
            field.layer.borderColor = fieldBorderColor ?? UIColor.lightGray.withAlphaComponent(0.3).cgColor
            field.applyShadow(shadowColor: fieldBorderColor ?? UIColor.lightGray.withAlphaComponent(0.3).cgColor)
            field.textColor = .black
        }
    }
    
    private var fieldStatusColor: UIColor? {
        didSet {
            placeHolderLabel.textColor = fieldStatusColor
            field.textColor = fieldStatusColor ?? .black
        }
    }

    private var placeHolderText: String? {
        didSet {
            placeHolderLabel.text = placeHolderText
        }
    }

    private var placeHolderLabel = Label(padding: .sides(10, 10))
    private var fieldStatus: FieldStatus = .fail
    var fieldDidChange: ((String?) -> Void)?
    lazy var icon = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        field.addTarget(self, action: #selector(textFieldDidChange),
                                   for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        setup(title: title)
    }
    
    convenience init(title: String, iconName: String, iconPosition: IconPosition, padding: UIEdgeInsets = .sides(10, 10), isPasswordField: Bool = false) {
        self.init(frame: .zero)
        setup(title: title)
        setViewImage(iconName: iconName, iconPosition: iconPosition)
        field.isSecureTextEntry = isPasswordField
    }
    
    private func setup(title: String) {
        placeHolderText = title
        fieldBorderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        field.delegate = self
        field.attributedPlaceholder = NSAttributedString(string: title, attributes: [.font: UIFont.helveticaNeueRegular(size: 15), .foregroundColor: UIColor.black.withAlphaComponent(0.6)])
        
        addSubviews(field, messageLabel)
        field.fillSuperview()
        
        messageLabel.anchor(top: field.bottomAnchor, leading: field.leadingAnchor, bottom: nil, trailing: field.trailingAnchor, margin: .topOnly(2))
        field.addTarget(self, action: #selector(textFieldDidChange),
                                   for: .editingChanged)
    }
    
    private func setViewImage(iconName: String, iconPosition: IconPosition) {
        icon.image = UIImage(named: iconName)
        switch iconPosition {
        case .left:
            field.leftView = iconHolder(icon: icon)
            field.leftViewMode = .always
            field.padding = .leftOnly(45)
        case .right:
            field.rightView = iconHolder(icon: icon)
            field.rightViewMode = .always
        }
    }
    
    private func animateFieldForTextEntry() {
        updatePlaceHolderLabelState(with: .add)
        fieldBorderColor = UIColor.primaryYellow.cgColor
        
        layoutIfNeeded()
        placeHolderLabel.topAnchor.constraint(equalTo: field.topAnchor, constant: -placeHolderLabel.intrinsicContentSize.height/2).isActive = true
        placeHolderLabel.leadingAnchor.constraint(equalTo: field.leadingAnchor, constant: 20).isActive = true

        UIView.animate(withDuration: 0.8, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 1) {
            self.layoutIfNeeded()
        }
    }
    
    private func clearFieldAnimation() {
        updatePlaceHolderLabelState(with: .remove)
        if field.hasText {
            fieldBorderColor = fieldStatusColor?.cgColor
        }
        else {
            fieldBorderColor = nil
            messageLabel.isHidden = true
            if !field.isSecureTextEntry {
                field.rightView = nil
            }
        }
    }
    
    private func updatePlaceHolderLabelState(with state: placeHolderLabelState) {
        switch state {
        case .add:
            placeHolderLabel.viewCornerRadius = 10
            placeHolderLabel.applyShadow(shadowOffset: .zero)
            placeHolderLabel.font = .helveticaNeueRegular(size: 14)
            placeHolderLabel.textColor = .primaryYellow
            placeHolderLabel.backgroundColor = .white
            placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(placeHolderLabel)
        case .remove:
            if fieldStatus == .fail {
                placeHolderLabel.textColor = .black
                placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
                placeHolderLabel.backgroundColor = .clear
                placeHolderLabel.removeFromSuperview()
            }
        }
    }
    
    func updateFieldStatus(with status: FieldStatus, and message: String = "") {
        switch status {
        case .pass:
            fieldStatusColor = .hex158816
            fieldBorderColor = UIColor.hex158816.cgColor
            fieldStatus = status
            field.rightView = field.isSecureTextEntry ? iconHolder(icon: icon) : nil
            hideMessageLabel()
            
        case .fail:
            fieldStatusColor = .red
            fieldBorderColor = UIColor.red.cgColor
            fieldStatus = status
            field.rightView = iconHolder(icon: alertIcon)
            field.rightViewMode = .always
            showMessageLabel(with: message)
        }
    }
    
    private func hideMessageLabel() {
        messageLabel.isHidden = true
    }
    
    private func showMessageLabel(with text: String) {
        messageLabel.isHidden = false
        messageLabel.text = text
        messageLabel.font = .helveticaNeueRegular(size: 14)
    }
    
    
    private func iconHolder(icon: UIImageView) -> UIView {
        let iconHolder: UIView = UIView(frame: .zero)
        icon.contentMode = .scaleAspectFit
        iconHolder.addSubview(icon)
        icon.placeAtCenterOf(centerY: iconHolder.centerYAnchor, centerX: iconHolder.centerXAnchor, leading: iconHolder.leadingAnchor, trailing: iconHolder.trailingAnchor, padding: .init(allEdges: 10))
        return iconHolder
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        fieldDidChange?(textField.text)
    }
    
    func validateField(isValid: Bool?, message: String) {
        isValid ?? true ? updateFieldStatus(with: .pass) : updateFieldStatus(with: .fail, and: message)
    }
    
    func alternatePasswordIcon() {
        if field.isSecureTextEntry {
            field.isSecureTextEntry = false
            icon.image = UIImage(named: "open_eye")
        }
        else {
            field.isSecureTextEntry = true
            icon.image = UIImage(named: "close_eye")
        }
    }
}

// UITextField Delegate
extension BJTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateFieldForTextEntry()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        clearFieldAnimation()
    }
}

class TextField: UITextField {

    var padding: UIEdgeInsets = .sides(10, 10)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
