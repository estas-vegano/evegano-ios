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
    
    enum ResponseServerError: Int {
        case NoError = 0
    }
    
    internal func requestCheckProduct(codeId: String, type: String, completion:(result: Product?, error: ApiError?) -> Void) {
        let url = kBaseUrl + kApiVersion + kMethodCheckProduct
        let parameters = ["code": codeId, "type": type]
        ApiRequest().request(true, url: url, parameters: parameters) { (result, error) in
            completion(result: Product(representation: result), error: error)
        }
    }
    
    internal func requestAddProduct(parameters: Dictionary<String, AnyObject>, completion:(result: Product?, error: ApiError?) -> Void) {
        let url = kBaseUrl + kApiVersion + kMethodAddProduct
        ApiRequest().request(false, url: url, parameters: parameters) { (result, error) -> Void in
            completion(result: Product(representation: result), error: error)
        }
    }
    
    internal func requestAddProducer(title: String, ethical: Bool, completion:(result: Producer?, error: ApiError?) -> Void) {
        let url = kBaseUrl + kApiVersion + kMethodAddProducer
        let parameters = ["title": title]
        ApiRequest().request(false, url: url, parameters: parameters) { (result, error) in
            completion(result: Producer(representation: result), error: error)
        }
    }
    
    internal func requestCategories(completion:(result: [Category]?, error: ApiError?) -> Void ) {
        let url = kBaseUrl + kApiVersion + kMethodCategoryList
        ApiRequest().request(true, url: url, parameters: nil) { (result, error) in
            completion(result: Category.collection(result), error: error)
        }
    }
    
    internal func request(isGET: Bool, url: String, parameters: [String: AnyObject]?, completion:(result: AnyObject?, error: ApiError?)->Void) {
        let header = ["￼Accept-Language": "en"]
        Alamofire.request(isGET ? .GET : .POST, url, parameters:parameters, headers: header).responseJSON { response in
            if response.result.isSuccess {
                if let JSON = response.result.value as? [String: AnyObject] {
                    let errorCode = JSON["error_code"] as? Int
                    let errorMessage = JSON["error_message"] as? String
                    let error = ApiError(errorCode: errorCode, errorMessage: errorMessage)
                    
                    completion(result: JSON["result"], error: errorCode == 0 ? nil : error)
                }
            } else {
                
            }
        }
    }
    
    internal func requestSubcategories(categoryId: Int, completion:(result: Category?, error: ApiError?) -> Void ) {
        let url = kBaseUrl + kApiVersion + kMethodCategoryList + "/" + String(categoryId)
        ApiRequest().request(true, url: url, parameters: nil) { (result, error) in
            completion(result: Category(representation: result), error: error)
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