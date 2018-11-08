//
//  ViewController.swift
//  Date Me App
//
//  Created by Viswa Kodela on 11/6/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class MainScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setupDummyCards()
    }
    
    let users = [Users(userName: "Mouni", age: 24, profession: "Software Developer", imageName: "mouni"),
                 Users(userName: "Susmitha", age: 22, profession: "Developer", imageName: "susmi")]
    
    fileprivate func setupDummyCards() {
        
        users.forEach { (user) in
            let cardView = CardView()
            cardView.translatesAutoresizingMaskIntoConstraints = false
            cardView.layer.cornerRadius = 10
            cardView.clipsToBounds = true
            
            cardView.imageView.image = #imageLiteral(resourceName: "mouni")
            
            let attributedText = NSMutableAttributedString(string: "\(user.userName)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
            attributedText.append(NSAttributedString(string: "  \(user.age)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
            attributedText.append(NSAttributedString(string: "\n\(user.profession)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
            cardView.informationLabel.attributedText = attributedText
            
            cardView.imageView.image = UIImage(named: "\(user.imageName)")
            
            blueView.addSubview(cardView)
            cardView.topAnchor.constraint(equalTo: blueView.topAnchor).isActive = true
            cardView.leadingAnchor.constraint(equalTo: blueView.leadingAnchor).isActive = true
            cardView.trailingAnchor.constraint(equalTo: blueView.trailingAnchor).isActive = true
            cardView.bottomAnchor.constraint(equalTo: blueView.bottomAnchor).isActive = true
        }
        
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        overallStackView.bringSubviewToFront(blueView)
    }

    let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let appIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let messagesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "refresh_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let starButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let boostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "boost_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    
    let redView = UIView() //Top Stack View's reference
    let blueView = UIView() // Middile ImageView's reference
    let yellowView = UIView() // Bottom stack view's reference
    var overallStackView = UIStackView() // Entire StackView's Reference
    
    fileprivate func setUpViews() {
        
        view.backgroundColor = .white
        redView.translatesAutoresizingMaskIntoConstraints = false
        redView.backgroundColor = .white
        redView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        topStackview(redView)
        
        blueView.translatesAutoresizingMaskIntoConstraints = false
        
        yellowView.translatesAutoresizingMaskIntoConstraints = false
        yellowView.backgroundColor = .clear
        yellowView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        bottomStackView(yellowView)
        
        overallStackView = UIStackView(arrangedSubviews: [redView, blueView, yellowView])
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        overallStackView.axis = .vertical
//        stackView.distribution = .fillEqually
        
        view.addSubview(overallStackView)
        overallStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        overallStackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        overallStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        overallStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    fileprivate func topStackview(_ redView: UIView) {
        let topStackview = UIStackView(arrangedSubviews: [profileButton, UIView(), UIView(), appIconImageView, UIView(), UIView(), messagesButton])
        topStackview.alignment = .center
        topStackview.axis = .horizontal
        topStackview.distribution = .fillEqually
        topStackview.translatesAutoresizingMaskIntoConstraints = false
        
        redView.addSubview(topStackview)
        topStackview.topAnchor.constraint(equalTo: redView.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        topStackview.leadingAnchor.constraint(equalTo: redView.leadingAnchor).isActive = true
        topStackview.trailingAnchor.constraint(equalTo: redView.trailingAnchor).isActive = true
        topStackview.bottomAnchor.constraint(equalTo: redView.bottomAnchor, constant: -8).isActive = true
    }
    
    fileprivate func bottomStackView(_ yellowView: UIView) {
        let bottomStackview = UIStackView(arrangedSubviews: [refreshButton, dismissButton, starButton, likeButton, boostButton])
        bottomStackview.alignment = .center
        bottomStackview.axis = .horizontal
        bottomStackview.distribution = .equalSpacing
        bottomStackview.translatesAutoresizingMaskIntoConstraints = false
        
        yellowView.addSubview(bottomStackview)
        bottomStackview.topAnchor.constraint(equalTo: yellowView.topAnchor).isActive = true
        bottomStackview.leadingAnchor.constraint(equalTo: yellowView.leadingAnchor).isActive = true
        bottomStackview.trailingAnchor.constraint(equalTo: yellowView.trailingAnchor).isActive = true
        bottomStackview.bottomAnchor.constraint(equalTo: yellowView.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
    }

}

