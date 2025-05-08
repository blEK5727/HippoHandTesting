//
//  Task.swift
//  HippoHandTestingTest
//
//  Created by Esther Kim on 5/7/25.
//

import Foundation

struct TaskItem: Identifiable, Codable, Hashable {
    let id = UUID()
    var title: String
    var description: String
    var location: String
    var tag: String
    var date: Date
    var startTime: Date
    var endTime: Date
    var type: TaskType
    
    enum TaskType: String, CaseIterable, Identifiable, Codable {
        case task = "Task"
        case event = "Event"
        case list = "List"
        var id: String { rawValue }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TaskItem, rhs: TaskItem) -> Bool {
        lhs.id == rhs.id
    }
}
