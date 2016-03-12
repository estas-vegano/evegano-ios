//
//  SimpleTableViewCell.swift
//  evegano-ios
//
//  Created by alexander on 12.03.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import UIKit

class SimpleTableViewCell: UITableViewCell, ViewHeightProtocol, ReuseIdentifierProtocol {
    //constants
    static let cellHeight: CGFloat = 44.0
    static let reuseId: String = "SimpleTableViewCellId"
    
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
