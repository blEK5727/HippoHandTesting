//
//  HandMenuUI.swift
//  HippoHandTestingTest
//
//  Created by Esther Kim on 5/5/25.
//

import SwiftUI

struct HandMenuView: View {
    @State private var taskManager = TaskManager.shared
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var showingAddTask = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        ForEach(Array(taskManager.tasks.enumerated()), id: \.element.id) { index, task in
                            let distance = CGFloat(index) - CGFloat(currentIndex) + (dragOffset / geometry.size.width)
                            
                            PalmDownView(task: task)
                                .frame(width: geometry.size.width * 0.9, height: 200)
                                .scaleEffect(1.0 - abs(distance) * 0.15)
                                .opacity(1.0 - abs(distance) * 0.5)
                                .offset(z: -abs(distance) * 50)
                                .animation(.spring(response: 0.3), value: currentIndex)
                        }
                    }
                    .offset(x: -CGFloat(currentIndex) * (geometry.size.width * 0.9 + 20) + dragOffset + (geometry.size.width * 0.05))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation.width
                            }
                            .onEnded { value in
                                let threshold = geometry.size.width * 0.2
                                if value.translation.width > threshold && currentIndex > 0 {
                                    withAnimation {
                                        currentIndex -= 1
                                    }
                                } else if value.translation.width < -threshold && currentIndex < taskManager.tasks.count - 1 {
                                    withAnimation {
                                        currentIndex += 1
                                    }
                                }
                                dragOffset = 0
                            }
                    )
                }
                .frame(width: 300, height: 200)
                
                // Add the row of 3 buttons below the cards
                HStack(spacing: 32) {
                    Button(action: {}) {
                        Image(systemName: "book.closed") // Contact icon
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.black.opacity(0.7))
                            .frame(width: 48, height: 48)
                            .background(Color.white.opacity(0.6))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    Button(action: {}) {
                        Image(systemName: "moon.stars") // Moon icon
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.black.opacity(0.7))
                            .frame(width: 48, height: 48)
                            .background(Color.white.opacity(0.6))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    Button(action: {
                        showingAddTask = true
                    }) {
                        Image(systemName: "plus") // Plus icon
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(.black.opacity(0.7))
                            .frame(width: 48, height: 48)
                            .background(Color.white.opacity(0.6))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 8)
                // Center the buttons
                .frame(maxWidth: .infinity)
            }
            .padding()
            
            if showingAddTask {
                AddTaskView(taskManager: taskManager, isPresented: $showingAddTask)
                    .frame(width: 600, height: 600)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .preferredColorScheme(.light)
            }
        }
    }
}

#Preview() {
    HandMenuView()
}
