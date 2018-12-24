//
//  Menu.swift
//  TestAr
//
//  Created by Prajwal Kc on 11/20/18.
//  Copyright © 2018 ekBana. All rights reserved.
//

import Foundation
import ARKit
import RealmSwift

class Menu : Object , Decodable {
    
    @objc dynamic var name : String?
    @objc dynamic var icon : String?
    var items = List<Items>()
    
}

extension List: Decodable where List.Element: Decodable {
    public convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.singleValueContainer()
        let array = try container.decode([Element].self)
        self.append(objectsIn: array)
    }
}
