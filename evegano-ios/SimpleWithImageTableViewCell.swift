//
//  SimpleCellWithImage.swift
//  evegano-ios
//
//  Created by alexander on 16.04.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import UIKit

class SimpleWithImageTableViewCell: UITableViewCell, ViewHeightProtocol, ReuseIdentifierProtocol {
    private static let cellHeight: CGFloat = 50.0
    private static let reuseId = "SimpleWithImageTableViewCellId"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    func initWithProductType(productType: ProductType) {
        self.titleLabel.text = productType.rawValue.uppercaseString
        self.iconImageView.image = UIImage(named: productType.rawValue.lowercaseString+"_icon")!
    }
    
    func setCellTitle(title: String?) {
        self.titleLabel.text = title
    }
    //MARK: Protocol methods
    static func viewHeight() -> CGFloat {
        return cellHeight
    }
    
    static func reuseIdentifier() -> String {
        return reuseId
    }
}
