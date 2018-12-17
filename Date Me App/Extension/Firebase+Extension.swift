//
//  File.swift
//  Date Me App
//
//  Created by Viswa Kodela on 12/10/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import Firebase

extension Firestore {
    func fetchCurrentUser(completion: @escaping (Users?, Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            
            // fetched our user here
            guard let dictionary = snapshot?.data() else { return }
            let user = Users(dictionary: dictionary)
            completion(user, nil)
        }
    }
}
