//
//  CategoryItems.swift
//  evegano-ios
//
//  Created by alexander on 06.03.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import Foundation

class CategoryItems: ResponseObjectSerializable {
    let categories: [Category]
    
    required init?(response: NSHTTPURLResponse, representation: AnyObject) {
        var categories: [Category]?
        if let categoriesObject: AnyObject = representation.valueForKeyPath("categories") {
            categories = Category.collection(response: response, representation: categoriesObject)
        }
        self.categories = categories != nil ? categories!: [Category]()
    }
}