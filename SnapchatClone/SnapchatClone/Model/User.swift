//
//  File.swift
//  SnapchatClone
//
//  Created by Rethink on 28/03/22.
//

import Foundation


class User{
    
    var email: String
    var name: String
    var uid: String
    
    init(email: String, name: String, uid: String){
        self.email = email
        self.name = name
        self.uid = uid
    }
}
