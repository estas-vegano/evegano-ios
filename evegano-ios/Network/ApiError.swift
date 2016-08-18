//
//  Error.swift
//  evegano-ios
//
//  Created by alexander on 22.05.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import Foundation

class ApiError {
    var errorCode: Int?
    var errorMessage: String?
    
    init(errorCode: Int?, errorMessage: String?) {
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }
}