//
//  Users.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 01/05/23.
//

import Foundation

struct User: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let fullname: String
    let email: String
//    var favourites: [String]
    
    
    // this will return the initial of the user's name
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname)
        {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

// creating obj of the struct U ser
extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Fido Rogers", email: "fido@apple.com")
    
}



