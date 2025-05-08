//
//  AddTaskView.swift
//  HippoHandTestingTest
//
//  Created by Esther Kim on 5/7/25.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    let taskManager: TaskManager
    @Binding var isPresented: Bool
    
    @State private var taskTitle: String = ""
    @State private var taskDescription: String = ""
    @State private var taskLocation: String = ""
    @State private var taskTag: String = ""
    @State private var taskDate: Date = Date()
    @State private var taskStartTime: Date = Date()
    @State private var taskEndTime: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    @State private var selectedType: TaskItem.TaskType = .task
    @FocusState private var focusedField: Field?
    
    enum Field {
        case title, description, location, tag
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Title
            TextField("Add title", text: $taskTitle)
                .font(.system(size: 28, weight: .bold))
                .focused($focusedField, equals: .title)
                .foregroundStyle(.black)
                .padding(.top, 24)
            Divider()
                .padding(.trailing, 16)
            // Custom Type Selector
            HStack(spacing: 12) {
                ForEach(TaskItem.TaskType.allCases) { type in
                    Button(action: {
                        selectedType = type
                    }) {
                        Text(type.rawValue)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(selectedType == type ? .white : .gray)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedType == type ? Color(hex: "9485FF") : Color.gray.opacity(0.1))
                            )
                    }
                }
            }
            .padding(.trailing, 16)
            // Form Rows
            VStack(alignment: .leading, spacing: 20) {
                // Date & Time
                HStack(spacing: 16) {
                    Image(systemName: "clock")
                        .foregroundStyle(.gray)
                    DatePicker("Date", selection: $taskDate, displayedComponents: .date)
                        .labelsHidden()
                        .foregroundStyle(.black)
                        .colorScheme(.light)
                    HStack {
                        DatePicker("Start", selection: $taskStartTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .foregroundStyle(.black)
                            .colorScheme(.light)
                        Text("-")
                            .foregroundStyle(.secondary)
                        DatePicker("End", selection: $taskEndTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .foregroundStyle(.black)
                            .colorScheme(.light)
                    }
                }
                // Location
                HStack(spacing: 16) {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundStyle(.gray)
                    TextField("Add Location", text: $taskLocation)
                        .focused($focusedField, equals: .location)
                        .foregroundStyle(.black)
                        .tint(.black)
                }
                // Description
                HStack(spacing: 16) {
                    Image(systemName: "doc.text")
                        .foregroundStyle(.gray)
                    TextField("Add Description", text: $taskDescription)
                        .focused($focusedField, equals: .description)
                        .foregroundStyle(.black)
                        .tint(.black)
                }
                // Tag
                HStack(spacing: 16) {
                    Image(systemName: "tag")
                        .foregroundStyle(.gray)
                    TextField("Add Tag", text: $taskTag)
                        .focused($focusedField, equals: .tag)
                        .foregroundStyle(.black)
                        .tint(.black)
                }
            }
            .padding(.leading, 2)
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    if !taskTitle.isEmpty {
                        let newTask = TaskItem(
                            title: taskTitle,
                            description: taskDescription,
                            location: taskLocation,
                            tag: taskTag,
                            date: taskDate,
                            startTime: taskStartTime,
                            endTime: taskEndTime,
                            type: selectedType
                        )
                        taskManager.addTask(newTask)
                        focusedField = nil
                        isPresented = false
                    }
                }) {
                    Text("Add")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(taskTitle.isEmpty ? Color.gray : Color(hex: "9485FF"))
                        .cornerRadius(12)
                }
                .buttonStyle(.plain)
                .disabled(taskTitle.isEmpty)
            }
        }
        .padding(32)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        .padding()
        .preferredColorScheme(.light)
        .colorScheme(.light)
    }
}

#Preview {
    AddTaskView(taskManager: TaskManager(), isPresented: .constant(true))
        .preferredColorScheme(.light)
}
