//
//  ProductModel.swift
//  evegano-ios
//
//  Created by alexander on 26.12.15.
//  Copyright © 2015 nazavrik. All rights reserved.
//

import Foundation

final class ProductModel : ResponseObjectSerializable {
    let productId: Int
    let title: String
    var info: String?
    var photo: String?
    var producer: ProducerModel
    var category: CategoryModel
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.productId = representation.valueForKeyPath("id") as! Int
        self.title = representation.valueForKeyPath("title") as! String
        self.info = representation.valueForKeyPath("info") as? String
        self.photo = representation.valueForKeyPath("photo") as? String
        self.producer = ProducerModel(response: response, representation: representation.valueForKeyPath("producer")!)!
        self.category = CategoryModel(response: response, representation: representation.valueForKeyPath("category")!)!
    }
}