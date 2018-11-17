//
//  RegistrationController.swift
//  Date Me App
//
//  Created by Viswa Kodela on 11/12/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController {
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        setupGradiantLayer()
        stupLayout()
        setupKeyboardNotificationObserver()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self) // If we don't do this it will cause the retain cycle
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.frame
    }
    
    func setupKeyboardNotificationObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardObserver), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func handleKeyboardObserver(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - overallStactView.frame.origin.y - overallStactView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }
    
    @objc func handleTapDismiss() {
        view.endEditing(true) //dismiss Keyboard
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
        
    }
    
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select Photo", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 300).isActive = true
        return button
    }()
    
    let fullNameTextField: UITextField = {
        let tf = CustomTextField(padding: 16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 25
        tf.clipsToBounds = true
        tf.placeholder = "Enter Full Name"
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = CustomTextField(padding: 16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 25
        tf.clipsToBounds = true
        tf.placeholder = "Email"
        return tf
    }()

    let passwordTextField: UITextField = {
        let tf = CustomTextField(padding: 16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 25
        tf.clipsToBounds = true
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        button.backgroundColor = UIColor(red: 213/255, green: 57/255, blue: 115/255, alpha: 1)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    let gradientLayer = CAGradientLayer()
    func setupGradiantLayer() {
        let topColor = UIColor(red: 253/255, green: 91/255, blue: 95/255, alpha: 1).cgColor
        let bottomColor = UIColor(red: 240/255, green: 0, blue: 130/255, alpha: 1).cgColor
        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
//        gradientLayer.frame = view.frame
    }
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [fullNameTextField, emailTextField, passwordTextField, registerButton])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    lazy var  overallStactView = UIStackView(arrangedSubviews: [selectPhotoButton, self.verticalStackView])
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if self.traitCollection.verticalSizeClass == .compact {
            overallStactView.axis = .horizontal
        } else {
            overallStactView.axis = .vertical
        }
    }
    
    func stupLayout() {
        
//        overallStactView.axis = .vertical
        selectPhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
        overallStactView.spacing = 8
        overallStactView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(overallStactView)
        overallStactView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        overallStactView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        overallStactView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        
    }

    
}
