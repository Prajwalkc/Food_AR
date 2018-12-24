//
//  ItemsCollectionViewCell.swift
//  TestAr
//
//  Created by Prajwal Kc on 11/6/18.
//  Copyright © 2018 ekBana. All rights reserved.
//

import UIKit
import ARKit

class ItemsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemsName: UILabel!
    var selectedNodeName : String?
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.itemsName.textColor = #colorLiteral(red: 0.8062093854, green: 0.2654539943, blue: 0.4277614355, alpha: 1)
                self.itemImage.tintColor = #colorLiteral(red: 0.8062093854, green: 0.2654539943, blue: 0.4277614355, alpha: 1)
               
                
            } else {
                self.itemsName.textColor = #colorLiteral(red: 0.4398320913, green: 0.4401865005, blue: 0.4398869872, alpha: 1)
                 self.itemImage.tintColor = #colorLiteral(red: 0.4398320913, green: 0.4401865005, blue: 0.4398869872, alpha: 1)
                
//                self.itemImage.image = UIImage(named: "\(String(describing: selectedNodeName))" )
                //self.itemImage.image = itemImage.image?.setImageColor(color: UIColor.clear)
            }
        }
    }
    
    
    
    func itemSelected(nodeName : String) {
        self.isSelected = true
        self.selectedNodeName = nodeName
//        self.itemImage.image = UIImage(named: "\(String(describing: selectedNodeName))" )?.setImageColor()
    }
}

extension UIImage {
    func setImageColor() -> UIImage {
        let templateImage = self.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        let image = templateImage
//        self.tintColor = color
        return image
    }
}
