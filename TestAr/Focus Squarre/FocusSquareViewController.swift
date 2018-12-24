//
//  FocusSquareViewController.swift
//  TestAr
//
//  Created by Prajwal Kc on 11/15/18.
//  Copyright © 2018 ekBana. All rights reserved.
//

import UIKit
import ARKit
import RealmSwift
import Toast_Swift

class FocusSquareViewController: UIViewController , ARSCNViewDelegate {
    
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var itermCollectionView: UICollectionView!
    @IBOutlet weak var sceneView: VirtualObjectARView!
    
    @IBOutlet weak var selectedItemCollectionView: UICollectionView!
    
    @IBAction func cancelBtn(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func openCartBtnAction(_ sender: Any) {
        //        let storyBoard = UIStoryboard(name: "AddToCart", bundle: nil)
        //        let addToCartVC = storyBoard.instantiateViewController(withIdentifier: "AddToCartViewController")
        //        self.present(addToCartVC, animated: true, completion: nil)
        //        
    }
    
    @IBOutlet weak var loadActivityView: UIActivityIndicatorView!
    @IBOutlet weak var numberofItemsInCart: UILabel!
    
    
    //MARK: - VARIABLES
    private var items : [Items] = []
    private var menus: [Menu] = []
    private var numberIncart : Int = 0
    private var loader = ModelLoader()
    private var newAngleY :Float = 0.0
    private var currentAngleY :Float = 0.0
    var isObjectVisible : Bool = false
    var nodes : [SCNNode] = []
    var focusSquare = FocusSquare()
    var menuItemsCount : Int?
    
    var screenCenter: CGPoint {
        let bounds = sceneView.bounds
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    var tapGesture = UITapGestureRecognizer()
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    var selectedNode : Int? {
        didSet{
            
            
            self.menus = readFromRealm()
            
            print("After reading from realm menu \(self.menus)")
            
            if let nodeIndex = selectedNode{
                self.removeAllChildNodes()
                
                if menus.count != 0 {
                    addNode(menuIndex: nodeIndex, itemIndex: 0)
                    self.menuItemsCount = menus[nodeIndex].items.count
                    self.itermCollectionView.isHidden = false
                    self.itermCollectionView.reloadData()
                    
                    self.selectedItemCollectionView.isHidden = false
                    self.selectedItemCollectionView.reloadData()
                } else {
                    self.itermCollectionView.isHidden = true
                    self.selectedItemCollectionView.isHidden = true
                    self.view.makeToast("No data found on database , Check your Internet Connection")
                    
                }
                
                
            }
            
        }
        
    }
    
    //MARK: - ADD NODES INTO SCENE
    
    func addNode(menuIndex : Int , itemIndex : Int){
        loadActivityView.startAnimating()
        let name = self.menus[menuIndex].items[itemIndex].desc
        self.infoLbl.textColor = UIColor.green
        self.infoLbl.text = name
        loader.downloadZip(model: (menus[menuIndex].items[itemIndex])) { (node) in
            print(node)
            DispatchQueue.main.async {
                if node != nil {
                    
                    node?.position = self.focusSquare.position
                    switch self.menus[menuIndex].name {
                    case "Burger" :
                        node?.scale = AssetConstants.burgerScale
                        break
                    case "Pizza" :
                        node?.scale = AssetConstants.pizzaScale
                        break
                    case "Sandwich" :
                        node?.scale = AssetConstants.sandwichScale
                        break
                    case "Momo" :
                        node?.scale = AssetConstants.momoScale
                        break
                    case "Fries" :
                        node?.scale = AssetConstants.friesScale
                        break
                        
                        
                    default:
                        break
                    }
                    
                    
                    self.loadActivityView.stopAnimating()
                    
                    
                    
                    
                    
                    self.sceneView.scene.rootNode.addChildNode(node!)
                    
                }
                else {
                    self.loadActivityView.stopAnimating()
                    self.view.makeToast("Please check your internet connection", duration: 1.5, point: self.screenCenter, title: "Could Not Load 3D Model", image: UIImage(named: "")) { didTap in
                        if didTap {
                            self.view.hideToast()
                        } else {
                            print("completion without tap")
                        }
                    }
                }
                
            }
        }
    }
    
    
    //MARK: - REMOVE ALL NODES FROM THE SCNENE
    func removeAllChildNodes() {
        let childNodes = sceneView.scene.rootNode.childNodes
        for node in childNodes {
            node.removeFromParentNode()
        }
        
    }
    
    
    //MARK: - VIEW LIFCYCLE
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.focusSquare.name = "FocusSquare"
        
        let scene = SCNScene()
        // sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints , ARSCNDebugOptions.showWorldOrigin]
        // Set the scene to the view
        sceneView.scene = scene
        
        sceneView.delegate = self
        
        self.itermCollectionView.delegate = self
        self.itermCollectionView.dataSource = self
        
        self.selectedItemCollectionView.delegate = self
        self.selectedItemCollectionView.dataSource = self
        
        self.numberofItemsInCart.isHidden = false
        
        // Set up scene content.
        setupCamera()
        registerGesture()
        getData()
        
        
        
        self.itermCollectionView.isHidden = false
        
        
        self.selectedItemCollectionView.isHidden = false
        
        
        // addItems()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isAutoFocusEnabled = true
        configuration.isLightEstimationEnabled = true
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    
    
    //MARK: - SET ITEMS
    
    
    func getData(){
        let url  = URL(string: "http://demo7961058.mockable.io/burgers")
        let configuaration = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: configuaration)
        let task = urlSession.dataTask(with: url!) { (data, res, err) in
            guard let data = data else { return }
            print(data)
            do {
                let values = try JSONDecoder().decode([Menu].self, from: data)
                print(values)
                self.addToRealm(value: values)
                
            }catch {
                print(error)
                print(err?.localizedDescription ?? "Error")
            }
            print("BreakPoint")
        }
        task.resume()
    }
    
    func addToRealm(value : [Object]){
        do{
            let realm = try Realm()
            try realm.write {
                realm.add(value)
            }
            print(realm.objects(Menu.self).count)
        }catch {
            print(error)
        }
        
    }
    
    func readFromRealm() -> [Menu] {
        
        do{
            let realm = try Realm()
            let values = realm.objects(Menu.self)
            print(values.count)
            return Array(values)
        }catch {
            print(error)
            return []
            
        }
        
    }
    
    //MARK: -  REGISTER GESTURE FUNCTIONS
    private func registerGesture(){
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned))
        self.sceneView.addGestureRecognizer(panGestureRecognizer)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinched))
        self.sceneView.addGestureRecognizer(pinchGesture)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func tapped(recognizer : UITapGestureRecognizer){
        
        if UserDefaults.standard.bool(forKey: "SurfaceDetected") {
            
            guard let sceneView = recognizer.view as? ARSCNView else {
                return
            }
            
            let touch = recognizer.location(in: sceneView)
            let results = self.sceneView.smartHitTest(touch)
            if let _ = results?.anchor as? ARPlaneAnchor {
                
                
                self.infoLbl.text = ""
                self.itermCollectionView.reloadData()
                self.itermCollectionView.isHidden = false
                self.selectedItemCollectionView.isHidden = false
                self.itermCollectionView.isHidden = false
                //menus[0].items?[0].itemNode?.position = self.focusSquare.position
                selectedNode = 0
                self.isObjectVisible = true
                self.sceneView.removeGestureRecognizer(tapGesture)
                
                
                
            } else {
                self.infoLbl.textColor = UIColor.red
                self.infoLbl.text = "FIND THE SUITABLE PLANE SURFACE TO ADD AN OBJECT"
                
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
                
                self.newAngleY = Float(translation.x) * (Float) (Double.pi)/180
                self.newAngleY += self.currentAngleY
                hitTest.node.eulerAngles.y = self.newAngleY
                
            }
            
        }
        else if recognizer.state == .ended {
            self.currentAngleY = self.newAngleY
        }
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
                let pinchScaleX = Float(recognizer.scale) * itemNode.scale.x
                let pinchScaleY = Float(recognizer.scale) * itemNode.scale.y
                let pinchScaleZ = Float(recognizer.scale) * itemNode.scale.z
                
                itemNode.scale = SCNVector3(x: pinchScaleX, y: pinchScaleY, z: pinchScaleZ)
                
                recognizer.scale = 1
                
                
                
            }
            
        }
        
    }
    
    // MARK: - SCENE CAMERA SETUP
    
    func setupCamera() {
        guard let camera = sceneView.pointOfView?.camera else {
            fatalError("Expected a valid `pointOfView` from the scene.")
        }
        
        /*
         Enable HDR camera settings for the most realistic appearance
         with environmental lighting and physically based materials.
         */
        camera.wantsHDR = true
        camera.exposureOffset = -1
        camera.minimumExposure = -1
        camera.maximumExposure = 3
    }
    
    
    // MARK: - SCENE VIEW DELEGATE
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        DispatchQueue.main.async {
            
            self.updateFocusSquare(isObjectVisible: self.isObjectVisible)
        }
    }
    
    
    
    
    // MARK: - Focus Square
    
    func updateFocusSquare(isObjectVisible: Bool) {
        if isObjectVisible {
            focusSquare.hide()
        } else {
            focusSquare.unhide()
            
        }
        
        if isObjectVisible == false {
            
            // Perform hit testing only when ARKit tracking is in a good state.
            if let camera = session.currentFrame?.camera, case .normal = camera.trackingState,
                let result = self.sceneView.smartHitTest(screenCenter) {
                self.infoLbl.textColor = UIColor.red
                self.infoLbl.text = "FIND THE SUITABLE PLANE SURFACE TO ADD AN OBJECT"
                self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
                self.focusSquare.state = .detecting(hitTestResult: result, camera: camera)
                if UserDefaults.standard.bool(forKey: "SurfaceDetected") {
                    
                    if let _ = result.anchor as? ARPlaneAnchor {
                        self.infoLbl.textColor = UIColor.green
                        self.infoLbl.text = "PLANE DETECTED . TAP IN THE SQUARE TO ADD AN OBJECT"
                    }
                }
            } else {
                
                self.focusSquare.state = .initializing
                self.sceneView.pointOfView?.addChildNode(self.focusSquare)
                self.infoLbl.text = "FIND THE PLANE"
                
                self.infoLbl.textColor = UIColor.red
                self.itermCollectionView.isHidden = true
                self.selectedItemCollectionView.isHidden = true
            }
        }
        
    }
    
    
    
}



