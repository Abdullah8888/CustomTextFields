//
//  ViewController.swift
//  CustomTextFields
//
//  Created by Abdullah on 27/02/2022.
//

import UIKit

final class ViewController: UIViewController {

    let firstNameTextField = BJTextField(title: "First name")
    let lastNameTextField = BJTextField(title: "Last name")
    let phoneTextField = BJTextField(title: "Phone Number", iconName: "phone", iconPosition: .left)
    let emailTextField = BJTextField(title: "Email")
    let passwordTextField = BJTextField(title: "Password", iconName: "close_eye", iconPosition: .right, isPasswordField: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let stack = VerticalStackView(arrangedSubviews: [firstNameTextField,lastNameTextField, passwordTextField, phoneTextField, emailTextField, passwordTextField], spacing: 30)
        view.addSubview(stack)
        
        stack.placeAtCenterOf(centerY: view.centerYAnchor, centerX: view.centerXAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .sides(20, 20))
        stack.subviews.forEach{ $0.constrainHeight(constant: 55)}
        
        passwordTextField.icon.onClick { [weak self] in
            guard let self = self else {return}
            self.passwordIconTapped()
        }
    
        firstNameTextField.fieldDidChange = { [weak self] text in
            guard let self = self else {return}
            self.validateField(with: text?.isValidName, on: self.firstNameTextField, message: "Please enter a valid first name")
        }
        
        lastNameTextField.fieldDidChange = { [weak self] text in
            guard let self = self else {return}
            self.validateField(with: text?.isValidName, on: self.lastNameTextField, message: "Please enter a valid last name")
        }
        
        phoneTextField.fieldDidChange = { [weak self] text in
            guard let self = self else {return}
            self.validateField(with: text?.isValidNumericValueOnly, on: self.phoneTextField, message: "Please enter a valid phone number")
        }
        
        emailTextField.fieldDidChange = { [weak self] text in
            guard let self = self else {return}
            self.validateField(with: text?.isValidEmailAddress, on: self.emailTextField, message: "Please enter a valid email")
        }
        
        passwordTextField.fieldDidChange = { [weak self] text in
            guard let self = self else {return}
            self.validateField(with: text?.isValidPassword, on: self.passwordTextField, message: "Please enter a valid password")
        }
    }

    func passwordIconTapped() {
        print("Alternate password icon in progress ... ")
    }

    func validateField(with isValid: Bool?, on textField: BJTextField, message: String = "") {
        textField.validateField(isValid: isValid, message: message)
    }
    
}

