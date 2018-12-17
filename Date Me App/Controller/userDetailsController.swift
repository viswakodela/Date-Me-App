//
//  userDetailsController.swift
//  Date Me App
//
//  Created by Viswa Kodela on 12/15/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class userDetailsController: UIViewController, UIScrollViewDelegate {
    
    var cardViewModel: CardViewModel? {
        didSet{
            infoLabel.attributedText = cardViewModel?.attributedText
            guard let firstUrl = cardViewModel?.imageNames.first else {return}
            let firstImageUrl = URL(string: firstUrl)
            imageVie.sd_setImage(with: firstImageUrl, completed: nil)
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        var width = view.frame.width + changeY * 2
        width = max(width, view.frame.width)
        imageVie.frame = CGRect(x: min(0, -changeY), y: min(0, -changeY), width: width, height: width)
    }
    
    let imageVie: UIImageView = {
        let iv = UIImageView()
//        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "lady5c")
        return iv
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "dismissButton").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupViews()
    }
    
    func visualBlurEffoct() {
        
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffect = UIVisualEffectView(effect: blurEffect)
        view.addSubview(visualEffect)
        visualEffect.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffect.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        visualEffect.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        visualEffect.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(imageVie)
        imageVie.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
//        imageVie.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        imageVie.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        imageVie.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
//        imageVie.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        scrollView.addSubview(infoLabel)
        infoLabel.topAnchor.constraint(equalTo: imageVie.bottomAnchor, constant: 16).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        infoLabel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        scrollView.addSubview(dismissButton)
        dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        dismissButton.topAnchor.constraint(equalTo: imageVie.bottomAnchor, constant: -28).isActive = true
        
    }

}