extension FocusSquareViewController : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout , SelectedItemCollectionViewCellDelegate{
    
    
    //MARK: - DELEGATE BUTTON ACTION
    
    func btnAction(_sender: Any) {
        
        var amount = Int(self.menus[selectedNode!].items[selectedIndexPath.row].selectedAmount ?? "")
        if let send = _sender as? UIButton {
            if send.tag == 1 {
                amount = (amount ?? 0) + 1
                numberIncart += 1
                let realm = try! Realm()
                try! realm.write {
                    self.menus[selectedNode!].items[selectedIndexPath.row].selectedAmount = String(amount ?? 0)
                }
                
                self.numberofItemsInCart.text = "\(String(describing: numberIncart))"
                self.selectedItemCollectionView.reloadData()
            } else if send.tag == 0 {
                amount = amount ?? 0 <= 0 ? 0 : (amount ?? 0) - 1
                if amount ?? 0 >= 0 {
                    numberIncart = numberIncart <= 0 ? 0 : numberIncart - 1
                }
                
                let realm = try! Realm()
                try! realm.write {
                    self.menus[selectedNode!].items[selectedIndexPath.row].selectedAmount = String(amount ?? 0)
                }
                self.numberofItemsInCart.text = "\(String(describing: numberIncart))"
                self.selectedItemCollectionView.reloadData()
            }
            
        }
        
        
    }
    
