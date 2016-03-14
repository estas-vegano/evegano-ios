//
//  AddProductViewController.swift
//  evegano-ios
//
//  Created by alexander on 31.01.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController, AddCategoryViewControllerDelegate {
    
    var productModel: ProductModel = ProductModel()
    var isSubcategory: Bool = false
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var subcategoryView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //UI
    func updateUI() {
        if let category = self.productModel.category {
            self.categoryLabel.text = category.title
            self.subcategoryView.hidden = false
        } else {
            self.categoryLabel.text = "Выберете категорию"
            self.subcategoryView.hidden = true
        }
        if let subcategory = self.productModel.category?.sub_category {
            self.subcategoryLabel.text = subcategory.title
        } else {
            self.subcategoryLabel.text = "Выберете подкатегорию"
        }
    }
    //IBActions
    @IBAction func chooseCategoryButtonDown(sender: UIButton) {
        self.isSubcategory = false
        
        let viewController: AddCategoryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
        viewController.modalPresentationStyle = .OverCurrentContext
        viewController.delegate = self
        presentViewController(viewController, animated: true) { () -> Void in
            
        }
    }
    
    @IBAction func chooseSubcategoryButtonDown(sender: UIButton) {
        self.isSubcategory = true
        
        let viewController: AddCategoryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
        viewController.modalPresentationStyle = .OverCurrentContext
        viewController.delegate = self
        viewController.category = self.productModel.category
        presentViewController(viewController, animated: true) { () -> Void in
            
        }
    }
    //AddCategoryViewControllerDelegate
    func categoryDidSelect(category: CategoryModel) {
        if self.isSubcategory {
            self.productModel.category?.sub_category = category
        } else {
            self.productModel.category = category
        }
        updateUI()
    }
}
