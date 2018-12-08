//
//  ViewController.swift
//  Date Me App
//
//  Created by Viswa Kodela on 11/6/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

class MainScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        fetchUsersFromFirestore()
    }
    
//    let cardViewModelArray = ([
//        Users(userName: "Mouni", age: 24, profession: "Software Developer", imageNames: ["mouni", "mouni2"]),
//        Users(userName: "Susmitha", age: 22, profession: "Developer", imageNames: ["susmi"]),
//        Advertisers(title: "Date Me App", brandName: "Datooo", posterPhotoName: ["mouni"])
//        ] as [ProducesCardViewModel]).map { $0.toCardViewModel()}
    
    var cardViewModelArray = [CardViewModel]()
    
    var lastFetchedUser: Users?
    
    func fetchUsersFromFirestore() {
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)
        
        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
        
        query.getDocuments { [weak self] (snapshot, error) in
            hud.dismiss()
            if let error = error {
                self?.showProgressHUD(text: error.localizedDescription)
                return
            }
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = Users(dictionary: userDictionary)
                self?.cardViewModelArray.append(user.toCardViewModel())
                self?.lastFetchedUser = user
                self?.setupCardViews(user: user)
            })
        }
    }
    
    func showProgressHUD(text: String) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Something went Wrong..!"
        hud.detailTextLabel.text = text
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    fileprivate func setupCardViews(user: Users) {
        
        let cardView = CardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        
        cardView.cardViewModel = user.toCardViewModel()
        
        blueView.addSubview(cardView)
        
        blueView.sendSubviewToBack(cardView)
        
        cardView.topAnchor.constraint(equalTo: blueView.topAnchor).isActive = true
        cardView.leadingAnchor.constraint(equalTo: blueView.leadingAnchor).isActive = true
        cardView.trailingAnchor.constraint(equalTo: blueView.trailingAnchor).isActive = true
        cardView.bottomAnchor.constraint(equalTo: blueView.bottomAnchor).isActive = true
        
        overallStackView.bringSubviewToFront(blueView)
    }

    let profileButton: UIButton = {
        let profButton = UIButton(type: .system)
        profButton.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
        profButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        return profButton
    }()
    
    @objc func handleSettings() {
        let settings = SettingsController()
        let navSettingsController = UINavigationController(rootViewController: settings)
        present(navSettingsController, animated: true, completion: nil)
    }
    
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
        let refreshbutton = UIButton(type: .system)
        refreshbutton.setImage(#imageLiteral(resourceName: "refresh_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        refreshbutton.addTarget(self, action: #selector(handleRefreshButton), for: .touchUpInside)
        return refreshbutton
    }()
    
    @objc func handleRefreshButton() {
        
        fetchUsersFromFirestore()
        
    }
    
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
        overallStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        overallStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        overallStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        overallStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        
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

