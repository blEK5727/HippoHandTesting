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
        }
        attachments: {
            Attachment(id: "hand_menu") {
                HandMenuView()
                    .frame(width: 400, height: 600)
                    .glassBackgroundEffect()
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
