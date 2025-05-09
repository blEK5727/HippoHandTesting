//
//  TaskManager.swift
//  HippoHandTestingTest
//
//  Created by Esther Kim on 5/7/25.
//


import Foundation
import SwiftUI
import Combine

class TaskManager: ObservableObject {
    static let shared = TaskManager()
    
    @Published var tasks: [TaskItem] = [
        TaskItem(
            title: "Pick up Nicole from School",
            description: "Don't forget to bring snacks",
            location: "Lombardo High School",
            tag: "Family",
            date: Date(),
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            type: .task
        ),
        TaskItem(
            title: "Team Meeting",
            description: "Discuss Q2 goals",
            location: "Conference Room A",
            tag: "Work",
            date: Date(),
            startTime: Date().addingTimeInterval(7200),
            endTime: Date().addingTimeInterval(10800),
            type: .event
        ),
        TaskItem(
            title: "Grocery Shopping",
            description: "Get ingredients for dinner",
            location: "Whole Foods",
            tag: "Personal",
            date: Date(),
            startTime: Date().addingTimeInterval(14400),
            endTime: Date().addingTimeInterval(18000),
            type: .list
        )
    ]
    
    @Published var unshownTasks: [TaskItem] = []
    
    init() {
        // Initialize unshownTasks with all tasks
        unshownTasks = tasks
    }
    
    func addTask(_ task: TaskItem) {
        tasks.insert(task, at: 0)
        unshownTasks.insert(task, at: 0)
    }
    
    func removeTask(at index: Int) {
        tasks.remove(at: index)
    }
    
    func updateTask(_ task: TaskItem, at index: Int) {
        tasks[index] = task
    }
    
    func markTaskAsShown(_ task: TaskItem) {
        if let index = unshownTasks.firstIndex(where: { $0.id == task.id }) {
            unshownTasks.remove(at: index)
        }
    }
    
    func getNextUnshownTask() -> TaskItem? {
        return unshownTasks.first
    }
}
