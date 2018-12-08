//
//  AgeRangeCell.swift
//  Date Me App
//
//  Created by Viswa Kodela on 12/6/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class AgeRangeCell: UITableViewCell {
    
    let minSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    
    let maxSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let minLabel: CustomLabel = {
        let label = CustomLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Min  18"
        return label
    }()
    
    let maxLabel: CustomLabel = {
        let label = CustomLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Max  18"
        return label
    }()
    
    class CustomLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            return CGSize(width: 80, height: 0)
        }
    }
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStacks()
    }
    
    func setupStacks() {
        let overallaStackView = UIStackView(arrangedSubviews:
            [
                UIStackView(arrangedSubviews: [minLabel, minSlider]),
                UIStackView(arrangedSubviews: [maxLabel, maxSlider])
            ])
        
        overallaStackView.axis = .vertical
        overallaStackView.spacing = 16
        overallaStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(overallaStackView)
        overallaStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        overallaStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        overallaStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        overallaStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
