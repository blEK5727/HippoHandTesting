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
    @State private var currentCardIndex = 0

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView(handTrackingModel: handTrackingModel, currentCardIndex: $currentCardIndex)
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
        
        WindowGroup(id: "spaceWindow", for: TaskItem.self) { $task in
            if let task = task {
                SpaceWindowView(task: task, isPresented: .constant(true), currentCardIndex: $currentCardIndex)
                    .background(.clear)
            }
        }
        .windowResizability(.contentSize)

    }
}
