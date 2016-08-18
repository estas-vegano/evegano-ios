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
    
    required init?(representation: AnyObject?) {
        var categories: [Category]?
        if let categoriesObject = representation as? [AnyObject] {
            categories = Category.collection(categoriesObject)
        }
        self.categories = categories != nil ? categories!: [Category]()
    }
}