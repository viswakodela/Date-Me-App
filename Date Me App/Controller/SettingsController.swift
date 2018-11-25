//
//  SettingsController.swift
//  Date Me App
//
//  Created by Viswa Kodela on 11/25/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class CustiomeImagePicker: UIImagePickerController {
    var button: UIButton?
}

class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    lazy var image1Button = createButton(selector: #selector(imageButtonsImagePicker))
    lazy var image2Button = createButton(selector: #selector(imageButtonsImagePicker))
    lazy var image3Button = createButton(selector: #selector(imageButtonsImagePicker))
    
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Image", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        button.backgroundColor = .white
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    @objc func imageButtonsImagePicker(button: UIButton) {
        let imagePicker = CustiomeImagePicker()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.button = button
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
        (picker as? CustiomeImagePicker)?.button?.setImage(originalimage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
        (picker as? CustiomeImagePicker)?.button?.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupNavigationItems() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)), UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))]
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        
    }
    
    @objc func handleLogout() {
        
    }
}

extension SettingsController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .blue
        header.addSubview(image1Button)
        image1Button.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 16).isActive = true
        image1Button.topAnchor.constraint(equalTo: header.topAnchor, constant: 16).isActive = true
        image1Button.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -16).isActive = true
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        header.addSubview(stackView)
        stackView.leftAnchor.constraint(equalTo: image1Button.rightAnchor, constant: 16).isActive = true
        stackView.rightAnchor.constraint(equalTo: header.rightAnchor, constant: -16).isActive = true
        stackView.topAnchor.constraint(equalTo: header.topAnchor, constant: 16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -16).isActive = true
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
}


