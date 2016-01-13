//
//  ProductModel.swift
//  evegano-ios
//
//  Created by alexander on 26.12.15.
//  Copyright © 2015 nazavrik. All rights reserved.
//

import Foundation

final class EV_ProductModel : ResponseObjectSerializable {
    var productId: Int
    var title: String
    var info: String?
    var photo: String?
    var producer: EV_ProducerModel
    var category: EV_CategoryModel
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.productId = representation.valueForKeyPath("id") as! Int
        self.title = representation.valueForKeyPath("title") as! String
        self.info = representation.valueForKeyPath("info") as? String
        self.photo = representation.valueForKeyPath("photo") as? String
        self.producer = EV_ProducerModel(response: response, representation: representation.valueForKeyPath("producer")!)!
        self.category = EV_CategoryModel(response: response, representation: representation.valueForKeyPath("category")!)!
    }
}