    // MARK: - COLLECTION VIEW DELEGATES
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.itermCollectionView {
            return menus.count
        } else {
            return menuItemsCount ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //   let child = nodes[indexPath.row].childNodes
        if collectionView == self.itermCollectionView {
            let collection = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemsCollectionViewCell
            collection.itemImage.tintColor = #colorLiteral(red: 0.4398320913, green: 0.4401865005, blue: 0.4398869872, alpha: 1)
            
            collection.itemsName.text = menus[indexPath.row].name
            collection.itemImage.image = UIImage(named: menus[indexPath.row].icon ?? " ")?.setImageColor()
            
            return collection
        }
        else {
            
            let collection = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedItemCollectionViewCell", for: indexPath) as! SelectedItemCollectionViewCell
            if selectedNode != nil {
                collection.itemNamelbl.text = menus[selectedNode!].items[indexPath.row].modelName
                collection.itemPriceLbl.text =  menus[selectedNode!].items[indexPath.row].price!
                collection.itemInfoLbl.text =  menus[selectedNode!].items[indexPath.row].desc
                //   collection.itemRatingView.rating = Double(menus[selectedNode!].items?[indexPath.row].rate as! Double)
                collection.itemSelectedCount.text = menus[selectedNode!].items[indexPath.row].selectedAmount
                collection.delegate = self
                
            }
            
            return collection
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.itermCollectionView{
            let collection = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemsCollectionViewCell
            collection.isSelected = false
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.itermCollectionView {
            self.isObjectVisible = true
            self.infoLbl.text = ""
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            //  menus[indexPath.row].items?[selectedIndexPath.row].itemNode?.position = self.focusSquare.position
            self.selectedItemCollectionView.setContentOffset(.zero, animated: true)
            if indexPath.row != selectedNode {
                
                selectedNode = indexPath.row
            }
            
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.selectedItemCollectionView {
            if selectedNode != nil {
                let itemWidth =  UIScreen.main.bounds.width - 20
                switch UIScreen.main.nativeBounds.height {
                    
                case 1136:
                    // 5 5s
                    return CGSize(width:itemWidth,height:150)
                case 1334:
                    // 6 6s
                    return CGSize(width:itemWidth,height:150)
                case 1920:
                    
                    return CGSize(width:itemWidth, height: 150)
                case 2208:
                    // 6+ 6s+
                    return CGSize(width:itemWidth,height:150)
                    
                case 2436:
                    // X
                    return CGSize(width:itemWidth,height:150)
                    
                default:
                    return CGSize(width:itemWidth,height:150)
                }
                
            } else {
                return CGSize(width: 270, height: 150)
            }
        } else {
            return CGSize(width: 75, height: 60)
        }
    }
    //MARK: - COLLECTION VIEW SCROLL VIEW DELEGATES
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if let scrollCollectionView = scrollView as? UICollectionView {
            
            if scrollCollectionView == self.selectedItemCollectionView {
                
                self.selectedIndexPath = self.selectedItemCollectionView.calculateIndexPath()
                
                self.removeAllChildNodes()
                
                self.addNode(menuIndex: selectedNode ?? 0, itemIndex: selectedIndexPath.row)
            }
        }
    }
    
    
}

extension String {
    func calculateSize(withFont: UIFont, cellSize: CGFloat) -> CGSize {
        let text = self as NSString?
        let size = text?.size(withAttributes: [.font: withFont])
        let lines = ceil((size?.width ?? 0.0) / cellSize)
        print("Lines: \(lines)")
        return CGSize(width: cellSize, height: lines * (size?.height ?? 0))
    }
}
extension UICollectionView {
    
    func calculateIndexPath() -> IndexPath{
        
        var visibleRect = CGRect()
        
        visibleRect.origin = self.contentOffset
        visibleRect.size = self.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = self.indexPathForItem(at: visiblePoint) else { return IndexPath(row: 0, section: 0) }
        
        return indexPath
    }
}

