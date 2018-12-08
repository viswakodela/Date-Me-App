//
//  CardViewModel.swift
//  Date Me App
//
//  Created by Viswa Kodela on 11/8/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class CardViewModel {
    
    let imageNames: [String]
    let attributedText: NSAttributedString
    let textAlignment: NSTextAlignment
    
    init(imageNames: [String], attributedText: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageNames = imageNames
        self.attributedText = attributedText
        self.textAlignment = textAlignment
    }
    
    var imageIndex = 0 {
        didSet {
            let imageUrl = self.imageNames[imageIndex]
            imageIndexObserver?(imageIndex, imageUrl)
        }
    }
    
    //Reactive Programming
    var imageIndexObserver: ((Int, String?) -> ())?
    
    func advanceNextPhoto() {
        imageIndex = min(imageIndex + 1, imageNames.count - 1)
    }
    func prevPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
    
}
