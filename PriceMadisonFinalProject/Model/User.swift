//
//  User.swift
//  PriceMadisonFinalProject
//
//  Created by Madison Price on 12/3/23.
//

import Foundation

struct User: Hashable, Identifiable, Codable{ //user struct to hold each account
    let id: String
    let name: String
    let email: String
    let password: String
    let signedInWithGoogle: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(email)
        hasher.combine(password)
        hasher.combine(signedInWithGoogle)
    }
}
