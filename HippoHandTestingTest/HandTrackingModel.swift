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

/// Maintains app-wide state

@MainActor
@Observable
final class HandTrackingModel {
    struct HandsUpdates {
        var left: HandAnchor?
        var right: HandAnchor?
    }
    
    var handTracking = HandTrackingProvider()
    var latestHandTracking: HandsUpdates = .init(left: nil, right: nil)
    var myHandAnchor = ModelEntity()
    var lerpFactor: CGFloat = 1.0
    var isHandTracked: Bool = false
    var isPalmDown: Bool = false
    var attachmentEntity: ViewAttachmentEntity?
    var palmDownAttachmentEntity: ViewAttachmentEntity?
    var attachmentParent = Entity()
    let session = ARKitSession()
    
    func start() async {
        do {
            if HandTrackingProvider.isSupported {
                print("ARKitSession starting.")
                try await session.run([handTracking])
            }
        } catch {
            print("ARKitSession error:", error)
        }
    }
    
    func publishHandTrackingUpdates() async {
        for await update in handTracking.anchorUpdates {
            switch update.event {
            case .updated:
                let anchor = update.anchor
                guard anchor.isTracked else { continue }
                if anchor.chirality == .left {
                    latestHandTracking.left = anchor
                    updateHandMenuVisibility(for: latestHandTracking.left)
                }
            default:
                break
            }
        }
    }
    
    func updateHandMenuVisibility(for handAnchor: HandAnchor?) {
        guard let handAnchor = handAnchor,
              let handLocation = getLeftHandPointPosition(handAnchor: handAnchor) else {
            print("❌ No hand anchor or location available")
            return
        }
        
        myHandAnchor.setTransformMatrix(handLocation, relativeTo: nil)
        updateEntityPositionUsingLerp(entityAttachment: attachmentParent, target: myHandAnchor)
        
        // Check for palm facing forward
        isHandTracked = checkHandRotation(myHandAnchor.transform.rotation.axis)
        attachmentEntity?.isEnabled = isHandTracked
        
        // Check for palm facing down
        isPalmDown = checkPalmDownRotation(myHandAnchor.transform.rotation.axis)
        palmDownAttachmentEntity?.isEnabled = isPalmDown
        
        // Debug prints
        print("📱 Hand Tracking Debug:")
        print("   - Hand Tracked: \(isHandTracked)")
        print("   - Palm Down: \(isPalmDown)")
        print("   - Rotation Axis: \(myHandAnchor.transform.rotation.axis)")
        print("   - Palm Down Entity Enabled: \(palmDownAttachmentEntity?.isEnabled ?? false)")
    }
    
    private func checkHandRotation(_ axis: SIMD3<Float>) -> Bool {
        let front = axis.x.isBetween(-0.2, 0.8) && axis.y.isBetween(-0.4, 0.9) && axis.z.isBetween(-0.2, 1)
        print("🖐️ Palm Forward Check:")
        print("   - X: \(axis.x) isBetween -0.2 and 0.8: \(axis.x.isBetween(-0.2, 0.8))")
        print("   - Y: \(axis.y) isBetween -0.4 and 0.9: \(axis.y.isBetween(-0.4, 0.9))")
        print("   - Z: \(axis.z) isBetween -0.2 and 1: \(axis.z.isBetween(-0.2, 1))")
        return front
    }
    
    private func checkPalmDownRotation(_ axis: SIMD3<Float>) -> Bool {
        // Adjusted values to detect when palm is completely facing down
        let palmDown = axis.x.isBetween(0.7, 1.0) &&
                      axis.y.isBetween(0.3, 0.7) &&
                      axis.z.isBetween(-0.7, -0.3)
        print("👇 Palm Down Check:")
        print("   - X: \(axis.x) isBetween 0.7 and 1.0: \(axis.x.isBetween(0.7, 1.0))")
        print("   - Y: \(axis.y) isBetween 0.3 and 0.7: \(axis.y.isBetween(0.3, 0.7))")
        print("   - Z: \(axis.z) isBetween -0.7 and -0.3: \(axis.z.isBetween(-0.7, -0.3))")
        return palmDown
    }
    
    func getLeftHandPointPosition(handAnchor: HandAnchor?) -> simd_float4x4? {
        guard let handAnchor = handAnchor else { return nil }
        let pos = handAnchor.handSkeleton?.joint(.wrist)
        return handAnchor.originFromAnchorTransform * pos!.anchorFromJointTransform
    }
    
    func updateEntityPositionUsingLerp(entityAttachment: Entity, target: Entity, lerpFactor: Float = 0.1) {
            let currentTransform = entityAttachment.transform
            let targetTransform = target.transform

            // Linearly interpolate position
            let newPosition = simd_mix(currentTransform.translation, targetTransform.translation, simd_float3(repeating: lerpFactor))
            // Optionally, interpolate rotation and scale as well if needed

            var newTransform = currentTransform
            newTransform.translation = newPosition
            entityAttachment.transform = newTransform
        }
}
private extension Float {
    func isBetween(_ min: Float, _ max: Float) -> Bool {
        return self >= min && self <= max
    }
}
