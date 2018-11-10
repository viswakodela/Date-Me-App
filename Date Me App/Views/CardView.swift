//
//  CardView.swift
//  Date Me App
//
//  Created by Viswa Kodela on 11/7/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "mouni")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    fileprivate func setupViews() {
        self.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(informationLabel)
        informationLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        informationLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        informationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        informationLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .changed {
            handleChanged(gesture: gesture)
        }
        else if gesture.state == .ended {
            handleEnded(gesture: gesture)
        }
    }
    
    func handleChanged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: nil)
        let degree = translation.x / 20
        let radian = degree / 57.295 // Formulae for changing the degrees into Radions
        let rotationalTraform = CGAffineTransform(rotationAngle: radian)
        self.transform = rotationalTraform.translatedBy(x: translation.x, y: translation.y)
        
    }
    
    func handleEnded(gesture: UIPanGestureRecognizer) {
        
        let threshold =  100
        let shouldDismisCard = Int(abs(gesture.translation(in: nil).x)) > threshold ? true : false
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            if shouldDismisCard {
                self.frame = CGRect(x: 600 * translationDirection, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
            } else {
                self.transform = .identity
            }
            
        }) { (_) in
            self.transform = .identity
            if shouldDismisCard {
                self.removeFromSuperview()
            }
//            self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
