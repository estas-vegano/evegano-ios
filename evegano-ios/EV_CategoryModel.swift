//
//  EV_CategoryModel.swift
//  evegano-ios
//
//  Created by alexander on 26.12.15.
//  Copyright © 2015 nazavrik. All rights reserved.
//

import Foundation

class EV_CategoryModel {
    let categoryId: Int
    var title: String?
    var sub_category: EV_CategoryModel?
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.categoryId = representation.valueForKeyPath("id") as! Int
        self.title = representation.valueForKeyPath("title") as? String
        if let subCategory = representation.valueForKeyPath("sub") {
            self.sub_category = EV_CategoryModel(response: response, representation:subCategory)
        }
    }
}