//
//  Code.swift
//  evegano-ios
//
//  Created by alexander on 26.03.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import Foundation

final class Code: ResponseObjectSerializable, ResponseCollectionSerializable {
    var type: String?
    var code: String?
    
    init?(representation: AnyObject?) {
        self.type = representation?.valueForKeyPath("type") as? String
        self.code = representation?.valueForKeyPath("code") as? String
    }
    
    static func collection(representation: AnyObject?) -> [Code] {
        var codes: [Code] = []
        
        if let representation = representation as? [[String: String]] {
            for userRepresentation in representation {
                if let code = Code(representation: userRepresentation) {
                    codes.append(code)
                }
            }
        }
        return codes
    }
}
