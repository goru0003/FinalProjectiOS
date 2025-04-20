//
//  Task.swift
//  ToDoApp
//
//  Created by Cemilcan Gorur on 2025-04-19.
//

import Foundation
import SwiftData

@Model
final class Task {
    var id: UUID
    var title: String
    var notes: String?
    var dueDate: Date?
    var location: String?
    var category: String?
    var isDone: Bool
    @Relationship(deleteRule: .nullify) var user: User?
    
    init(title: String, notes: String? = nil, dueDate: Date? = nil, location: String? = nil, category: String? = nil, isDone: Bool = false) {
        self.id = UUID()
        self.title = title
        self.notes = notes
        self.dueDate = dueDate
        self.location = location
        self.category = category
        self.isDone = isDone
    }
}
