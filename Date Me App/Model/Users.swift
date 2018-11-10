//
//  Users.swift
//  Date Me App
//
//  Created by Viswa Kodela on 11/8/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import Foundation


struct Users {
    
    let userName: String
    let age: Int
    let profession: String
    let imageName: String
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: "\(self.userName)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "  \(self.age)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(self.profession)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        return CardViewModel(imageName: self.imageName, attributedText: attributedText, textAlignment: .left)
        
    }
}
