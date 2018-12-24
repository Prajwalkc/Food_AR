//
//  AnimationViewController.swift
//  TestAr
//
//  Created by Prajwal Kc on 11/14/18.
//  Copyright © 2018 ekBana. All rights reserved.
//

import UIKit
import ARKit
class AnimationViewController: UIViewController , ARSCNViewDelegate{

    var width : CGFloat = 0.03
    var height : CGFloat = 1
    var length : CGFloat = 1
    
    var doorLength : CGFloat = 0.3
    
    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.delegate = self
        setupScene()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let configuration = ARWorldTrackingConfiguration()
        self.sceneView.session.run(configuration)
    }

    func setupScene() {
        let node = SCNNode()
        node.position = SCNVector3.init(0, 0, 0)
        
        let leftWall = createBox(isDoor: false)
        leftWall.position = SCNVector3.init((-length / 2) + width, 0, 0)
        leftWall.eulerAngles = SCNVector3.init(0, 180.0.degreesToRadians, 0)
        
        let rightWall = createBox(isDoor: false)
        rightWall.position = SCNVector3.init((length / 2) - width, 0, 0)
        
        let topWall = createBox(isDoor: false)
        topWall.position = SCNVector3.init(0, (height / 2) - width, 0)
        topWall.eulerAngles = SCNVector3.init(0, 0, 90.0.degreesToRadians)
        
        let bottomWall = createBox(isDoor: false)
        bottomWall.position = SCNVector3.init(0, (-height / 2) + width, 0)
        bottomWall.eulerAngles = SCNVector3.init(0, 0, -90.0.degreesToRadians)
        
        let backWall = createBox(isDoor: false)
        backWall.position = SCNVector3.init(0, 0, (-length / 2) + width)
        backWall.eulerAngles = SCNVector3.init(0, 90.0.degreesToRadians, 0)
        
        let leftDoorSide = createBox(isDoor: true)
        leftDoorSide.position = SCNVector3.init((-length / 2 + width) + (doorLength / 2), 0, (length / 2) - width)
        leftDoorSide.eulerAngles = SCNVector3.init(0, -90.0.degreesToRadians, 0)
        
        let rightDoorSide = createBox(isDoor: true)
        rightDoorSide.position = SCNVector3.init((length / 2 - width) - (doorLength / 2), 0, (length / 2) - width)
        rightDoorSide.eulerAngles = SCNVector3.init(0, -90.0.degreesToRadians, 0)
        
        //Create Light
        
        let light = SCNLight()
        light.type = .spot
        light.spotInnerAngle = 70
        light.spotOuterAngle = 120
        light.zNear = 0.00001
        light.zFar = 5
        light.castsShadow = true
        light.shadowRadius = 200
        light.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        light.shadowMode = .deferred
        let constraint = SCNLookAtConstraint(target: bottomWall)
        constraint.isGimbalLockEnabled = true
        
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3.init(0, 0.4, 0)
        lightNode.constraints = [constraint]
        node.addChildNode(lightNode)
      
       
        //Adding Nodes to Main Node
        node.addChildNode(leftWall)
        node.addChildNode(rightWall)
        node.addChildNode(topWall)
        node.addChildNode(bottomWall)
        node.addChildNode(backWall)
        node.addChildNode(leftDoorSide)
        node.addChildNode(rightDoorSide)

        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    func createBox(isDoor : Bool) -> SCNNode {
        let node = SCNNode()
        
        //Add First Box
        let firstBox = SCNBox(width: width, height: height, length: isDoor ? doorLength : length, chamferRadius: 0)
        firstBox.firstMaterial?.diffuse.contents = UIColor.white
        let firstBoxNode = SCNNode(geometry: firstBox)
        firstBoxNode.renderingOrder = 200
        
        node.addChildNode(firstBoxNode)
        
        //Add Masked Box
        let maskedBox = SCNBox(width: width, height: height, length: isDoor ? doorLength : length, chamferRadius: 0)
        maskedBox.firstMaterial?.diffuse.contents = UIColor.blue
        maskedBox.firstMaterial?.transparency = 0.000000001
        
        let maskedBoxNode = SCNNode(geometry: maskedBox)
        maskedBoxNode.renderingOrder = 100
        maskedBoxNode.position = SCNVector3.init(width, 0, 0)
        
        node.addChildNode(maskedBoxNode)
        
        return node
    }
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
       
       
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
