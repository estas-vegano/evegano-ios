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

class ApiRequest {
    
    enum ResponseServerError: Int {
        case NoError = 0
    }
    
    private let baseURL = "http://evegano.free-node.ru/api"
    private let apiVersion = "/v1"
    
    private enum APIEndpoint: String {
        case CheckProduct = "/check"
        case CategoriesList = "/categories"
        case SubcategoriesList = "/categories/"
        case AddProduct = "/add"
        case AddProducer = "/add-producer"
        case AddImage = "/add/"
    }
    
    private enum HTTPMethod {
        case GET
        case POST
    }
    
    internal func requestCheckProduct(codeId: String, type: String, completion:(result: Product?, error: ApiError?) -> Void) {
        let parameters = ["code": codeId, "type": type]
        ApiRequest().request(.GET, endpoint: .CheckProduct, parameters: parameters) { (result, error) in
            completion(result: Product(representation: result), error: error)
        }
    }
    
    internal func requestAddProduct(parameters: Dictionary<String, AnyObject>, completion:(result: Product?, error: ApiError?) -> Void) {
        ApiRequest().request(.POST, endpoint: .AddProduct, parameters: parameters) { (result, error) -> Void in
            completion(result: Product(representation: result), error: error)
        }
    }
    
    internal func requestAddProducer(title: String, ethical: Bool, completion:(result: Producer?, error: ApiError?) -> Void) {
        let parameters = ["title": title]
        ApiRequest().request(.POST, endpoint: .AddProducer, parameters: parameters) { (result, error) in
            completion(result: Producer(representation: result), error: error)
        }
    }
    
    internal func requestCategories(completion:(result: [Category]?, error: ApiError?) -> Void ) {
        ApiRequest().request(.GET, endpoint: .CategoriesList, parameters: nil) { (result, error) in
            completion(result: Category.collection(result), error: error)
        }
    }
    
    internal func requestAddImage(productId: String, completion:(result: AnyObject?, error: ApiError?) -> Void ) {
        ApiRequest().request(.POST, endpoint: .AddImage, resource: String(productId)+"/photo", parameters: nil) { (result, error) in
            completion(result: result, error: error)
        }
    }
    
    private func request(method: HTTPMethod, endpoint: APIEndpoint, resource: String? = nil, parameters: [String: AnyObject]?, completion:(result: AnyObject?, error: ApiError?)->Void) {
        var url = baseURL + apiVersion + endpoint.rawValue
        if let resources = resource {
            url = url + resources
        }
        let header = ["￼Accept-Language": "en"]
        Alamofire.request(method == .GET ? .GET : .POST, url, parameters:parameters, encoding: method == .GET ? .URL : .JSON, headers: header).responseJSON { response in
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
        ApiRequest().request(.GET, endpoint: .SubcategoriesList, resource: String(categoryId), parameters: nil) { (result, error) in
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