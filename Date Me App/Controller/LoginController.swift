//
//  LoginController.swift
//  Date Me App
//
//  Created by Viswa Kodela on 12/12/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import JGProgressHUD
import Firebase

protocol LoginControllerDelegate: class {
    func didFinishLogging()
}

class LoginController: UIViewController {
    
    weak var delegate: LoginControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradiantLayer()
        setupLayout()
        
    }
    
    override func viewWillLayoutSubviews() {
        gradientLayer.frame = view.bounds
    }
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 25
        tf.clipsToBounds = true
        tf.placeholder = "Email"
        tf.addTarget(self, action: #selector(handleFormValid), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 25
        tf.clipsToBounds = true
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleFormValid), for: .editingChanged)
        return tf
    }()
    
    func showProgressHUD(text: String) {
        let hud = JGProgressHUD(style: .dark)
        hud.detailTextLabel.text = text
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    @objc fileprivate func handleFormValid() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor(red: 253/255, green: 91/255, blue: 95/255, alpha: 1)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = .gray
        }
    }
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log in", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        button.isEnabled = false
        button.layer.cornerRadius = 25
        button.backgroundColor = .gray
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handlelogin), for: .touchUpInside)
        return button
    }()
    
    let goBackButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go Back", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleGoback), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleGoback() {
        navigationController?.popToViewController(RegistrationController(), animated: true)
//        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func handlelogin() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if let err = err {
                self.showProgressHUD(text: err.localizedDescription)
            }
            self.dismiss(animated: true, completion: {
                self.delegate?.didFinishLogging()
            })
        }
    }
    
    let gradientLayer = CAGradientLayer()
    func setupGradiantLayer() {
        let topColor = UIColor(red: 253/255, green: 91/255, blue: 95/255, alpha: 1).cgColor
        let bottomColor = UIColor(red: 240/255, green: 0, blue: 130/255, alpha: 1).cgColor
        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        //        gradießtLayer.frame = view.frame
    }
    
    fileprivate func setupLayout() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        view.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        
        view.addSubview(goBackButton)
        goBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        goBackButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        goBackButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 350).isActive = true

    }
}
