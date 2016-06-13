//
//  AddCategoryViewController.swift
//  evegano-ios
//
//  Created by alexander on 12.03.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import UIKit

protocol AddCategoryViewControllerDelegate {
    func categoryDidSelect(category: Category)
}

class AddCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, StoryboardIdentifierProtocol {
    //constants
    static let storyboardId = "AddCategoryViewControllerId"
    //variables
    var category: Category?
    var categories = [Category]()
    
    var delegate: AddCategoryViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = self.category {
            loadSubategories()
        } else {
            loadCategories()
        }
    }
    
    func loadCategories() {
        let spiner = LoaderView(loaderType: .LoaderTypeBigAtTop, view: self.view)
        spiner.startAnimating()
        self.tableView.hidden = true
        ApiRequest().requestCategories { (result, error) in
            spiner.stopAnimating()
            self.tableView.hidden = false
            if let categories = result {
                self.categories = categories
            }
            self.tableView.reloadData()
        }
    }
    func loadSubategories() {
        let spiner = LoaderView(loaderType: .LoaderTypeBigAtTop, view: self.view)
        spiner.startAnimating()
        self.tableView.hidden = true
        ApiRequest().requestSubcategories((self.category?.categoryId)!) { (result, error) in
            spiner.stopAnimating()
            self.tableView.hidden = false
            if let categories = result?.children {
                self.categories = categories
            }
            self.tableView.reloadData()
        }
    }
    func goBackAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    //IBActions
    @IBAction func closeButtonDown(sender: UIButton) {
        goBackAction()
    }
    //UITableViewDelegate methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: SimpleTableViewCell = tableView.dequeueReusableCellWithIdentifier(SimpleTableViewCell.reuseIdentifier()) as! SimpleTableViewCell
        
        let categoryItem: Category = self.categories[indexPath.row]
        cell.setCellTitle(categoryItem.title)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SimpleTableViewCell.viewHeight()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let categoryItem: Category = self.categories[indexPath.row]
        self.delegate?.categoryDidSelect(categoryItem)
        goBackAction()
    }
    //Protocol methods
    static func storyboardIdentifier() -> String {
        return storyboardId
    }
}
