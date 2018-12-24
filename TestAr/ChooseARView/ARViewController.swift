//
//  ARViewController.swift
//  TestAr
//
//  Created by Prajwal Kc on 11/6/18.
//  Copyright © 2018 ekBana. All rights reserved.
//

import UIKit
import ARKit


class ARViewController: UIViewController  , ARSCNViewDelegate{

  
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var itemCollectionView: UICollectionView!
      var focusSquare = FocusSquare()
    
 
    private var newAngleY :Float = 0.0
    private var currentAngleY :Float = 0.0
    var position :SCNVector3?
    var count = 0
 
    var mainNode = SCNNode()
    var nodes : [ThreeDModel] = []
     var menu : [String] = []
    
    var selectedNodeIndex : Int? {
        didSet{
            if let index = selectedNodeIndex {
                let node = nodes[index]
              
                mainNode.enumerateChildNodes { (node, stop) in
                    node.removeFromParentNode()
                }
               
                addNode(node: node)
            }
            
        }
        
    }
    var sceneNodes = [SceneObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerGesture()
        self.infoLbl.text = ""
        self.itemCollectionView.delegate = self
        self.itemCollectionView.dataSource = self
        self.navigationItem.title = "MENU AR"
        self.itemCollectionView.isHidden = true
    
        
        //        let timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        
        // Create a new scene
        let scene = SCNScene()
   
        // Set the scene to the view
        sceneView.scene = scene
//        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.delegate = self
        let burgerNode = ThreeDModel(url: AssetConstants.burgerUrl, identifier: AssetConstants.burgerIdentifier, scale: AssetConstants.burgerScale)
        let pizzaNode = ThreeDModel(url: AssetConstants.pizzaUrl, identifier: AssetConstants.pizzaIdentifier, scale: AssetConstants.pizzaScale)
        let momoNode = ThreeDModel(url: AssetConstants.momoUrl, identifier: AssetConstants.momoIdentifier, scale: AssetConstants.momoScale)
        let paisaNode = ThreeDModel(url: AssetConstants.paisaaaUrl, identifier: AssetConstants.paisaaaIdentifier, scale: AssetConstants.paisaScale)
        let cokeNode = ThreeDModel(url: AssetConstants.cokeUrl, identifier: AssetConstants.cokeIdentifier, scale: AssetConstants.cokeScale)
        let fries = ThreeDModel(url: AssetConstants.friesUrl, identifier: AssetConstants.friesIdentifier, scale: AssetConstants.friesScale)
      //  let friesNode = SceneObject(model: fries)
        
        
        nodes  = [burgerNode,pizzaNode,momoNode,cokeNode,paisaNode,fries]
        
        sceneView.automaticallyUpdatesLighting = true
        
        menu = nodes.map({ $0.identifier ?? ""})
        
       
        
        
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.navigationController?.navigationBar.isHidden = false
        // Create a session configuration
     let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        configuration.isAutoFocusEnabled = true
        configuration.isLightEstimationEnabled = true
        
        // Run the view's session
        sceneView.session.run(configuration)
        
    }
    
