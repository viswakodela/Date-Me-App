//
//  SettingsCell.swift
//  Date Me App
//
//  Created by Viswa Kodela on 11/25/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    class SettingsTextField: UITextField {
        override var intrinsicContentSize: CGSize {
            return CGSize(width: 0, height: 44)
        }
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        }
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        }
    }
    
    let textField: UITextField = {
        let tf = SettingsTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTextField()
    }
    
    func setupTextField() {
        addSubview(textField)
        textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
