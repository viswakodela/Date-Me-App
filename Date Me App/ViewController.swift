//
//  ViewController.swift
//  Date Me App
//
//  Created by Viswa Kodela on 11/6/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpViews()
    }

    let profileButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "top_left_profile"), for: .normal)
        return button
    }()
    
    let appIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "app_icon")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let messagesButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "top_right_messages"), for: .normal)
        return button
    }()
    
    let middileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "mouni")
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    let refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "refresh_circle"), for: .normal)
        return button
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "dismiss_circle"), for: .normal)
        return button
    }()
    
    let starButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "super_like_circle"), for: .normal)
        return button
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "like_circle"), for: .normal)
        return button
    }()
    
    let boostButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "boost_circle"), for: .normal)
        return button
    }()
    
    fileprivate func setUpViews() {
        
        let redView = UIView()
        redView.translatesAutoresizingMaskIntoConstraints = false
        redView.backgroundColor = .white
        redView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        topStackview(redView)
        
        
        let blueView = UIView()
        blueView.translatesAutoresizingMaskIntoConstraints = false
        blueView.addSubview(middileImageView)
        middileImageView.topAnchor.constraint(equalTo: blueView.topAnchor, constant: 8).isActive = true
        middileImageView.leadingAnchor.constraint(equalTo: blueView.leadingAnchor, constant: 8).isActive = true
        middileImageView.trailingAnchor.constraint(equalTo: blueView.trailingAnchor, constant: -8).isActive = true
        middileImageView.bottomAnchor.constraint(equalTo: blueView.bottomAnchor, constant: -8).isActive = true
        
        let yellowView = UIView()
        yellowView.translatesAutoresizingMaskIntoConstraints = false
        yellowView.backgroundColor = .white
        yellowView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        bottomStackView(yellowView)
        
        let stackView = UIStackView(arrangedSubviews: [redView, blueView, yellowView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    fileprivate func topStackview(_ redView: UIView) {
        let redStackView = UIStackView(arrangedSubviews: [profileButton, appIconImageView, messagesButton])
        redStackView.alignment = .center
        redStackView.axis = .horizontal
        redStackView.distribution = .equalCentering
        redStackView.translatesAutoresizingMaskIntoConstraints = false
        redView.addSubview(redStackView)
        redStackView.topAnchor.constraint(equalTo: redView.safeAreaLayoutGuide.topAnchor).isActive = true
        redStackView.leadingAnchor.constraint(equalTo: redView.leadingAnchor, constant: 16).isActive = true
        redStackView.trailingAnchor.constraint(equalTo: redView.trailingAnchor, constant: -16).isActive = true
        redStackView.bottomAnchor.constraint(equalTo: redView.bottomAnchor).isActive = true
    }
    
    fileprivate func bottomStackView(_ yellowView: UIView) {
        let yellowStackView = UIStackView(arrangedSubviews: [refreshButton, dismissButton, starButton, likeButton, boostButton])
        yellowStackView.alignment = .center
        yellowStackView.axis = .horizontal
        yellowStackView.distribution = .equalSpacing
        yellowStackView.translatesAutoresizingMaskIntoConstraints = false
        
        yellowView.addSubview(yellowStackView)
        yellowStackView.topAnchor.constraint(equalTo: yellowView.topAnchor).isActive = true
        yellowStackView.leadingAnchor.constraint(equalTo: yellowView.leadingAnchor).isActive = true
        yellowStackView.trailingAnchor.constraint(equalTo: yellowView.trailingAnchor).isActive = true
        yellowStackView.bottomAnchor.constraint(equalTo: yellowView.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
    }

}

