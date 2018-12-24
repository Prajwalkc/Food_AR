//
//  ViewController.swift
//  TestAr
//
//  Created by Prajwal Kc on 10/30/18.
//  Copyright © 2018 ekBana. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

fileprivate enum Swipe {
    case left
    case right
}


class ViewController: UIViewController {
  
    var lastNode = 0
    var mainNode = SCNNode()
    var nodes : [ThreeDModel] = []
    var sceneNodes: [SceneObject]?
    var nodesPosition : [SCNVector3]?
    private var swipeMode: Swipe?
    var gestureRecognizer : UISwipeGestureRecognizer?
    

    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var rightBtn: UIButton!
    
 
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
       // Set the view's delegate
        self.navigationItem.title = "ROTATION AR"
    
        
        // Show statistics such as fps and timing information
        // sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
       // sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints , ARSCNDebugOptions.showWorldOrigin]
        // Set the scene to the view
       sceneView.scene = scene
        setupUI()
        self.view.bringSubviewToFront(leftBtn)
         self.view.bringSubviewToFront(rightBtn)
       
        sceneView.automaticallyUpdatesLighting = true
        
      
        
        
       let burgerNode = ThreeDModel(url: AssetConstants.burgerUrl, identifier: AssetConstants.burgerIdentifier, scale: AssetConstants.burgerScale)
         let pizzaNode = ThreeDModel(url: AssetConstants.pizzaUrl, identifier: AssetConstants.pizzaIdentifier, scale: AssetConstants.pizzaScale)
        let momoNode = ThreeDModel(url: AssetConstants.momoUrl, identifier: AssetConstants.momoIdentifier, scale: AssetConstants.momoScale)
         let paisaNode = ThreeDModel(url: AssetConstants.paisaaaUrl, identifier: AssetConstants.paisaaaIdentifier, scale: AssetConstants.paisaScale)
        let fries = ThreeDModel(url: AssetConstants.friesUrl, identifier: AssetConstants.friesIdentifier, scale: AssetConstants.friesScale)
        //let friesNode = SceneObject(model: fries)
        nodes  = [burgerNode,pizzaNode,momoNode,paisaNode,fries]
        self.addNodes(nodes: nodes)
       
        //self.sceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:))))
        
    
    
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        // Create a session configuration
      let configuration = ARWorldTrackingConfiguration()
       
        configuration.isAutoFocusEnabled = true
        configuration.isLightEstimationEnabled = true
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    
    @objc func swipe(_ gestureRecognizer : UISwipeGestureRecognizer){
        switch gestureRecognizer.direction {
            case .left :
                rightRotate(rightBtn)
            case .right :
            leftSideRotate(leftBtn)
        default:
            break
        }
    }
    
    func setupGesture(){
        gestureRecognizer = UISwipeGestureRecognizer(target: self, action:#selector(swipe(_:)))
        let leftSwipe = UISwipeGestureRecognizer(target: self, action:#selector(swipe(_:)))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(gestureRecognizer!)
        self.view.addGestureRecognizer(leftSwipe)
        
        
    }
 
    func setupUI(){
        leftBtn.layer.cornerRadius = leftBtn.frame.width / 2
        rightBtn.layer.cornerRadius = rightBtn.frame.width / 2
        setupGesture()
        
    }
    
    @IBAction func leftSideRotate(_ sender: Any) {
        self.swipeMode = .left
       reArrangePosition()
    }
   
    
    @IBAction func rightRotate(_ sender: Any) {
        self.swipeMode = .right
        reArrangePosition()
    

        
    }
    
    private func reArrangePosition(){
        guard let swipeMode = self.swipeMode else { return}
        self.swipeMode = nil
        switch swipeMode {
        case .left:
            nodesPosition?.shiftRight()
        case .right:
            nodesPosition?.shiftLeft()
        }
        let _ = sceneNodes?.enumerated().map{$0.element.position = nodesPosition?[$0.offset] ?? SCNVector3(0, 0, 0)}
    }
    func addNodes( nodes : [ThreeDModel])  {
        let radius : Float = 0.6
        nodesPosition = [SCNVector3]()
        sceneNodes = [SceneObject]()
       
        let count = nodes.count
        for n in 0...count-1 {
            let angle = Float(360 / count) * Float(n)
            let angleRadian = angle.degreesToRadians
            let x = cos(angleRadian) * radius
            let z = sin(angleRadian) * radius
            let y : Float = 0.0
            let node = nodes[n]
     
            let sceneNode = SceneObject(model: node)
            
           
            sceneNode.position = SCNVector3(x, y, z)
            
            self.nodesPosition?.append(sceneNode.position)
            mainNode.addChildNode(sceneNode)
            self.sceneNodes?.append(sceneNode)
           
        }
        sceneView.scene.rootNode.addChildNode(mainNode)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
 

}
extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
extension Array {
    func shiftedLeft(by rawOffset: Int = 1) -> Array {
        let clampedAmount = rawOffset % count
        let offset = clampedAmount < 0 ? count + clampedAmount : clampedAmount
        return Array(self[offset ..< count] + self[0 ..< offset])
    }
    func shiftedRight(by rawOffset: Int = 1) -> Array {
        return self.shiftedLeft(by: -rawOffset)
    }
    
    mutating func shiftLeft(by rawOffset: Int = 1) {
        self = self.shiftedLeft(by: rawOffset)
    }
    
    mutating func shiftRight(by rawOffset: Int = 1) {
        self = self.shiftedRight(by: rawOffset)
    }
}

