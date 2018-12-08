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
    var imageUrl2: String?
    var imageUrl3: String?
    let uid: String?
    var bio: String?
    var minAge: Int?
    var maxAge: Int?
    
    init (dictionary: [String : Any]) {
        
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        
        self.userName = dictionary["fullName"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        self.uid = dictionary["uid"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        self.minAge = dictionary["minAge"] as? Int
        self.maxAge = dictionary["maxAge"] as? Int
    }
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: "\(self.userName ?? "")", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        let ageString = age != nil ? "\(age!)" : "N\\A"
        attributedText.append(NSAttributedString(string: "  \(ageString)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
        let profession = self.profession != nil ? "\(self.profession!)" : "Not available"
        attributedText.append(NSAttributedString(string: "\n\(profession)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        var imageUrls = [String]()
        if let url = imageUrl1 {
            imageUrls.append(url)
        }
        if let url2 = imageUrl2 {
            imageUrls.append(url2)
        }
        if let url3 = imageUrl3 {
            imageUrls.append(url3)
        }
        
        return CardViewModel(imageNames: imageUrls, attributedText: attributedText, textAlignment: .left)
    }
}
