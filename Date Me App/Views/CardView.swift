//
//  CardView.swift
//  Date Me App
//
//  Created by Viswa Kodela on 11/7/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate: class{
    func didTapMoreInfo(cardViewModel: CardViewModel)
}

class CardView: UIView {
    
    
    weak var delegate: CardViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    var cardViewModel: CardViewModel! {
        didSet {
            guard let imageNames = cardViewModel?.imageNames else {return}
            let firstImage = imageNames.first ?? ""
            if let url = URL(string: firstImage) {
                self.imageView.sd_setImage(with: url, completed: nil)
            }
            
            guard let textAlignment = cardViewModel?.textAlignment else {return}
            guard let attributedTest = cardViewModel?.attributedText else {return}
            self.informationLabel.textAlignment = textAlignment
            self.informationLabel.attributedText = attributedTest
            
            let imagesCount = imageNames.count
            (0..<imagesCount).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = UIColor(white: 0, alpha: 0.1)
                barView.layer.cornerRadius = 2
                barView.translatesAutoresizingMaskIntoConstraints = false
                barView.clipsToBounds = true
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            setupImgaeObserver()
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
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
    
    let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return button
    }()
    
    @objc func handleMoreInfo() {
        self.delegate?.didTapMoreInfo(cardViewModel: self.cardViewModel)
    }
    
    fileprivate func setupViews() {
        self.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        setupBarsView()
        
        setupGradientLayer()
        
        self.addSubview(informationLabel)
        informationLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        informationLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        informationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        informationLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.addSubview(moreInfoButton)
        moreInfoButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        moreInfoButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        moreInfoButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        moreInfoButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    let barsStackView = UIStackView()
    func setupBarsView() {
        
        addSubview(barsStackView)
        barsStackView.spacing = 4
        barsStackView.translatesAutoresizingMaskIntoConstraints = false
        barsStackView.distribution = .fillEqually
        barsStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        barsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true
        barsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4).isActive = true
        barsStackView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    let gradientLayer = CAGradientLayer()
    func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.2]
        self.layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    func setupImgaeObserver() {
        
        cardViewModel.imageIndexObserver = { [unowned self] (index, imageUrl) in
            guard let imageUrl = imageUrl else {return}
            if let url = URL(string: imageUrl) {
                self.imageView.sd_setImage(with: url)
            }
            self.barsStackView.arrangedSubviews.forEach({ (v) in
                v.backgroundColor = UIColor(white: 0, alpha: 0.1)
            })
            self.barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        
        let location = gesture.location(in: nil)
        let shouldAdvaceNextPhoto = location.x > frame.width / 2 ? true : false
        
        if shouldAdvaceNextPhoto {
            cardViewModel.advanceNextPhoto()
        } else {
            cardViewModel.prevPhoto()
        }
        
//        if shouldAdvaceNextPhoto {
//            imageIndex = min(imageIndex + 1, cardViewModel.imageNames.count - 1)
//        } else {
//            imageIndex = max(0, imageIndex - 1)
//        }
//
//        self.imageView.image = UIImage(named: cardViewModel.imageNames[imageIndex])
    }
    
    
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .began {
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        }
        
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
        
        let threshold = 50
        let shouldDismisCard = Int(abs(gesture.translation(in: nil).x)) > threshold ? true : false
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            if shouldDismisCard {
                self.frame = CGRect(x: 600 * translationDirection, y: abs(translationDirection) * 100, width: self.superview!.frame.width, height: self.superview!.frame.height)
            } else {
                self.transform = .identity
            }
        }) { (_) in
            if shouldDismisCard {
                self.removeFromSuperview()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
