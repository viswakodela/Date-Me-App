//
//  SettingsController.swift
//  Date Me App
//
//  Created by Viswa Kodela on 11/25/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import JGProgressHUD

class CustiomeImagePicker: UIImagePickerController {
    var button: UIButton?
}

class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.register(SettingsCell.self, forCellReuseIdentifier: cellId)
        tableView.register(AgeRangeCell.self, forCellReuseIdentifier: ageCellId)
        tableView.keyboardDismissMode = .onDrag
        fetchCurrentUserInfoFromFirebase()
    }
    
    var user: Users?
    
    let cellId = "cellId"
    let ageCellId = "ageCellId"
    
    lazy var image1Button = createButton(selector: #selector(imageButtonsImagePicker))
    lazy var image2Button = createButton(selector: #selector(imageButtonsImagePicker))
    lazy var image3Button = createButton(selector: #selector(imageButtonsImagePicker))
    
    lazy var header: UIView = {
        let header = UIView()
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
    }()
    
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Image", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
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
        
        
        
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        let imageButton = (picker as? CustiomeImagePicker)?.button
        imageButton?.setImage(editedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        self.dismiss(animated: true, completion: nil)
        
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference().child("profile_images").child(fileName)
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading Image"
        hud.show(in: view)

        guard let uploadData = editedImage?.jpegData(compressionQuality: 0.8) else {return}
        
        ref.putData(uploadData, metadata: nil) { (data, err) in
            hud.dismiss()
            if err != nil {
                print(err ?? "")
            }
            print("Finish uploading the Image")
            
            ref.downloadURL { (url, err) in
                if err != nil {
                    print(err ?? "")
                }
                
                if imageButton == self.image1Button {
                    self.user?.imageUrl1 = url?.absoluteString
                } else if imageButton == self.image2Button {
                    self.user?.imageUrl2 = url?.absoluteString
                } else {
                    self.user?.imageUrl3 = url?.absoluteString
                }
            }
        }
    }
    
    fileprivate func fetchCurrentUserInfoFromFirebase() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
            print(uid)
            if error != nil {
                print(error ?? "")
            }
            
            guard let userDictionary = snapshot?.data() else {return}
            self.user = Users(dictionary: userDictionary)
            self.fetchUserImages()
            self.tableView.reloadData()
        }
    }
    
    fileprivate func fetchUserImages() {
        
        if let imageUrl = self.user?.imageUrl1, let url = URL(string: imageUrl){
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            
            if let imageURL2 = self.user?.imageUrl2, let url = URL(string: imageURL2) {
                SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.image2Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
                }
            }
            
            if let imageURL3 = self.user?.imageUrl3, let url = URL(string: imageURL3) {
                SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                    self.image3Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
                }
            }
        }
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
        
        guard let uid =  Auth.auth().currentUser?.uid else {return}
        
//        let url = url?.absoluteString
        let docData: [String : Any] = [
            "uid" : uid,
            "fullName" : self.user?.userName ?? "",
            "age" : self.user?.age ?? -1,
            "imageUrl1" : self.user?.imageUrl1 ?? "",
            "imageUrl2" : self.user?.imageUrl2 ?? "",
            "imageUrl3" : self.user?.imageUrl3 ?? "",
            "profession" : self.user?.profession ?? "",
            "bio" : self.user?.bio ?? "",
            "minAge" : self.user?.minAge ?? -1,
            "maxAge" : self.user?.maxAge ?? -1
            ]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving"
        hud.show(in: self.view)
        
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            if err != nil {
                print(err ?? "")
            }
        }
        hud.dismiss()
    }
    
    @objc func handleNameChange(textField: UITextField) {
        self.user?.userName = textField.text
    }
    
    @objc func handleAgeChange(textField: UITextField) {
        self.user?.age = Int(textField.text ?? "")
    }
    
    @objc func handleProfessionChange(textField: UITextField) {
        self.user?.profession = textField.text
    }
    
    @objc func handleBioChange(textField: UITextField) {
        self.user?.bio = textField.text
    }
    
    @objc func handleLogout() {
        
    }
}



extension SettingsController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }
        let headerLabel = HeaderLabel()
        headerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        switch section {
        case 1:
            headerLabel.text = "Name"
        case 2:
            headerLabel.text = "Profession"
        case 3:
            headerLabel.text = "Age"
        case 4:
            headerLabel.text = "Bio"
        default:
            headerLabel.text = "Seeking Age range"
        }
        return headerLabel
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SettingsCell
        
        if indexPath.section == 5 {
            let ageRangeCell = tableView.dequeueReusableCell(withIdentifier: self.ageCellId, for: indexPath) as! AgeRangeCell
            
            ageRangeCell.minLabel.text = "Min  \(self.user?.minAge ?? -1)"
            ageRangeCell.maxLabel.text = "Max  \(self.user?.maxAge ?? -1)"
            
            if let minAge = self.user?.minAge, let maxAge = self.user?.maxAge {
                ageRangeCell.minSlider.value = Float(minAge)
                ageRangeCell.maxSlider.value = Float(maxAge)
            }
            
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinAgeChange), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChanged), for: .valueChanged)
            
            return ageRangeCell
        }
        
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = self.user?.userName
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter your Profession"
            cell.textField.text = self.user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter your Age"
            if let age = self.user?.age {
                cell.textField.text = String(age)
                cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            }
        default:
            cell.textField.placeholder = "Bio"
            cell.textField.text = self.user?.bio
            cell.textField.addTarget(self, action: #selector(handleBioChange), for: .editingChanged)
        }
        return cell
    }
    
    @objc func handleMinAgeChange(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        let cell = tableView.cellForRow(at: indexPath) as? AgeRangeCell
        cell?.minLabel.text = "Min  \(Int(slider.value))"
        self.user?.minAge = Int(slider.value)
    }
    
    @objc func handleMaxAgeChanged(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        let cell = tableView.cellForRow(at: indexPath) as? AgeRangeCell
        cell?.maxLabel.text = "Min  \(Int(slider.value))"
        self.user?.maxAge = Int(slider.value)
    }
    
}


