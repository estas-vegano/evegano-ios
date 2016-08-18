//
//  CameraBorderView.swift
//  evegano-ios
//
//  Created by alexander on 10.04.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import UIKit

class CameraBorderView: UIView {
    //MARK: Constants
    private let borderLineWidth: CGFloat = 6.0
    private let borderLineHeight: CGFloat = 20.0
    private let borderLineColor = UIColor(hex: 0x8AC349)!
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        borderLineColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        CGContextSetRGBStrokeColor(context, r, g, b, 1.0)
        CGContextSetLineWidth(context, self.borderLineWidth)
        
        CGContextMoveToPoint(context, 0, 0)
        CGContextAddLineToPoint(context, 0, self.borderLineHeight)
        CGContextMoveToPoint(context, 0,0)
        CGContextAddLineToPoint(context, self.borderLineHeight, 0)
        
        CGContextMoveToPoint(context, self.frame.size.width - self.borderLineHeight, 0)
        CGContextAddLineToPoint(context, self.frame.size.width, 0)
        CGContextMoveToPoint(context, self.frame.size.width, 0)
        CGContextAddLineToPoint(context, self.frame.size.width, self.borderLineHeight)
        
        CGContextMoveToPoint(context, 0, self.frame.size.height - self.borderLineHeight)
        CGContextAddLineToPoint(context, 0, self.frame.size.height)
        CGContextMoveToPoint(context, 0, self.frame.size.height)
        CGContextAddLineToPoint(context, self.borderLineHeight, self.frame.size.height)
        
        CGContextMoveToPoint(context, self.frame.size.width - self.borderLineHeight, self.frame.size.height)
        CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height)
        CGContextMoveToPoint(context, self.frame.size.width, self.frame.size.height - self.borderLineHeight)
        CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height)
        
        CGContextStrokePath(context)
    }
}
