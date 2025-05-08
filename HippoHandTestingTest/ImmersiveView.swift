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
                    //.frame(width: 400, height: 600)
                    //.glassBackgroundEffect()
                    .buttonStyle(.plain)
            }
            
            Attachment(id: "palm_down") {
                PalmDownView(task: TaskItem(
                    title: "Sample Task",
                    description: "This is a sample task",
                    location: "Sample Location",
                    tag: "Sample Tag",
                    date: Date(),
                    startTime: Date(),
                    endTime: Date().addingTimeInterval(3600),
                    type: .task
                ))
                    //.frame(width: 400, height: 600)
                    //.glassBackgroundEffect()
            }
        }.onAppear() {
            Task {
                await handTrackingModel.start()
                await handTrackingModel.publishHandTrackingUpdates()
            }
        }
    }
}

#Preview() {
    ImmersiveView(handTrackingModel: HandTrackingModel())
        .environment(HandTrackingModel())
}
