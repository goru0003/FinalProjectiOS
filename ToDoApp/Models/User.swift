//
//  User.swift
//  ToDoApp
//
//  Created by Cemilcan Gorur on 2025-04-19.
//

import Foundation
import SwiftData

@Model
final class User {
    var id: UUID
    var email: String
    var name: String
    var password: String
    @Relationship(deleteRule: .cascade) var tasks: [Task]
    
    init(name: String, email: String, password: String) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.password = password
        self.tasks = []
    }
}
