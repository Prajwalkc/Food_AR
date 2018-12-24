//
//  Nodes.swift
//  TestAr
//
//  Created by Prajwal Kc on 11/2/18.
//  Copyright © 2018 ekBana. All rights reserved.
//

import Foundation
import ARKit
class ThreeDModel  {
    var  url : String?
    var identifier : String?
    var scale : SCNVector3?
    init(url : String? , identifier : String , scale : SCNVector3 ) {
        self.url = url
        self.identifier = identifier
        self.scale = scale
    }

    
    }

