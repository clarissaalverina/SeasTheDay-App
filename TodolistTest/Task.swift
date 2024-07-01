//
//  Task.swift
//  TodolistTest
//
//  Created by Vincent Senjaya on 19/06/24.
//

import Foundation
import SwiftData

@Model
class Task {
    var title: String
    var isCompleted: Bool
    var details: String
    var date: Date
    var priority: Int
    
    init(title: String = "", isCompleted: Bool = false, details: String = "", date: Date = .now, priority: Int = 0) {
        self.title = title
        self.isCompleted = isCompleted
        self.details = details
        self.date = date
        self.priority = priority
    }
}
