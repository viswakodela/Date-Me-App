//
//  RegistrationViewModel.swift
//  Date Me App
//
//  Created by Viswa Kodela on 11/17/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class RegistrationViewModel {
    
    var image: UIImage? {
        didSet {
            guard let image = image else {return}
            imageObserver?(image)
        }
    }
    
    var imageObserver: ((UIImage) -> ())?
    
    var fullName: String? {
        didSet {
            checkFormValidity()
        }
    }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false  && email?.isEmpty == false && password?.isEmpty == false
        isFormValidObserver?(isFormValid)
    }
    
    var isFormValidObserver: ((Bool) -> ())?
    
}
