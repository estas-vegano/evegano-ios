//
//  Product.swift
//  evegano-ios
//
//  Created by alexander on 26.12.15.
//  Copyright © 2015 nazavrik. All rights reserved.
//

import Foundation

final class Product : NSObject, ResponseObjectSerializable {
    var productId: Int?
    var title: String?
    var info: String?
    var photo: String?
    var producer: Producer?
    var category: Category?
    var codes: [Code]?
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.productId = representation.valueForKeyPath("id") as? Int
        self.title = representation.valueForKeyPath("title") as? String
        self.info = representation.valueForKeyPath("info") as? String
        self.photo = representation.valueForKeyPath("photo") as? String
        
        if let producer = representation.valueForKeyPath("producer") {
            self.producer = Producer(response: response, representation: producer)
        }
        if let category = representation.valueForKeyPath("category") {
            self.category = Category(response: response, representation: category)
        }
        if let codes = representation.valueForKeyPath("codes") {
            self.codes = Code.collection(response: response, representation: codes)
        }
    }
    
    override init() {
        super.init()
    }
}