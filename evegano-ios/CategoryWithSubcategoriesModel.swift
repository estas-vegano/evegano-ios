//
//  CategoryItemModel.swift
//  evegano-ios
//
//  Created by alexander on 07.02.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import Foundation

final class CategoryWithSubcategoriesModel: ResponseObjectSerializable {
    let categoryId: Int
    let title: String?
    var children: [CategoryModel]?
    
    required init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.categoryId = representation.valueForKeyPath("id") as! Int
        self.title = representation.valueForKeyPath("title") as? String
        
        if let children = representation.valueForKeyPath("children") {
            self.children = CategoryModel.collection(response: response, representation: children)
        }
    }
}
