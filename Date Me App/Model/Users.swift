//
//  Users.swift
//  Date Me App
//
//  Created by Viswa Kodela on 11/8/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

struct Users: ProducesCardViewModel {
    
    var userName: String?
    var age: Int?
    var profession: String?
    var imageUrl1: String?
    let uid: String?
    
    init (dictionary: [String : Any]) {
        
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        
        self.userName = dictionary["fullName"] as? String
        self.imageUrl1 = dictionary["imageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String
    }
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: "\(self.userName ?? "")", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        let ageString = age != nil ? "\(age!)" : "N\\A"
        attributedText.append(NSAttributedString(string: "  \(ageString)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
        let profession = self.profession != nil ? "\(self.profession!)" : "Not available"
        attributedText.append(NSAttributedString(string: "\n\(profession)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        if let imageUrl1 = imageUrl1 {
            return CardViewModel(imageNames: [imageUrl1], attributedText: attributedText, textAlignment: .left)
        }
        return CardViewModel(imageNames: [""], attributedText: attributedText, textAlignment: .center)
    }
}
