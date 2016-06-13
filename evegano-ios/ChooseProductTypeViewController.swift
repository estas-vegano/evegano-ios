//
//  ChooseProductTypeViewController.swift
//  evegano-ios
//
//  Created by alexander on 16.04.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import UIKit

protocol ChooseProductTypeViewControllerDelegate {
    func productTypeDidSelect(productType: ProductType)
}

class ChooseProductTypeViewController: UIViewController, StoryboardIdentifierProtocol, UITableViewDelegate, UITableViewDataSource {
    //MARK: constants
    static let storyboardId = "ChooseProductTypeViewControllerId"
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    //MARK: varibales
    var delegate: ChooseProductTypeViewControllerDelegate?
    var productTypes: [ProductType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productTypes = [.Vegan, .Lactovegetarian, .Vegetarian, .Fish, .Meat]
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productTypes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: SimpleWithImageTableViewCell = tableView.dequeueReusableCellWithIdentifier(SimpleWithImageTableViewCell.reuseIdentifier()) as! SimpleWithImageTableViewCell
        
        let productType: ProductType = self.productTypes[indexPath.row]
        cell.initWithProductType(productType)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SimpleWithImageTableViewCell.viewHeight()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let productType: ProductType = self.productTypes[indexPath.row]
        self.delegate?.productTypeDidSelect(productType)
        self.navigationController?.popViewControllerAnimated(true)
    }
    //MARK: IBActions
    @IBAction func backButtonDown(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    //MARK: Protocol methods
    static func storyboardIdentifier() -> String {
        return storyboardId
    }
}
