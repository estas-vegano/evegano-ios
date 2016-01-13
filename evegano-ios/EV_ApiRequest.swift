//
//  ApiRequest.swift
//  evegano-ios
//
//  Created by alexander on 26.12.15.
//  Copyright © 2015 nazavrik. All rights reserved.
//

import Foundation
import Alamofire

let kBaseUrl: String = "http://evegano.free-node.ru/api"
let kApiVersion: String = "/v1"
let kMethodCheckProduct: String = "/check"

enum EV_CodeType {
    case EV_BarcodeType
    case EV_QrcodeType
}

class EV_ApiRequest {
    internal func requestCheckProduct(codeId: String, type: String) {
        let url = kBaseUrl + kApiVersion + kMethodCheckProduct
        let parameters = ["code": "161", "type": "barcode"]
        let header = ["￼Accept-Language": "en"]
        Alamofire.request(.GET, url, parameters:parameters, headers: header).responseObject { (response: Response<EV_ProductModel, NSError>) in
            print(response)
        }
    }
}