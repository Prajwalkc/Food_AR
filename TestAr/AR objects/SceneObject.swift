//
//  SceneObject.swift
//  TestAr
//
//  Created by Prajwal Kc on 10/31/18.
//  Copyright © 2018 ekBana. All rights reserved.
//

import Foundation
import ARKit

class SceneObject: SCNNode {
    
    
    
    init(model : ThreeDModel ) {
        super.init()
        guard let objectScene = SCNScene(named: model.url ?? "")
            , let objectNode = objectScene.rootNode.childNode(withName: model.identifier ?? "", recursively: true)
            else {
                return
        }
        
//       
//        let rotateOne = SCNAction.rotateBy(x: 0, y: CGFloat(2.1), z: 0, duration: 8.0)
//        let repeatForever = SCNAction.repeatForever(rotateOne)
//        objectNode.runAction(repeatForever)
        objectNode.scale = model.scale ?? SCNVector3(0, 0, 0)
  
//        //1. Get The Bounding Box Of The Node
//        let minimum = float3(objectNode.boundingBox.min)
//        let maximum = float3(objectNode.boundingBox.max)
//
//        //2. Set The Translation To Be Half Way Between The Vector
//        let translation = (maximum - minimum) * 0.5
//
//        //3. Set The Pivot
//        objectNode.pivot = SCNMatrix4MakeTranslation(translation.x, translation.y, translation.z)
        self.addChildNode(objectNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// - Tag: AdjustOntoPlaneAnchor
    func adjustOntoPlaneAnchor(_ anchor: ARPlaneAnchor, using node: SCNNode) {
        // Test if the alignment of the plane is compatible with the object's allowed placement
     
        
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
