//
//  LoaderView.swift
//  evegano-ios
//
//  Created by alexander on 12.03.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import UIKit

enum LoaderType {
    case LoaderTypeBigAtCenter
    case LoaderTypeBigAtTop
}

class LoaderView: UIView {

    let loaderSize: CGFloat = 60.0
    let loadSizeBig: CGFloat = 80.0
    
    var spinerView: MaterialDesignSpiner?
    
    init(loaderType: LoaderType, view: UIView) {
        var frame: CGRect
        if loaderType == .LoaderTypeBigAtCenter {
            frame = CGRect(x: (view.frame.size.width-self.loadSizeBig)/2, y: (view.frame.size.height-self.loadSizeBig)/2, width: self.loadSizeBig, height: self.loadSizeBig)
        } else {
            frame = CGRect(x: (view.frame.size.width-self.loaderSize)/2, y: (view.frame.size.height-self.loaderSize)/2, width: self.loaderSize, height: self.loaderSize)
        }
        super.init(frame: frame)
        self.spinerView = MaterialDesignSpiner(frame: CGRect(origin: CGPointZero, size: frame.size))
        self.addSubview(self.spinerView!)
        view.addSubview(self)
    }

    convenience init(loaderType: LoaderType) {
        let window: UIWindow = UIApplication.sharedApplication().windows.first!
        self.init(loaderType: .LoaderTypeBigAtCenter, view: window)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating() {
        self.spinerView?.startAnimating()
    }
    
    func stopAnimating() {
        self.spinerView?.stopAnimating()
    }
}
