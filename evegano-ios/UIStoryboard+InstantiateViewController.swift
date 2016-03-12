//
//  UIStoryboard+InstantiateViewController.swift
//  evegano-ios
//
//  Created by alexander on 12.03.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import UIKit

extension UIStoryboard {
    public func instantiateViewController<T where T: UIViewController, T: StoryboardIdentifierProtocol>() -> T {
        return instantiateViewControllerWithIdentifier(T.storyboardIdentifier()) as! T
    }
}