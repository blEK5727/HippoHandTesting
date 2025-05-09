//
//  TaskListView.swift
//  HippoHandTestingTest
//
//  Created by Esther Kim on 5/5/25.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var taskManager: TaskManager
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("All Tasks")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            List {
                ForEach(taskManager.tasks) { task in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(task.title)
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Text(task.description)
                            .font(.subheadline)
                            .foregroundColor(.black)
                        
                        if !task.tag.isEmpty {
                            Label {
                                Text(task.tag)
                                    .font(.subheadline)
                            } icon: {
                                Image(systemName: "tag")
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color(red: 244/255, green: 243/255, blue: 255/255))
                            .foregroundColor(Color(red: 148/255, green: 133/255, blue: 255/255))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        if !task.location.isEmpty {
                            Label {
                                Text(task.location)
                                    .font(.subheadline)
                            } icon: {
                                Image(systemName: "mappin.and.ellipse")
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color(red: 244/255, green: 243/255, blue: 255/255))
                            .foregroundColor(Color(red: 148/255, green: 133/255, blue: 255/255))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        HStack {
                            Label {
                                Text(task.date.formatted(date: .long, time: .omitted))
                                    .font(.subheadline)
                            } icon: {
                                Image(systemName: "calendar")
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color(red: 244/255, green: 243/255, blue: 255/255))
                            .foregroundColor(Color(red: 148/255, green: 133/255, blue: 255/255))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            Spacer()
                            
                            Label {
                                Text("\(task.startTime.formatted(date: .omitted, time: .shortened)) - \(task.endTime.formatted(date: .omitted, time: .shortened))")
                                    .font(.subheadline)
                            } icon: {
                                Image(systemName: "clock")
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color(red: 244/255, green: 243/255, blue: 255/255))
                            .foregroundColor(Color(red: 148/255, green: 133/255, blue: 255/255))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        Label {
                            Text(task.type.rawValue)
                                .font(.subheadline)
                        } icon: {
                            Image(systemName: "list.bullet")
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color(red: 244/255, green: 243/255, blue: 255/255))
                        .foregroundColor(Color(red: 148/255, green: 133/255, blue: 255/255))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(.vertical, 8)
                }
            }
            .listStyle(PlainListStyle())
        }
        .background(Color.white)
    }
}

#Preview {
    TaskListView(taskManager: TaskManager.shared, isPresented: .constant(true))
} 
