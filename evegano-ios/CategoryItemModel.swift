//
//  CategoryItemModel.swift
//  evegano-ios
//
//  Created by alexander on 07.02.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import Foundation

final class CategoryItemModel: ResponseObjectSerializable, ResponseCollectionSerializable {
    let categoryId: Int
    let title: String?
    
    required init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.categoryId = representation.valueForKeyPath("id") as! Int
        self.title = representation.valueForKeyPath("title") as? String
    }
    
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [CategoryItemModel] {
        var categories: [CategoryItemModel] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for userRepresentation in representation {
                if let category = CategoryItemModel(response: response, representation: userRepresentation) {
                    categories.append(category)
                }
            }
        }
        
        return categories
    }
}
