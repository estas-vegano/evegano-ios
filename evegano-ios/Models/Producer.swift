//
//  Producer.swift
//  evegano-ios
//
//  Created by alexander on 26.12.15.
//  Copyright © 2015 nazavrik. All rights reserved.
//

import Foundation

final class Producer : ResponseObjectSerializable {
    let producerId: Int
    var title: String
    var ethical: Bool?
    
    init?(representation: AnyObject?) {
        self.producerId = representation?.valueForKeyPath("id") as! Int
        self.title = representation?.valueForKeyPath("title") as! String
        self.ethical = representation?.valueForKeyPath("ethical") as? Bool
    }
}