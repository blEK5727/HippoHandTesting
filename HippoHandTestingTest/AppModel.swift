//
//  AppModel.swift
//  HippoHandTestingTest
//
//  Created by Esther Kim on 5/5/25.
//

import Foundation
import SwiftUI
import ARKit
import RealityKit

@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
}
