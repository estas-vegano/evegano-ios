//
//  SimpleTableViewCell.swift
//  evegano-ios
//
//  Created by alexander on 12.03.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import UIKit

class SimpleTableViewCell: UITableViewCell, ViewHeightProtocol, ReuseIdentifierProtocol {

    private static let cellHeight: CGFloat = 44.0
    private static let reuseId = "SimpleTableViewCellId"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func setCellTitle(title: String?) {
        self.titleLabel.text = title
    }
    
    static func viewHeight() -> CGFloat {
        return cellHeight
    }
    
    static func reuseIdentifier() -> String {
        return reuseId
    }
}
