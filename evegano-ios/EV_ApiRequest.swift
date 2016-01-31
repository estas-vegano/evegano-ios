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

enum EV_CodeType {
    case EV_BarcodeType
    case EV_QrcodeType
}

class EV_ApiRequest {
    internal func requestCheckProduct(codeId: String, type: String, completionHandler:(result: EV_ProductModel) -> Void) {
        let url = kBaseUrl + kApiVersion + kMethodCheckProduct
        let parameters = ["code": "161", "type": "barcode"]
        let header = ["￼Accept-Language": "en"]
        Alamofire.request(.GET, url, parameters:parameters, headers: header).responseObject { (response: Response<EV_ProductModel, NSError>) in
            completionHandler(result: (response.result.value)!)
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