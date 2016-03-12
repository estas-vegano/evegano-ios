//
//  AddProductViewController.swift
//  evegano-ios
//
//  Created by alexander on 31.01.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController, AddCategoryViewControllerDelegate {
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chooseCategoryButtonDown(sender: UIButton) {
        let viewController: AddCategoryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
        viewController.modalPresentationStyle = .OverCurrentContext
        viewController.delegate = self
        presentViewController(viewController, animated: true) { () -> Void in
            
        }
    }
    
    //AddCategoryViewControllerDelegate
    func categoryDidSelect(category: CategoryItemModel) {
        self.categoryLabel.text = category.title
    }
}
