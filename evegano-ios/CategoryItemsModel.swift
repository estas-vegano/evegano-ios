//
//  CategoryItemsModel.swift
//  evegano-ios
//
//  Created by alexander on 06.03.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import Foundation

class CategoryItemsModel: ResponseObjectSerializable {
    let categories: [CategoryItemModel]
    
    required init?(response: NSHTTPURLResponse, representation: AnyObject) {
        var categories: [CategoryItemModel]?
        if let categoriesObject: AnyObject = representation.valueForKeyPath("categories") {
            categories = CategoryItemModel.collection(response: response, representation: categoriesObject)
        }
        self.categories = categories != nil ? categories!: [CategoryItemModel]()
    }
}