//
//  AddCategoryViewController.swift
//  evegano-ios
//
//  Created by alexander on 12.03.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import UIKit

protocol AddCategoryViewControllerDelegate {
    func categoryDidSelect(category: CategoryItemModel)
}

class AddCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, StoryboardIdentifierProtocol {
    //constants
    static let storyboardId: String = "AddCategoryViewControllerId"
    //variables
    var categories: [CategoryItemModel] = []
    
    var delegate: AddCategoryViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData() {
        let spiner = LoaderView(loaderType: .LoaderTypeBigAtTop, view: self.view)
        spiner.startAnimating()
        self.tableView.hidden = true
        ApiRequest().requestCategories { (result:[CategoryItemModel]) -> Void in
            spiner.stopAnimating()
            self.tableView.hidden = false
            self.categories = result
            self.tableView.reloadData()
        }
    }
    //Actions
    @IBAction func closeButtonDown(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //UITableViewDelegate methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: SimpleTableViewCell = tableView.dequeueReusableCellWithIdentifier(SimpleTableViewCell.reuseIdentifier()) as! SimpleTableViewCell
        
        let categoryItem: CategoryItemModel = self.categories[indexPath.row]
        cell.setCellTitle(categoryItem.title)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SimpleTableViewCell.viewHeight()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let categoryItem: CategoryItemModel = self.categories[indexPath.row]
        self.delegate?.categoryDidSelect(categoryItem)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //Protocol methods
    static func storyboardIdentifier() -> String {
        return storyboardId
    }
}