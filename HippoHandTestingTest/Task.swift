//
//  Task.swift
//  HippoHandTestingTest
//
//  Created by Esther Kim on 5/7/25.
//

import Foundation

struct TaskItem: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var location: String
    var tag: String
    var date: Date
    var startTime: Date
    var endTime: Date
    var type: TaskType
    
    enum TaskType: String, CaseIterable, Identifiable {
        case task = "Task"
        case event = "Event"
        case list = "List"
        var id: String { rawValue }
    }
} 
