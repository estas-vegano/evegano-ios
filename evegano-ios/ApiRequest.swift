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

let kBaseUrl: String = "http://evegano.free-node.ru/api"
let kApiVersion: String = "/v1"
let kMethodCheckProduct: String = "/check"
let kMethodCategoryList: String = "/categories"

enum CodeType {
    case BarcodeType
    case QrcodeType
}

class ApiRequest {
    internal func requestCheckProduct(codeId: String, type: String, completionHandler:(result: ProductModel) -> Void) {
        let url = kBaseUrl + kApiVersion + kMethodCheckProduct
        let parameters = ["code": codeId, "type": type]
        let header = ["￼Accept-Language": "en"]
        Alamofire.request(.GET, url, parameters:parameters, headers: header).responseObject { (response: Response<ProductModel, NSError>) in
            completionHandler(result: (response.result.value)!)
        }
    }
    
    internal func requestCategories(completionHandler:(result: [CategoryItemModel]) -> Void ) {
        let url = kBaseUrl + kApiVersion + kMethodCategoryList
        let header = ["￼Accept-Language": "en"]
        Alamofire.request(.GET, url, parameters:nil, headers: header).responseObject { (response: Response<CategoryItemsModel, NSError>) in
            completionHandler(result: (response.result.value?.categories)!)
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