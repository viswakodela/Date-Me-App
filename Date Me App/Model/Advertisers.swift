//
//  Advertisers.swift
//  Date Me App
//
//  Created by Viswa Kodela on 11/10/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

struct Advertisers: ProducesCardViewModel {
    
    let title: String
    let brandName: String
    let posterPhotoName: [String]
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: "\(self.title)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "\n\(self.brandName)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        return CardViewModel(imageNames: self.posterPhotoName, attributedText: attributedText, textAlignment: .center)
        
    }
    
}


