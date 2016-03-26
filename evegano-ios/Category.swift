//
//  Category.swift
//  evegano-ios
//
//  Created by alexander on 26.12.15.
//  Copyright © 2015 nazavrik. All rights reserved.
//

import Foundation

final class Category: ResponseObjectSerializable, ResponseCollectionSerializable {
    let categoryId: Int
    let title: String
    var parent: Category?
    var children: [Category]?
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.categoryId = representation.valueForKeyPath("id") as! Int
        self.title = representation.valueForKeyPath("title") as! String
        if let parent = representation.valueForKeyPath("parent") {
            self.parent = Category(response: response, representation: parent)
        }
        if let children = representation.valueForKeyPath("children") {
            self.children = Category.collection(response: response, representation: children)
        }
    }
    
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Category] {
        var categories: [Category] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for userRepresentation in representation {
                if let category = Category(response: response, representation: userRepresentation) {
                    categories.append(category)
                }
            }
        }
        
        return categories
    }
}