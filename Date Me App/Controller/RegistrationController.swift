//
//  RegistrationController.swift
//  Date Me App
//
//  Created by Viswa Kodela on 11/12/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class RegistrationController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        setupGradiantLayer()
        stupLayout()
        setupKeyboardNotificationObserver()
        registrationFormVaildObserver()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self) // If we don't do this it will cause the retain cycle
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
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
    
    @objc func handleTextChange(textField: UITextField) {
        if textField == fullNameTextField{
            registationViewModel.fullName = textField.text
        } else if textField == emailTextField {
            registationViewModel.email = textField.text
        } else {
            registationViewModel.password = textField.text
        }
    }
    
    let registationViewModel = RegistrationViewModel()
    func registrationFormVaildObserver() {
        registationViewModel.isFormValidObserver = { [unowned self] (isFormValid) in
            if isFormValid {
                self.registerButton.isEnabled = true
                self.registerButton.backgroundColor = UIColor(red: 253/255, green: 91/255, blue: 95/255, alpha: 1)
                self.registerButton.tintColor = .white
            } else {
                self.registerButton.isEnabled = false
                self.registerButton.backgroundColor = .gray
                self.registerButton.tintColor = .black
            }
        }
        registationViewModel.imageObserver = { [unowned self] (image) in
            self.selectPhotoButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
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
        button.addTarget(self, action: #selector(handlePhotoSelection), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePhotoSelection() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            registationViewModel.image = originalImage
//            self.selectPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        else if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            registationViewModel.image = editedImage
//            self.selectPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    let fullNameTextField: UITextField = {
        let tf = CustomTextField(padding: 16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 25
        tf.clipsToBounds = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        tf.placeholder = "Enter Full Name"
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = CustomTextField(padding: 16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 25
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
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
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        button.backgroundColor = .gray
        button.isEnabled = false
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    
    let handlingRegister = JGProgressHUD(style: .dark)
    
    @objc func handleRegister() {
        
        self.handleTapDismiss()
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        Auth.auth().createUser(withEmail: email, password: password) { [unowned self] (result, err) in
            if err != nil {
                guard let error = err else {return}
                self.showProgressHUD(error: error)
                return
            }
            
            self.handlingRegister.textLabel.text = "Registering"
            self.handlingRegister.show(in: self.view)
            
            let fileName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child(fileName)
            
            guard let data = self.selectPhotoButton.imageView?.image?.jpegData(compressionQuality: 0.8) else {return}
            storageRef.putData(data, metadata: nil, completion: { [unowned self] (_, err) in
                if err != nil {
                    guard let error = err else { return }
                    self.showProgressHUD(error: error)
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                    if let error = error {
                        self.showProgressHUD(error: error)
                        return
                    }
                    print("Download URL: \(url?.absoluteString ?? "")")
                })
                self.handlingRegister.dismiss()
            })
        }
    }
    
    func showProgressHUD(error: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed Registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
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
