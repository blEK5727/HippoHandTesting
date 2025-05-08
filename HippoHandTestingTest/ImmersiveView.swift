//
//  ImmersiveView.swift
//  HippoHandTestingTest
//
//  Created by Esther Kim on 5/5/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @State var handTrackingModel: HandTrackingModel
    @StateObject private var taskManager = TaskManager.shared
    @Binding var currentCardIndex: Int
    
    var body: some View {
        RealityView { content, attachments in
            content.add(handTrackingModel.myHandAnchor)
            content.add(handTrackingModel.attachmentParent)
            
            if let attachment_hand_Menu = attachments.entity(for: "hand_menu") {
                content.add(attachment_hand_Menu)
                attachment_hand_Menu.scale = [0.6, 0.6, 0.6]
                attachment_hand_Menu.position = handTrackingModel.attachmentParent.position
                handTrackingModel.attachmentEntity = attachment_hand_Menu
                handTrackingModel.attachmentParent.addChild(handTrackingModel.attachmentEntity!)
            }
            
            if let attachment_palm_down = attachments.entity(for: "palm_down") {
                content.add(attachment_palm_down)
                attachment_palm_down.scale = [0.6, 0.6, 0.6]
                attachment_palm_down.position = handTrackingModel.attachmentParent.position
                handTrackingModel.palmDownAttachmentEntity = attachment_palm_down
                handTrackingModel.attachmentParent.addChild(handTrackingModel.palmDownAttachmentEntity!)
            }
        }
        attachments: {
            Attachment(id: "hand_menu") {
                HandMenuView()
                    .buttonStyle(.plain)
            }
            
            Attachment(id: "palm_down") {
                Group {
                    if let task = taskManager.tasks[safe: currentCardIndex] {
                        PalmDownView(task: task, currentCardIndex: $currentCardIndex)
                            .id("\(currentCardIndex)-\(task.id)") // Force view update with unique ID
                    } else {
                        PalmDownView(task: TaskItem(
                            title: "No Tasks",
                            description: "Add a task to see it here",
                            location: "",
                            tag: "",
                            date: Date(),
                            startTime: Date(),
                            endTime: Date().addingTimeInterval(3600),
                            type: .task
                        ), currentCardIndex: $currentCardIndex)
                    }
                }
                .onChange(of: currentCardIndex) { oldValue, newValue in
                    print("currentCardIndex changed from \(oldValue) to \(newValue)")
                }
            }
        }
        .onAppear() {
            Task {
                await handTrackingModel.start()
                await handTrackingModel.publishHandTrackingUpdates()
            }
        }
    }
}

// Extension to safely access array elements
extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview() {
    ImmersiveView(handTrackingModel: HandTrackingModel(), currentCardIndex: .constant(0))
        .environment(HandTrackingModel())
}