    private func registerGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGesture)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned))
        self.sceneView.addGestureRecognizer(panGestureRecognizer)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinched))
        self.sceneView.addGestureRecognizer(pinchGesture)
    }
 
    
    @objc func pinched(recognizer : UIPinchGestureRecognizer) {
        
        if recognizer.state == .changed {
            guard let pinchSceneView = recognizer.view as? ARSCNView else {
                return
            }
            let touch = recognizer.location(in: pinchSceneView)
            let hitTestResults = self.sceneView.hitTest(touch, options: nil)
            
            if let hitTest = hitTestResults.first{
                let itemNode = hitTest.node
                if hitTest.node.name == "Plate" {
                let pinchScaleX = Float(recognizer.scale) * itemNode.scale.x
                let pinchScaleY = Float(recognizer.scale) * itemNode.scale.y
                let pinchScaleZ = Float(recognizer.scale) * itemNode.scale.z
                
                itemNode.scale = SCNVector3(x: pinchScaleX, y: pinchScaleY, z: pinchScaleZ)
                
                recognizer.scale = 1
                }
                
                
            }
            
        }
        
    }
    
    @objc func panned(recognizer :UIPanGestureRecognizer) {
        
        if recognizer.state == .changed {
            
            guard let sceneView = recognizer.view as? ARSCNView else {
                return
            }
            
            let touch = recognizer.location(in: sceneView)
            let translation = recognizer.translation(in: sceneView)
            
            let hitTestResults = self.sceneView.hitTest(touch, options: nil)
            
            if let hitTest = hitTestResults.first {
//
                if hitTest.node.name == "Plate" {
                self.newAngleY = Float(translation.x) * (Float) (Double.pi)/180
                self.newAngleY += self.currentAngleY
                hitTest.node.eulerAngles.y = self.newAngleY
            }
//                if let parentNode = hitTest.node.parent {
//
//                    self.newAngleY = Float(translation.x) * (Float) (Double.pi)/180
//                    self.newAngleY += self.currentAngleY
//                    parentNode.eulerAngles.y = self.newAngleY
//
//                }
              
            }
            
        }
        else if recognizer.state == .ended {
            self.currentAngleY = self.newAngleY
        }
    }
    @objc func tapped(recognizer : UITapGestureRecognizer){
        guard let TapSceneView = recognizer.view as? ARSCNView  else {
            return
        }
        let touch = recognizer.location(in: TapSceneView)
        TapSceneView.addSubview(UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)))
        let hitTestResults = TapSceneView.hitTest(touch, types: .existingPlane)
        if let hitTest = hitTestResults.first{
            self.initializeNodes()
            mainNode.position = SCNVector3(hitTest.worldTransform.columns.3.x, hitTest.worldTransform.columns.3.y, hitTest.worldTransform.columns.3.z)

        }
    }
    func initializeNodes(){
        DispatchQueue.main.async {
            self.itemCollectionView.isHidden = false
        }
       
        self.selectedNodeIndex = 0
       
    }
    private func addNode( node : ThreeDModel){
       let reqNode = SceneObject(model: node)
       reqNode.transform = SCNMatrix4MakeRotation(Float(Double.pi / 2.0), 1.0, 0.0, 0.0)
        mainNode.addChildNode(reqNode)
        
    }
 

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
       
        if count == 0 {
        if anchor is ARPlaneAnchor{
         print("Plane Detected")
           
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            
            // 2
       
            
            let plane = SCNPlane(width: 0.3, height: 0.3)
           plane.cornerRadius = 5
            let torus = SCNTorus(ringRadius: 0.2, pipeRadius: 0.1)
            
           
           
            // 3
            torus.materials.first?.diffuse.contents = UIColor.lightText
            plane.materials.first?.diffuse.contents = UIColor.lightText
            
            // 4
            mainNode = SCNNode(geometry: torus)
            let planeNode = SCNNode(geometry: plane)
            planeNode.name = "Plate"
        
            // 5
            let x = CGFloat(planeAnchor.center.x)
            let y = CGFloat(planeAnchor.center.y)
            let z = CGFloat(planeAnchor.center.z)
            
            position = SCNVector3(x,y,z)
            mainNode.position = position ?? SCNVector3()
            planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: plane, options: nil))
           mainNode = planeNode
        //  shapeNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2.0), 1.0, 0.0, 0.0)
             planeNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2.0), 1.0, 0.0, 0.0)
           // mainNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2.0), 0.0, 0.0, 0.0)
            node.addChildNode(planeNode)
            
            self.initializeNodes()
       }
        }
        count = count + 1
    }
 
    
  
}
extension ARViewController : UICollectionViewDelegate ,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collection = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuCollectionViewCell
        collection.itemName.text = menu[indexPath.row]
        return collection
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedNodeIndex != indexPath.row {
            selectedNodeIndex = indexPath.row
        }
        
    }
    
    
}
