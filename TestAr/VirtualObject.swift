//
//  VirtualObject.swift
//  TestAr
//
//  Created by Prajwal Kc on 11/15/18.
//  Copyright © 2018 ekBana. All rights reserved.
//

import Foundation
import ARKit

class VirtualObject: SCNReferenceNode {
   
    
    
  
    /// The model name derived from the `referenceURL`.
    var modelName: String {
        return referenceURL.lastPathComponent.replacingOccurrences(of: ".scn", with: "")
    }
    
    /// Use average of recent virtual object distances to avoid rapid changes in object scale.
    private var recentVirtualObjectDistances = [Float]()
    
    /// Resets the object's position smoothing.
    func reset() {
        recentVirtualObjectDistances.removeAll()
    }
    /// The object's corresponding ARAnchor
    var anchor: ARAnchor?
    
    
    //Load all object within the project of the path of the extension .scn
    
    static let avialableObjects : [VirtualObject] = {
       let modelsUrl = Bundle.main.url(forResource: "art.scnassets", withExtension: nil)!
        let fileEmurator = FileManager().enumerator(at: modelsUrl, includingPropertiesForKeys: [])!
        return fileEmurator.compactMap({ (element)  in
            let url = element as! URL
            guard url.pathExtension == "scn" else { return nil }
            return VirtualObject(url: url)
            
        })
   }()
    
    
    /// Returns a `VirtualObject` if one exists as an ancestor to the provided node.
    static func existingObjectContainingNode(_ node: SCNNode) -> VirtualObject? {
        if let virtualObjectRoot = node as? VirtualObject {
            return virtualObjectRoot
        }
        
        guard let parent = node.parent else { return nil }
        
        // Recurse up to check if the parent is a `VirtualObject`.
        return existingObjectContainingNode(parent)
    }
    
    
    /// - Tag: AdjustOntoPlaneAnchor
    func adjustOntoPlaneAnchor(_ anchor: ARPlaneAnchor, using node: SCNNode) {
        // Test if the alignment of the plane is compatible with the object's allowed placement
        if anchor.alignment != .horizontal {
            return
        }
        
        // Get the object's position in the plane's coordinate system.
        let planePosition = node.convertPosition(position, from: parent)
        
        // Check that the object is not already on the plane.
        guard planePosition.y != 0 else { return }
        
        // Add 10% tolerance to the corners of the plane.
        let tolerance: Float = 0.1
        
        let minX: Float = anchor.center.x - anchor.extent.x / 2 - anchor.extent.x * tolerance
        let maxX: Float = anchor.center.x + anchor.extent.x / 2 + anchor.extent.x * tolerance
        let minZ: Float = anchor.center.z - anchor.extent.z / 2 - anchor.extent.z * tolerance
        let maxZ: Float = anchor.center.z + anchor.extent.z / 2 + anchor.extent.z * tolerance
        
        guard (minX...maxX).contains(planePosition.x) && (minZ...maxZ).contains(planePosition.z) else {
            return
        }
        
        // Move onto the plane if it is near it (within 5 centimeters).
        let verticalAllowance: Float = 0.05
        let epsilon: Float = 0.001 // Do not update if the difference is less than 1 mm.
        let distanceToPlane = abs(planePosition.y)
        if distanceToPlane > epsilon && distanceToPlane < verticalAllowance {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = CFTimeInterval(distanceToPlane * 500) // Move 2 mm per second.
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            position.y = anchor.transform.columns.3.y
          //  updateAlignment(to: anchor.alignment, transform: simdWorldTransform, allowAnimation: false)
            SCNTransaction.commit()
        }
    }
    
}
