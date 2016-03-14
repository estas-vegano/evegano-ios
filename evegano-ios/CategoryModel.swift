//
//  CategoryModel.swift
//  evegano-ios
//
//  Created by alexander on 26.12.15.
//  Copyright © 2015 nazavrik. All rights reserved.
//

import Foundation

final class CategoryModel: ResponseObjectSerializable, ResponseCollectionSerializable {
    let categoryId: Int
    var title: String?
    var sub_category: CategoryModel?
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.categoryId = representation.valueForKeyPath("id") as! Int
        self.title = representation.valueForKeyPath("title") as? String
        if let subCategory = representation.valueForKeyPath("sub") {
            self.sub_category = CategoryModel(response: response, representation:subCategory)
        }
    }
    
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [CategoryModel] {
        var categories: [CategoryModel] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for userRepresentation in representation {
                if let category = CategoryModel(response: response, representation: userRepresentation) {
                    categories.append(category)
                }
            }
        }
        
        return categories
    }
}