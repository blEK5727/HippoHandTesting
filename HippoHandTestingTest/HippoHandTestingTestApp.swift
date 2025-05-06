//
//  HippoHandTestingTestApp.swift
//  HippoHandTestingTest
//
//  Created by Esther Kim on 5/5/25.
//

import SwiftUI

@main
struct HippoHandTestingTestApp: App {

    @State private var appModel = AppModel()
    @State private var handTrackingModel = HandTrackingModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView(handTrackingModel: handTrackingModel)
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
     }
}
