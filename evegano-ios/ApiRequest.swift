//
//  ApiRequest.swift
//  evegano-ios
//
//  Created by alexander on 26.12.15.
//  Copyright © 2015 nazavrik. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

let kBaseUrl = "http://evegano.free-node.ru/api"
let kApiVersion = "/v1"
let kMethodCheckProduct = "/check"
let kMethodCategoryList = "/categories"
let kMethodAddProduct = "/add"
let kMethodAddProducer = "/add-producer"

class ApiRequest {
    internal func requestCheckProduct(codeId: String, type: String, completionHandler:(result: Product) -> Void) {
        let url = kBaseUrl + kApiVersion + kMethodCheckProduct
        let parameters = ["code": codeId, "type": type]
        let header = ["￼Accept-Language": "en"]
        Alamofire.request(.GET, url, parameters:parameters, headers: header).responseObject { (response: Response<Product, NSError>) in
            completionHandler(result: (response.result.value)!)
        }
    }
    
    internal func requestCategories(completionHandler:(result: [Category]) -> Void ) {
        let url = kBaseUrl + kApiVersion + kMethodCategoryList
        let header = ["￼Accept-Language": "en"]
        Alamofire.request(.GET, url, parameters:nil, headers: header).responseObject { (response: Response<CategoryItems, NSError>) in
            completionHandler(result: (response.result.value?.categories)!)
        }
    }
    
    internal func requestSubcategories(categoryId: Int, completionHandler:(result: Category) -> Void ) {
        let url = kBaseUrl + kApiVersion + kMethodCategoryList + "/" + String(categoryId)
        let header = ["￼Accept-Language": "en"]
        Alamofire.request(.GET, url, parameters:nil, headers: header).responseObject { (response: Response<Category, NSError>) in
            completionHandler(result: response.result.value!)
        }
    }
    
    internal func requestLoadImage(imageUrl: String, completionHandler:(result:UIImage) -> Void) {
        Alamofire.request(.GET, imageUrl)
            .responseImage { response in
                if let image = response.result.value {
                    completionHandler(result: image)
                }
        }
    }
}