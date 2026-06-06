//
//  Assignment.swift
//  PriceMadisonFinalProject
//
//  Created by Madison Price on 12/3/23.
//

import Foundation

struct Assignment: Hashable, Identifiable, Codable{
    let id: String
    let title: String
    let dueDate: String
    let className: String
    var completed: Bool
    let notes: String //for any additional notes about the assignment
    let userId: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(dueDate)
        hasher.combine(className)
        hasher.combine(completed)
        hasher.combine(notes)
        hasher.combine(userId)
    }
}
