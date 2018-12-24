//
//  Model.swift
//  TestAr
//
//  Created by Prajwal Kc on 12/11/18.
//  Copyright © 2018 ekBana. All rights reserved.
//

import Foundation
import RealmSwift

class Items : Object, Decodable {  
    
    @objc dynamic var folderName : String?
    @objc dynamic var modelName : String?
    @objc dynamic var modelUrl : String?
    @objc dynamic var desc : String?
    @objc dynamic var rate : String?
    @objc dynamic var selectedAmount : String?
    @objc dynamic var textureName : String?
    @objc dynamic var price : String?
    @objc dynamic var identifier : String?

   
}
