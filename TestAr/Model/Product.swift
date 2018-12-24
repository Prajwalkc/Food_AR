//
//  Product.swift
//  TestAr
//
//  Created by Prajwal Kc on 12/17/18.
//  Copyright © 2018 ekBana. All rights reserved.
//

import Foundation
import ARKit
class Product {
    var itemPrice : String?
    var itemName : String?
    var itemMore : String?
    var itemRate : Double?
    var itemSelectedAmount : String?
    var itemNode : SCNNode?
    
    init(itemPrice : String , itemName : String , itemMore : String , itemRate : Double , itemSelectedAmount : String , itemNode : SCNNode?) {
        self.itemName = itemName
        self.itemMore = itemMore
        self.itemNode = itemNode
        self.itemRate = itemRate
        self.itemPrice = itemPrice
        self.itemSelectedAmount = itemSelectedAmount
    }
    
}
